import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode/barcode.dart' as barcode;
import 'package:barcode_widget/barcode_widget.dart';

class IdCardPage extends StatefulWidget {
  const IdCardPage({super.key});

  @override
  State<IdCardPage> createState() => _IdCardPageState();
}

class _IdCardPageState extends State<IdCardPage> {
  String userName = '';
  String studentId = '';
  String userDepartment = '';
  String userYear = '';
  String userRollNo = '';

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        userName = prefs.getString('userName') ?? '';
        studentId = prefs.getString('studentId') ?? '';
        userDepartment = prefs.getString('userDepartment') ?? '';
        userYear = prefs.getString('userYear') ?? '';
        userRollNo = prefs.getString('userRollNo') ?? '';
      });
    } catch (e) {
      log("Something Went Wrong" as num);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  elevation: 4,
                  shadowColor: Colors.blueGrey,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Student Id: "),
                            Text(studentId),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Branch: "),
                            Text(userDepartment),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Year: "),
                            Text(userYear),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Session: "),
                            Text("2023 - 2024"), // You can update this dynamically if needed
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Roll No: "),
                            Text(userRollNo),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        // Generate barcode widget
                        BarcodeWidget(
                          barcode: barcode.Barcode.code128(),
                          data: studentId,
                          height: 50, // Adjust height as needed
                          width: 200, // Adjust width as needed
                          drawText: false, // Hide text below the barcode
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
