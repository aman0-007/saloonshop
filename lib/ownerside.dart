import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ownerside extends StatefulWidget {
  const Ownerside({super.key});

  @override
  State<Ownerside> createState() => _OwnersideState();
}

class _OwnersideState extends State<Ownerside> {
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopDescriptionController = TextEditingController();
  bool _isTextFieldFocused = false;
  Position? _currentPosition;

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isDenied) {
      // Handle the case when the user denies the permission
    }
  }

  Future<void> getCurrentLocation() async {
    await requestLocationPermission();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  Future<void> saveShopOwnerDetails() async {
    if (_currentPosition == null) {
      // Show a message if location is not fetched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please get the location first.")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('shoplocation').add({
      'shopName': _shopNameController.text,
      'description': _shopDescriptionController.text,
      'location': GeoPoint(_currentPosition!.latitude, _currentPosition!.longitude),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Shop details and location saved successfully")),
    );

    // Clear the text fields after saving
    _shopNameController.clear();
    _shopDescriptionController.clear();
    setState(() {
      _currentPosition = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: IntrinsicHeight(
                child: Container(
                  width: deviceWidth * 0.76,
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Add Details",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      SizedBox(height: deviceHeight * 0.03),
                      TextField(
                        controller: _shopNameController,
                        decoration: InputDecoration(
                          hintText: 'Shop Name',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _isTextFieldFocused ? Colors.grey : Colors.grey.withOpacity(0.5),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.1),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
                            borderRadius: BorderRadius.circular(5),
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
                      SizedBox(height: deviceHeight * 0.01),
                      TextField(
                        controller: _shopDescriptionController,
                        decoration: InputDecoration(
                          hintText: 'Shop Description',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _isTextFieldFocused ? Colors.grey : Colors.grey.withOpacity(0.5),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.1),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
                            borderRadius: BorderRadius.circular(5),
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
                      SizedBox(height: deviceHeight * 0.01),
                      ElevatedButton(
                        onPressed: () async {
                          await getCurrentLocation();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey, // Button color
                          foregroundColor: Colors.black, // Text color
                          padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.013, horizontal: deviceWidth * 0.21),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Get Location',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.033),
                      ElevatedButton(
                        onPressed: () async {
                          await saveShopOwnerDetails();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey, // Button color
                          foregroundColor: Colors.black, // Text color
                          padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.013, horizontal: deviceWidth * 0.21),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
