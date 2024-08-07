import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:saloonshop/location.dart';
import 'package:saloonshop/shopinfo.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saloonshop/userlogin.dart';

class Userdashboard extends StatefulWidget {
  const Userdashboard({super.key});

  @override
  State<Userdashboard> createState() => _UserdashboardState();
}

class _UserdashboardState extends State<Userdashboard> {
  bool _isTextFieldFocused = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _nearbyShops = [];

  late Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserLocation();
  }

  Future<void> _fetchCurrentUserLocation() async {
    try {
      ULocation uLocation = ULocation();
      uLocation.getCurrentLocation((Position position) {
        setState(() {
          _currentPosition = position;
          print(_currentPosition);
        });
        _fetchNearbyShops();
      });
    } catch (e) {
      print('Error fetching current location: $e');
      // Handle error gracefully
    }
  }

  Future<void> _fetchNearbyShops() async {
    GeoPoint userLocation = GeoPoint(_currentPosition.latitude, _currentPosition.longitude);

    QuerySnapshot shopsSnapshot = await firestore.collection('shops').get();

    List<Map<String, dynamic>> nearbyShops = [];
    for (var shopDoc in shopsSnapshot.docs) {
      GeoPoint shopLocation = shopDoc.get('currentPosition');
      double distance = _calculateDistance(
        userLocation.latitude, userLocation.longitude,
        shopLocation.latitude, shopLocation.longitude,
      );
      const maxDistance = 5.0; // 5 kilometers

      if (distance <= maxDistance) {
        nearbyShops.add({
          ...shopDoc.data() as Map<String, dynamic>,
          'distance': distance,
          'docId': shopDoc.id,
        });
      }
    }

    setState(() {
      _nearbyShops = nearbyShops;
    });
  }


  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    const c = cos;
    final a = 0.5 - c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildGreeting(),
              _buildSearchField(),
              _buildSectionTitle('LATEST VISITS'),
              _buildLatestVisits(deviceWidth, deviceHeight),
              _buildSectionTitle('NEARBY BARBERSHOPS'),
              _buildNearbyBarbershops(deviceWidth, deviceHeight),
              _buildSectionTitle('BEST BARBERS'),
              _buildBestBarbers(deviceWidth, deviceHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    // Get today's date
    final DateTime now = DateTime.now();

    // Format date as "Day, Month Date, Year"
    final String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(now);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.notifications, color: Colors.grey.withOpacity(0.7)),
          Text(
            formattedDate,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.withOpacity(0.7),
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.grey.withOpacity(0.7)),
            onPressed: () async {
              await _clearSharedPreferences();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Userlogin(), // Replace with your login page
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Widget _buildGreeting() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Text("Hey, ", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 27.0)),
          Text("Aman", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 27.0)),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 17.0),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: _isTextFieldFocused ? Colors.grey : Colors.grey.withOpacity(0.5),
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 3.0),
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
          fillColor: Colors.grey.withOpacity(0.1),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 2.0),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onTap: () {
          setState(() {
            _isTextFieldFocused = true;
          });
        },
        onSubmitted: (value) {
          setState(() {
            _isTextFieldFocused = false;
          });
        },
        onChanged: (value) {
          // Handle text changes
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 35.0, top: 23.0, bottom: 11.0),
      child: Text(title,
          style: const TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildLatestVisits(double deviceWidth, double deviceHeight) {
    return FutureBuilder<List<Widget>>(
      future: _buildVisitCards(deviceWidth, deviceHeight),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No favorite shops found.'));
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 29.0),
            child: Row(
              children: snapshot.data!,
            ),
          );
        }
      },
    );
  }


  Future<List<Widget>> _buildVisitCards(double deviceWidth, double deviceHeight) async {
    List<Map<String, dynamic>> favoriteShops = await _fetchFavoriteShops();

    // Ensure unique shops by using a Set to track docIds
    final seen = <String>{};
    favoriteShops.retainWhere((shop) => seen.add(shop['docId'] ?? ''));

    return favoriteShops.map((shop) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShopInfo(
                name: shop['shopName'] ?? 'Shop Name',
                docId: shop['docId'] ?? '', // Pass the docId here
              ),
            ),
          );
        },
        child: Container(
          width: deviceWidth * 0.6, // Adjusted width
          height: deviceHeight * 0.1, // Adjusted height
          margin: EdgeInsets.only(right: deviceWidth * 0.07),
          decoration: BoxDecoration(
            color: Colors.grey[700], // Updated background color
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey[900]!, // Darker grey for border
              width: 2.0,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: deviceWidth * 0.2, // Adjusted width for image
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    shop['profileImage'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  shop['shopName'] ?? 'Shop Name',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Updated text color
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }


  Future<List<Map<String, dynamic>>> _fetchFavoriteShops() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userId') ?? '';

      if (userId.isEmpty) {
        return []; // Return an empty list if no user ID
      }

      final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
      final userSnapshot = await userDoc.get();

      if (!userSnapshot.exists) {
        return []; // Return an empty list if the user document does not exist
      }

      final userData = userSnapshot.data() as Map<String, dynamic>;
      final favoriteShopIds = List<String>.from(userData['favorites'] ?? []);

      if (favoriteShopIds.isEmpty) {
        return []; // Return an empty list if no favorites
      }

      final shopsCollection = FirebaseFirestore.instance.collection('shops');
      final favoriteShopsQuery = shopsCollection.where(FieldPath.documentId, whereIn: favoriteShopIds);
      final shopsSnapshot = await favoriteShopsQuery.get();

      return shopsSnapshot.docs.map((doc) => {
        ...doc.data() as Map<String, dynamic>,
        'docId': doc.id,
      }).toList();
    } catch (e) {
      print('Error fetching favorite shops: $e');
      return []; // Return an empty list in case of error
    }
  }


  Widget _buildNearbyBarbershops(double deviceWidth, double deviceHeight) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 35.0),
      child: Row(
        children: _nearbyShops.isEmpty
            ? [const Center(child: CircularProgressIndicator())]
            : _nearbyShops.map((shop) {
          return ShopCard(
            shop: shop,
            deviceWidth: deviceWidth,
            deviceHeight: deviceHeight,
          );
        }).toList(),
      ),
    );
  }


  Widget _buildBestBarbers(double deviceWidth, double deviceHeight) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 35.0),
      child: Row(
        children: List.generate(3, (index) => _buildBestBarberCard(deviceWidth, deviceHeight)),
      ),
    );
  }

  Widget _buildBestBarberCard(double deviceWidth, double deviceHeight) {
    return Container(
      width: deviceWidth * 0.47,
      height: deviceHeight * 0.35,
      margin: EdgeInsets.only(right: deviceWidth * 0.07),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromRGBO(128, 128, 128, 0.5),
          width: 2.0,
        ),
      ),
    );
  }
}
class ShopCard extends StatefulWidget {
  final Map<String, dynamic> shop;
  final double deviceWidth;
  final double deviceHeight;

