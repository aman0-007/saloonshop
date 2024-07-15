import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:saloonshop/location.dart';
import 'package:saloonshop/shopinfo.dart';
import 'dart:math' show cos, sqrt, asin;

class Userdashboard extends StatefulWidget{
  const Userdashboard({super.key});

  @override
  State<Userdashboard> createState() => _UserdashboardState();
}

class _UserdashboardState extends State<Userdashboard> {
  bool _isTextFieldFocused = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<Map<String, dynamic>> _nearbyShops = [];

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
    if (_currentPosition == null) return;

    GeoPoint userLocation = GeoPoint(_currentPosition.latitude, _currentPosition.longitude);

    print(userLocation);
    QuerySnapshot userSnapshot = await firestore.collection('users').get();
    for (var userDoc in userSnapshot.docs) {
      // Check if the user has a 'shops' collection
      if (await userDoc.reference.collection('shops').snapshots().isEmpty) continue;

      QuerySnapshot shopsSnapshot = await userDoc.reference.collection('shops').get();
      for (var shopDoc in shopsSnapshot.docs) {
        GeoPoint shopLocation = shopDoc.get('currentPosition');
        double distance = _calculateDistance(
          userLocation.latitude, userLocation.longitude,
          shopLocation.latitude, shopLocation.longitude,
        );
        print(distance);
        // Assuming 5 kilometers (5000 meters) as the maximum distance
        const maxDistance = 5.0;
        if (distance <= maxDistance) {
          setState(() {
            _nearbyShops.add(shopDoc.data() as Map<String, dynamic>);
          });
        }
      }
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    const c = cos;
    final a = 0.5 - c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }


  bool _isOpenNow(Timestamp? openingTime, Timestamp? closingTime) {
    if (openingTime == null || closingTime == null) return false;

    DateTime now = DateTime.now();
    DateTime open = openingTime.toDate(); // Convert Timestamp to DateTime
    DateTime close = closingTime.toDate(); // Convert Timestamp to DateTime

    if (now.isAfter(open) && now.isBefore(close)) {
      return true;
    } else {
      return false;
    }
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.notifications, color: Colors.grey.withOpacity(0.7)),
                    Text("Monday, July 2024", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.withOpacity(0.7))),
                    Icon(Icons.settings, color: Colors.grey.withOpacity(0.7))
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Text("Hey, ", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 27.0)),
                    Text("Aman", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 27.0))
                  ],
                ),
              ),
              Padding(
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
              ),
              const Padding(
                padding: EdgeInsets.only(left: 35.0, top: 23.0, bottom: 11.0),
                child: Text("LATEST VISITS", style: TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.bold)),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 35.0),
                child: Row(
                  children: [
                    for (int i = 0; i < 3; i++)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ShopInfo()),
                          );
                        },
                        child: Container(
                          width: deviceWidth * 0.77,
                          height: deviceHeight * 0.08,
                          margin: EdgeInsets.only(right: deviceWidth * 0.07),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey[400]!,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 35.0, top: 23.0, bottom: 11.0),
                child: Text("NEARBY BARBERSHOPS", style: TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.bold)),
              ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 35.0),
            child: Row(
              children: _nearbyShops.isEmpty
                  ? [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ]
                  : _nearbyShops.map((shop) {
                return Container(
                  width: deviceWidth * 0.47,
                  height: deviceHeight * 0.35,
                  margin: EdgeInsets.only(right: deviceWidth * 0.07),
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.grey[900],
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(
                                  shop['profileImageUrl'] ?? '',
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: _isOpenNow(shop['openingTime'], shop['closingTime'])
                                      ? Colors.green
                                      : Colors.red,
                                  size: 10,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  _isOpenNow(shop['openingTime'], shop['closingTime'])
                                      ? 'OPEN NOW'
                                      : 'CLOSED NOW',
                                  style: TextStyle(
                                    color: _isOpenNow(shop['openingTime'], shop['closingTime'])
                                        ? const Color(0xfffdcb6e)
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              shop['shopName'] ?? 'Shop Name',
                              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white),
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
                                  'Calculating distance...', // Placeholder until distance is fetched
                                  style: const TextStyle(fontSize: 12, color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Container(
                                  width: deviceWidth * 0.073,
                                  height: deviceHeight * 0.04,
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
                                      // Handle booking action
                                    },
                                    child: Container(
                                      height: deviceHeight * 0.04,
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
              }).toList(),
            ),
          ),
          const Padding(
                padding: EdgeInsets.only(left: 35.0, top: 23.0, bottom: 11.0),
                child: Text("BEST BARBERS", style: TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.bold)),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 35.0),
                child: Row(
                  children: [
                    for (int i = 0; i < 3; i++)
                      Container(
                        width: deviceWidth * 0.47,
                        height: deviceHeight * 0.35,
                        margin: EdgeInsets.only(right: deviceWidth * 0.07),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey[400]!,
                            width: 2.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
