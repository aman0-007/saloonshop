import 'dart:io';

import 'package:flutter/material.dart';

class Shopprofile extends StatefulWidget {
  const Shopprofile({Key? key}) : super(key: key);

  @override
  State<Shopprofile> createState() => _ShopprofileState();
}

class _ShopprofileState extends State<Shopprofile> {
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
                color: Colors.blueAccent,
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
                    color: Colors.blueAccent,
                  )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileRow(
                      title: 'Owner',
                      value: const Text(' - '), // Default value
                    ),
                    ProfileRow(
                      title: 'Shop name',
                      value: const Text(' - '), // Default value
                    ),
                    ProfileRow(
                      title: 'Description',
                      value: const Text(' - '), // Default value
                    ),
                    ProfileRow(
                      title: 'Location',
                      value: const Text(' - '), // Default value
                    ),
                    ProfileRow(
                      title: 'Employees',
                      value: const Text(' - '), // Default value
                    ),
                    ProfileRow(
                      title: 'Working Hours',
                      value: const Text(' - '), // Default value
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
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

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
              color: Colors.blueAccent,
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
