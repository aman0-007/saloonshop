import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saloonshop/Color/colors.dart';
import 'package:saloonshop/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Employeemangement extends StatefulWidget {
  const Employeemangement({super.key});

  @override
  State<Employeemangement> createState() => _EmployeemangementState();
}

class _EmployeemangementState extends State<Employeemangement> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppColors.primaryYellow,
        title: const Text(
          'Manage Employees',
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

