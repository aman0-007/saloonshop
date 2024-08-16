import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saloonshop/accountoptionpage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Authentication {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User Registration
  Future<void> registerUserWithEmailAndPassword(BuildContext context, String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore in the 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'name': name,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User registration successful'),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Accountoptionpage()),
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

  Future<void> saveUserSession(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.uid);
    await prefs.setString('email', user.email ?? '');
  }

}


