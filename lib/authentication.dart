import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Authentication {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: '1050701892775-2gnmu9r8hbt6cn8tbho6a4hvr65eietu.apps.googleusercontent.com',
    scopes: [
      'email',
      'profile',
    ],
  );

  Map<String, bool> _selectedDays = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  Map<String, TimeOfDay?> _openTimes = {};
  Map<String, TimeOfDay?> _closeTimes = {};

  // User Registration
  Future<void> registerUserWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore in the 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User registration successful'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to register user'),
        ),
      );
      print('User registration failed: $e');
    }
  }

  // Shop Registration (Owner Registration)
  Future<void> registerShopWithEmailAndPassword(BuildContext context, String shopName, String email, String password, String registrationGstNumber, Position currentPosition, File profileImage, File bannerImage) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String profileImageUrl = await _uploadImage(profileImage, 'profile_images');
      String bannerImageUrl = await _uploadImage(bannerImage, 'banner_images');

      // Save shop data to Firestore (you can add more fields as needed)
      await FirebaseFirestore.instance.collection('shops').doc(userCredential.user?.uid).set({
        'shopName': shopName,
        'email': email,
        'registrationGstNumber': registrationGstNumber,
        'currentPosition':GeoPoint(currentPosition.latitude, currentPosition.longitude),
        'profileImage': profileImageUrl,
        'bannerImage': bannerImageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Shop registration successful'),
        ),
      );
      // Navigate to the owner side page upon successful registration

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const Ownerside()),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to register shop'),
        ),
      );
      print('Shop registration failed: $e');
    }
  }

  // Sign in with Google
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          // Navigate to Ownerside page upon successful sign-in
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => const Ownerside()),
          // );
          return userCredential.user;
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign in with Google')),
      );
    }
    return null;
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null){
        await saveUserSession(user);
      }

      return user;
    } catch (e) {
      print('Sign-in failed: $e');
      return null;
    }
  }

  Future<String> _uploadImage(File? image, String folderName) async {
    if (image == null) return '';

    try {
      Reference ref = _storage.ref().child(folderName).child('${DateTime.now()}.jpg');
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Image upload failed: $e');
      return '';
    }
  }

  Future<void> registerEmployeeWithEmailAndPassword(
      BuildContext context,
      String employeeName,
      String mobileNumber,
      String email,
      String password,
      File profileImage,
      ) async {
    try {
      // Register the new employee using Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Upload the employee profile image and get the URL
      String profileImageUrl = await _uploadImage(profileImage, 'employee_profile_images');

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? userEmail = prefs.getString('email');

      if (userId != null && userEmail != null) {
        // Save the new employee data to Firestore under the current shop's employees sub-collection
        await FirebaseFirestore.instance
            .collection('shops')
            .doc(userId)
            .collection('employees')
            .doc(userCredential.user?.uid)
            .set({
          'employeeName': employeeName,
          'mobileNumber': mobileNumber,
          'email': email,
          'profileImage': profileImageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Employee registration successful'),
          ),
        );

        // Navigate to the owner side page upon successful registration
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const Ownerside()),
        // );
      } else {
        throw Exception('No logged-in user found');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to register employee'),
        ),
      );
      print('Employee registration failed: $e');
    }
  }


  Future<void> addShopMenuItem(BuildContext context, String name, String price, String time) async {
    try {
      // Get the current logged-in user
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? userEmail = prefs.getString('email');

      if (userId != null && userEmail != null) {
        // Save menu data to Firestore under the current shop's menu sub-collection
        await FirebaseFirestore.instance
            .collection('shops')
            .doc(userId)
            .collection('menu')
            .add({
          'menuName': name,
          'menuPrice': price,
          'menuTime': time,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Menu item added successfully'),
          ),
        );
      } else {
        throw Exception('No logged-in user found');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add menu item'),
        ),
      );
      print('Menu adding failed: $e');
    }
  }


  Future<void> saveUserSession(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.uid);
    await prefs.setString('email', user.email ?? '');
  }

  Future<void> saveSlotTime(String slotTime) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userId') ?? '';

      // Check if document exists
      var shopRef = FirebaseFirestore.instance.collection('shops').doc(userId);
      var shopDoc = await shopRef.get();

      if (shopDoc.exists) {
        // Document exists, update slotTime
        await shopRef.update({
          'slotTime': slotTime,
        });
      } else {
        // Document doesn't exist, create new document with initial data
        await shopRef.set({
          'slotTime': slotTime,
          // Add other initial fields if needed
        });
      }

      print('Slot time updated successfully');
    } catch (e) {
      print('Error updating slot time: $e');
    }
  }

  Future<void> saveShopTimings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userId') ?? '';

      // Check if document exists
      var shopRef = FirebaseFirestore.instance.collection('shops').doc(userId);
      var shopDoc = await shopRef.get();

      // Prepare timings map to store in Firestore
      Map<String, Map<String, dynamic>> timings = {};

      _selectedDays.forEach((day, isSelected) {
        if (isSelected) {
          timings[day] = {
            'openTime': _combineTime(_openTimes[day]!), // Combine open hour and minute
            'closeTime': _combineTime(_closeTimes[day]!), // Combine close hour and minute
          };
        } else {
          timings[day] = {
            'status': 'closed', // Indicate that the shop is closed on this day
          };
        }
      });

      if (shopDoc.exists) {
        // Document exists, update shopTimings
        await shopRef.update({
          'shopTimings': timings,
        });
      } else {
        // Document doesn't exist, create new document with initial data
        await shopRef.set({
          'shopTimings': timings,
          // Add other initial fields if needed
        });
      }

      print('Shop timings updated successfully');
    } catch (e) {
      print('Error updating shop timings: $e');
    }
  }


  // Helper function to combine hour and minute into a single TimeOfDay object
  TimeOfDay _combineTime(TimeOfDay time) {
    return TimeOfDay(hour: time.hour, minute: time.minute);
  }


}


