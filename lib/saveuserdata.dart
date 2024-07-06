import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class SaveUserData {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveUserLoginDetails({
    required BuildContext context,
    required String password,
    required Position? currentPosition,
  }) async {
    if (currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please get the location first.")),
      );
      return;
    }

    try {
      // Save user login details and location to Firestore
      await firestore.collection('users').add({
        'password': password,
        'location': GeoPoint(currentPosition.latitude, currentPosition.longitude),
        // Add more user details as needed
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User login details and location saved successfully")),
      );
    } catch (e) {
      // Handle any errors that occur during Firestore access
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save user login details: $e")),
      );
    }
  }
}
