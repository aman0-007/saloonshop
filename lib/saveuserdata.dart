import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Import FirebaseAuth package

class SaveUserData {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;  // Initialize FirebaseAuth

  Future<void> saveUserLoginDetails({
    required BuildContext context,
    required String email,
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
      // Get current user ID
      final User? user = auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user is currently logged in.")),
        );
        return;
      }
      final String userId = user.uid;

      // Save user login details and location to Firestore
      await firestore.collection('users').doc(userId).set({
        'email': email,
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
