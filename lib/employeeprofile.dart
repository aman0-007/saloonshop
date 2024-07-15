import 'dart:io';

import 'package:flutter/material.dart';
import 'package:saloonshop/Color/colors.dart';

class Employeeprofile extends StatefulWidget {
  const Employeeprofile({super.key});

  @override
  State<Employeeprofile> createState() => _EmployeeprofileState();
}

class _EmployeeprofileState extends State<Employeeprofile> {
  String bannerImagePath = 'assets/banner_image.jpg'; // Initial image path
  String avatarImagePath = ''; // You can set a default if needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                color: AppColors.primaryYellow,
                image: DecorationImage(
                  image: AssetImage(bannerImagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  backgroundImage: avatarImagePath.isNotEmpty
                      ? FileImage(File(avatarImagePath))
                      : null,
                  child: avatarImagePath.isEmpty
                      ? const Icon(
                    Icons.person,
                    size: 80,
                    color: AppColors.primaryYellow,
                  )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileRow(
                      title: 'Owner',
                      value: Text(' - '), // Default value
                    ),
                    ProfileRow(
                      title: 'Shop name',
                      value: Text(' - '), // Default value
                    ),
                    ProfileRow(
                      title: 'Description',
                      value: Text(' - '), // Default value
                    ),
                    ProfileRow(
                      title: 'Location',
                      value: Text(' - '), // Default value
                    ),
                    ProfileRow(
                      title: 'Employees',
                      value: Text(' - '), // Default value
                    ),
                    ProfileRow(
                      title: 'Working Hours',
                      value: Text(' - '), // Default value
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  final String title;
  final Widget value;

  const ProfileRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title:',
            style: const TextStyle(
              color: AppColors.primaryYellow,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: value,
          ),
        ],
      ),
    );
  }
}

