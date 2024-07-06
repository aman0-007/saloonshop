import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class Savedata {
  Future<void> saveShopOwnerDetails({
    required BuildContext context,
    required TextEditingController shopNameController,
    required TextEditingController shopDescriptionController,
    required Position? currentPosition,
    required List<String> selectedDays,
  }) async {
    if (currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please get the location first.")),
      );
      return;
    }

    try {
      // // Get the placemark from coordinates
      // List<Placemark> placemarks = await placemarkFromCoordinates(
      //   currentPosition.latitude,
      //   currentPosition.longitude,
      // );

      // 'address': placemarks.last.country.toString(),
      // Save shop details to Firestore
      await FirebaseFirestore.instance.collection('shoplocation').add({
        'shopName': shopNameController.text,
        'description': shopDescriptionController.text,
        'location': GeoPoint(currentPosition.latitude, currentPosition.longitude),
        'daysOpen': selectedDays,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Shop details and location saved successfully")),
      );

      // Clear input fields
      shopNameController.clear();
      shopDescriptionController.clear();
    } catch (e) {
      // Handle any errors that occur during geocoding or Firestore access
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save shop details: $e")),
      );
    }
  }
}
