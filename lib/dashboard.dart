import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saloonshop/shopinfo.dart';
import 'dart:math' show cos, sqrt, asin;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isTextFieldFocused = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _nearbyShops = [];

  @override
  void initState() {
    super.initState();
    _fetchNearbyShops();
  }

  Future<GeoPoint?> getCurrentUserLocation() async {
    final User? user = auth.currentUser;
    if (user != null) {
      final String userId = user.uid;
      DocumentSnapshot userDoc = await firestore.collection('users').doc(userId).get();
      if (userDoc.exists && userDoc.data() != null) {
        return userDoc.get('location') as GeoPoint?;
      }
    }
    return null;
  }

  Future<void> _fetchNearbyShops() async {
    GeoPoint? userLocation = await getCurrentUserLocation();
    if (userLocation != null) {
      QuerySnapshot userSnapshot = await firestore.collection('users').get();
      for (var userDoc in userSnapshot.docs) {
        // Check if the user has a 'shops' collection
        if (await userDoc.reference.collection('shops').snapshots().isEmpty) continue;

        QuerySnapshot shopsSnapshot = await userDoc.reference.collection('shops').get();
        for (var shopDoc in shopsSnapshot.docs) {
          GeoPoint shopLocation = shopDoc.get('location');
          double distance = _calculateDistance(
              userLocation.latitude, userLocation.longitude,
              shopLocation.latitude, shopLocation.longitude
          );
          if (distance <= 5) {
            setState(() {
              _nearbyShops.add(shopDoc.data() as Map<String, dynamic>);
            });
          }
        }
      }
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    const c = cos;
    final a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
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
                child: const Row(
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
                  children: [
                    for (var shop in _nearbyShops)
                      Container(
                        width: deviceWidth * 0.47,
                        height: deviceHeight * 0.35,
                        margin: EdgeInsets.only(right: deviceWidth * 0.07),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8), // Black with reduced opacity
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color.fromRGBO(128, 128, 128, 0.5), // Grey color with 50% opacity
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0), // Padding around the image
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    color: Colors.grey[900], // Fallback color for loading or error
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9, // Adjust aspect ratio as needed
                                      child: Image.network(
                                        shop['profileImageUrl'] ?? '',
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Center(
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
                                        color: _isOpenNow(shop['openingTime'], shop['closingTime']) ? Colors.green : Colors.red,
                                        size: 10, // Reduced size for icon
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        _isOpenNow(shop['openingTime'], shop['closingTime']) ? 'OPEN NOW' : 'CLOSED NOW',
                                        style: TextStyle(
                                          color: _isOpenNow(shop['openingTime'], shop['closingTime']) ? Color(0xfffdcb6e) : Colors.red, // Custom color for open now
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12, // Reduced font size
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    shop['shopName'] ?? 'Shop Name',
                                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white), // White color for shop name
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.yellow,
                                        size: 12,
                                      ),
                                      SizedBox(width: 5),
                                      FutureBuilder<GeoPoint?>(
                                        future: getCurrentUserLocation(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              'Calculating distance...',
                                              style: TextStyle(fontSize: 12, color: Colors.white),
                                            );
                                          }
                                          if (snapshot.hasError || snapshot.data == null) {
                                            return Text(
                                              'Distance unavailable',
                                              style: TextStyle(fontSize: 12, color: Colors.white),
                                            );
                                          }
                                          GeoPoint? userLocation = snapshot.data;
                                          double distance = _calculateDistance(
                                            userLocation!.latitude,
                                            userLocation.longitude,
                                            shop['location'].latitude,
                                            shop['location'].longitude,
                                          );
                                          return Text(
                                            '${distance.toStringAsFixed(2)} km away',
                                            style: TextStyle(fontSize: 12, color: Colors.white),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Container(
                                        width: deviceWidth * 0.073, // Adjust width as needed
                                        height: deviceHeight * 0.04, // Adjust height as needed
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(5), // Make edges circular
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.save,
                                            color: Colors.white,
                                            size: 16, // Adjust icon size
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10), // Spacer between the two containers
                                      Expanded(
                                        child: Container(
                                          height: deviceHeight * 0.04, // Adjust height as needed
                                          decoration: BoxDecoration(
                                            color: Colors.yellowAccent, // Yellow accent color
                                            borderRadius: BorderRadius.circular(5), // Make edges circular
                                          ),
                                          child: Center(
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),


                  ],
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
