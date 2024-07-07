// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:io';
//
// class Savedata {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final FirebaseStorage storage = FirebaseStorage.instance;
//   final FirebaseAuth auth = FirebaseAuth.instance;
//
//   Future<void> saveShopOwnerDetails({
//     required BuildContext context,
//     required TextEditingController shopNameController,
//     required TextEditingController shopDescriptionController,
//     required TextEditingController shopOpeningTimeController,
//     required TextEditingController shopClosingTimeController,
//     required TextEditingController shopOpenDaysController,
//     required Position? currentPosition,
//     required List<Map<String, dynamic>> services,
//     required File? profileImage,
//     required File? shopImage,
//   }) async {
//     if (currentPosition == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please get the location first.")),
//       );
//       return;
//     }
//
//     try {
//       final User? user = auth.currentUser;
//       if (user == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("User not logged in.")),
//         );
//         return;
//       }
//
//       final String userId = user.uid;
//
//       // Upload profile image to Firebase Storage
//       String? profileImageUrl;
//       if (profileImage != null) {
//         final profileImageRef = storage
//             .ref()
//             .child('users')
//             .child(userId)
//             .child('profile_images')
//             .child('${shopNameController.text}_profile.jpg');
//         await profileImageRef.putFile(profileImage);
//         profileImageUrl = await profileImageRef.getDownloadURL();
//       }
//
//       // Upload shop image to Firebase Storage
//       String? shopImageUrl;
//       if (shopImage != null) {
//         final shopImageRef = storage
//             .ref()
//             .child('users')
//             .child(userId)
//             .child('shop_images')
//             .child('${shopNameController.text}_shop.jpg');
//         await shopImageRef.putFile(shopImage);
//         shopImageUrl = await shopImageRef.getDownloadURL();
//       }
//
//       // Save shop details to Firestore
//       final shopData = {
//         'shopName': shopNameController.text,
//         'description': shopDescriptionController.text,
//         'openingTime': shopOpeningTimeController.text,
//         'closingTime': shopClosingTimeController.text,
//         'openDays': shopOpenDaysController.text,
//         'location': GeoPoint(currentPosition.latitude, currentPosition.longitude),
//         'profileImageUrl': profileImageUrl,
//         'shopImageUrl': shopImageUrl,
//         'services': services.map((service) => {
//           'serviceName': (service['serviceName'] as TextEditingController).text,
//           'servicePrice': (service['servicePrice'] as TextEditingController).text,
//           'serviceTime': service['serviceTime'],
//         }).toList(),
//       };
//
//       await firestore
//           .collection('users')
//           .doc(userId)
//           .collection('shops')
//           .doc(shopNameController.text)
//           .set(shopData);
//
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Shop details and location saved successfully")),
//       );
//
//       // Clear input fields
//       shopNameController.clear();
//       shopDescriptionController.clear();
//       shopOpeningTimeController.clear();
//       shopClosingTimeController.clear();
//       shopOpenDaysController.clear();
//       for (var service in services) {
//         (service['serviceName'] as TextEditingController).clear();
//         (service['servicePrice'] as TextEditingController).clear();
//       }
//     } catch (e) {
//       // Handle any errors that occur during Firebase Storage or Firestore access
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to save shop details: $e")),
//       );
//     }
//   }
// }




import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class Savedata {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> saveShopOwnerDetails({
    required BuildContext context,
    required TextEditingController shopNameController,
    required TextEditingController shopDescriptionController,
    required DateTime? shopOpeningTime,
    required DateTime? shopClosingTime,
    required TextEditingController shopOpenDaysController,
    required Position? currentPosition,
    required List<Map<String, dynamic>> services,
    required PlatformFile? profileImage,
    required PlatformFile? shopImage,
  }) async {
    if (currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please get the location first.")),
      );
      return;
    }

    try {
      final User? user = auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in.")),
        );
        return;
      }

      final String userId = user.uid;

      // Upload profile image to Firebase Storage
      String? profileImageUrl;
      if (profileImage != null) {
        final profileImageRef = storage
            .ref()
            .child('users')
            .child(userId)
            .child('profile_images')
            .child('${shopNameController.text}_profile.jpg');
        if (kIsWeb) {
          await profileImageRef.putData(profileImage.bytes!);
        } else {
          await profileImageRef.putFile(File(profileImage.path!));
        }
        profileImageUrl = await profileImageRef.getDownloadURL();
      }

      // Upload shop image to Firebase Storage
      String? shopImageUrl;
      if (shopImage != null) {
        final shopImageRef = storage
            .ref()
            .child('users')
            .child(userId)
            .child('shop_images')
            .child('${shopNameController.text}_shop.jpg');
        if (kIsWeb) {
          await shopImageRef.putData(shopImage.bytes!);
        } else {
          await shopImageRef.putFile(File(shopImage.path!));
        }
        shopImageUrl = await shopImageRef.getDownloadURL();
      }

      // Save shop details to Firestore
      final shopData = {
        'shopName': shopNameController.text,
        'description': shopDescriptionController.text,
        'openingTime': shopOpeningTime, // Store as DateTime
        'closingTime': shopClosingTime, // Store as DateTime
        'openDays': shopOpenDaysController.text,
        'location': GeoPoint(currentPosition.latitude, currentPosition.longitude),
        'profileImageUrl': profileImageUrl,
        'shopImageUrl': shopImageUrl,
        'services': services.map((service) => {
          'serviceName': (service['serviceName'] as TextEditingController).text,
          'servicePrice': (service['servicePrice'] as TextEditingController).text,
          'serviceTime': service['serviceTime'],
        }).toList(),
      };

      await firestore
          .collection('users')
          .doc(userId)
          .collection('shops')
          .doc(shopNameController.text)
          .set(shopData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Shop details and location saved successfully")),
      );

      // Clear input fields
      shopNameController.clear();
      shopDescriptionController.clear();
      shopOpenDaysController.clear();
      services.forEach((service) {
        (service['serviceName'] as TextEditingController).clear();
        (service['servicePrice'] as TextEditingController).clear();
      });
    } catch (e) {
      // Handle any errors that occur during Firebase Storage or Firestore access
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save shop details: $e")),
      );
    }
  }
}

