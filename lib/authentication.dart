import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class Authentication {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: 'YOUR_CLIENT_ID',
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

  Authentication() {
    // Listen to authentication state changes
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is signed in
        print('User is signed in: ${user.email}');
      } else {
        // User is signed out
        print('User is signed out');
      }
    });
  }

  Future<void> registerUserWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

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

  Future<void> registerShopWithEmailAndPassword(BuildContext context, String shopName, String email, String password, String registrationGstNumber, Position currentPosition, File profileImage, File bannerImage) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String profileImageUrl = await _uploadImage(profileImage, 'profile_images');
      String bannerImageUrl = await _uploadImage(bannerImage, 'banner_images');

      await FirebaseFirestore.instance.collection('shops').doc(userCredential.user?.uid).set({
        'shopName': shopName,
        'email': email,
        'registrationGstNumber': registrationGstNumber,
        'currentPosition': GeoPoint(currentPosition.latitude, currentPosition.longitude),
        'profileImage': profileImageUrl,
        'bannerImage': bannerImageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Shop registration successful'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to register shop'),
        ),
      );
      print('Shop registration failed: $e');
    }
  }

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

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      return user;
    } catch (e) {
      print('Sign-in failed: $e');
      return null;
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully logged out'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to log out'),
        ),
      );
      print('Logout failed: $e');
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
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String profileImageUrl = await _uploadImage(profileImage, 'employee_profile_images');

      // Assuming you have a method to get the current shop's ID
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('shops')
            .doc(currentUser.uid) // currentUser.uid represents the shop ID
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
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('shops')
            .doc(currentUser.uid) // currentUser.uid represents the shop ID
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

  Future<void> saveSlotTime(String slotTime) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        var shopRef = FirebaseFirestore.instance.collection('shops').doc(currentUser.uid);
        var shopDoc = await shopRef.get();

        if (shopDoc.exists) {
          await shopRef.update({
            'slotTime': slotTime,
          });
        } else {
          await shopRef.set({
            'slotTime': slotTime,
          });
        }

        print('Slot time updated successfully');
      } else {
        throw Exception('No logged-in user found');
      }
    } catch (e) {
      print('Error updating slot time: $e');
    }
  }

  Future<void> saveShopTimings() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        var shopRef = FirebaseFirestore.instance.collection('shops').doc(currentUser.uid);
        var shopDoc = await shopRef.get();

        Map<String, Map<String, dynamic>> timings = {};

        _selectedDays.forEach((day, isSelected) {
          if (isSelected) {
            timings[day] = {
              'openTime': _combineTime(_openTimes[day]!),
              'closeTime': _combineTime(_closeTimes[day]!),
            };
          } else {
            timings[day] = {
              'status': 'closed',
            };
          }
        });

        if (shopDoc.exists) {
          await shopRef.update({
            'shopTimings': timings,
          });
        } else {
          await shopRef.set({
            'shopTimings': timings,
          });
        }

        print('Shop timings updated successfully');
      } else {
        throw Exception('No logged-in user found');
      }
    } catch (e) {
      print('Error updating shop timings: $e');
    }
  }

  TimeOfDay _combineTime(TimeOfDay time) {
    return TimeOfDay(hour: time.hour, minute: time.minute);
  }
}
