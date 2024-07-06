import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class Savedata {
  Future<void> saveShopOwnerDetails({
    required BuildContext context,
    required TextEditingController shopNameController,
    required TextEditingController shopDescriptionController,
    required Position? currentPosition,
  }) async {
    if (currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please get the location first.")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('shoplocation').add({
      'shopName': shopNameController.text,
      'description': shopDescriptionController.text,
      'location': GeoPoint(currentPosition.latitude, currentPosition.longitude),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Shop details and location saved successfully")),
    );

    shopNameController.clear();
    shopDescriptionController.clear();
  }
}
