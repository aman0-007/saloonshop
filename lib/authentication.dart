import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saloonshop/accountoptionpage.dart';

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
        'role' : "user",
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
        'currentPosition': GeoPoint(currentPosition.latitude, currentPosition.longitude),
        'profileImage': profileImageUrl,
        'bannerImage': bannerImageUrl,
        'role' : "shop",
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
        User? user = userCredential.user;

        if (user != null) {
          // Fetch user role from Firestore
          DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

          if (userDoc.exists) {
            String role = userDoc['role'] ?? '';

            if (role == 'user') {
              // Redirect to user home page
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => const UserHomePage()), // Replace with actual user home page
              // );
            } else if (role == 'shop') {
              // Redirect to shop home page
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => const ShopHomePage()), // Replace with actual shop home page
              // );
            } else {
              // Redirect to a different page if the role is unknown
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => const UnknownRolePage()), // Replace with actual page for unknown roles
              // );
            }
          } else {
            // Handle case where user document does not exist
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User document not found')),
            );
          }
        }
        return user;
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

  Future<void> registerEmployeeWithEmailAndPassword( BuildContext context, String employeeName, String mobileNumber, String email, String password, File profileImage,) async {
    try {
      // Register the new employee using Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Upload the employee profile image and get the URL
      String profileImageUrl = await _uploadImage(profileImage, 'employee_profile_images');

      // Get current user ID
      String? userId = _auth.currentUser?.uid;

      if (userId != null) {
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
      // Get current user ID
      String? userId = _auth.currentUser?.uid;

      if (userId != null) {
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

  // Sign out
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed out')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Accountoptionpage()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign out')),
      );
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }
}

class AuthWrapper extends StatelessWidget {
  final Widget home;
  final Widget login;

  const AuthWrapper({required this.home, required this.login, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return home;
        }
        return login;
      },
    );
  }
}