  const ShopCard({
    super.key,
    required this.shop,
    required this.deviceWidth,
    required this.deviceHeight,
  });

  @override
  _ShopCardState createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {
  late Timer _timer;
  bool _isDotVisible = true;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  void _startBlinking() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _isDotVisible = !_isDotVisible;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _getShopStatus(Map<String, dynamic> timings) {
    final DateTime now = DateTime.now();
    final String currentDay = DateFormat('EEEE').format(now);

    if (timings.containsKey(currentDay)) {
      final Map<String, dynamic> dayTiming = timings[currentDay];
      if (dayTiming.containsKey('status')) {
        return dayTiming['status'];
      }

      final String? openTimeStr = dayTiming['openTime'];
      final String? closeTimeStr = dayTiming['closeTime'];

      if (openTimeStr != null && closeTimeStr != null) {
        final DateFormat timeFormat = DateFormat('hh:mm a');
        final DateTime openTime = timeFormat.parse(openTimeStr).copyWith(year: now.year, month: now.month, day: now.day);
        final DateTime closeTime = timeFormat.parse(closeTimeStr).copyWith(year: now.year, month: now.month, day: now.day);

        final DateTime adjustedCloseTime = closeTime.isBefore(openTime) ? closeTime.add(const Duration(days: 1)) : closeTime;

        if (now.isAfter(openTime) && now.isBefore(adjustedCloseTime)) {
          return 'open';
        }
      }
    }
    return 'closed'; // Default if status is unknown or no timings are available
  }

  @override
  Widget build(BuildContext context) {
    final String status = _getShopStatus(widget.shop['shopTimings'] ?? {});

    Color statusColor;
    String statusText;
    Widget statusDot;

    if (status == 'open') {
      statusColor = Colors.green;
      statusText = 'Open Now';
      statusDot = AnimatedOpacity(
        opacity: _isDotVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
      );
    } else {
      statusColor = Colors.red;
      statusText = 'Closed';
      statusDot = Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: statusColor,
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      width: widget.deviceWidth * 0.47,
      height: widget.deviceHeight * 0.35,
      margin: EdgeInsets.only(right: widget.deviceWidth * 0.07),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromRGBO(128, 128, 128, 0.5),
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.grey[900],
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    widget.shop['profileImage'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error, color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.shop['shopName'] ?? 'Shop Name',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    statusDot,
                    const SizedBox(width: 5),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.yellow,
                      size: 12,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${widget.shop['distance']?.toStringAsFixed(2) ?? 'N/A'} km',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      width: widget.deviceWidth * 0.073,
                      height: widget.deviceHeight * 0.04,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.save,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShopInfo(
                                name: widget.shop['shopName'] ?? 'Shop Name',
                                docId: widget.shop['docId'] ?? '',  // Pass the docId here
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: widget.deviceHeight * 0.04,
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                            child: Text(
                              'BOOK NOW',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

