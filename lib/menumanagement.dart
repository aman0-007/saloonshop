import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saloonshop/Color/colors.dart';
import 'package:saloonshop/authentication.dart';

class Menumanagement extends StatefulWidget {
  const Menumanagement({super.key});

  @override
  State<Menumanagement> createState() => _MenumanagementState();
}

class _MenumanagementState extends State<Menumanagement> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppColors.primaryYellow,
        title: const Text(
          'Manage Menu',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Icon color set to white
      ),
      body: Scaffold(
        backgroundColor: Colors.black,
      ),
    );
  }
}
