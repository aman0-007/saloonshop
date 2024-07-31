import 'package:flutter/material.dart';
import 'package:saloonshop/Color/colors.dart';
import 'package:saloonshop/register.dart';
import 'package:saloonshop/userlogin.dart';

class Accountoptionpage extends StatefulWidget {
  const Accountoptionpage({super.key});

  @override
  State<Accountoptionpage> createState() => _AccountoptionpageState();
}

class _AccountoptionpageState extends State<Accountoptionpage> {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black, // Changed background color to black
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              child: const Padding(
                padding: EdgeInsets.only(top: 16,right: 30),
                child: Text(
                  "Register",
                  style: TextStyle(
                    color: AppColors.primaryYellow,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Register()),
                );
              },
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: deviceWidth * 0.85, // 85% of device width
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryYellow), // Blue accent border
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    color: Colors.transparent, // Transparent body color
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Login Type",
                        style: TextStyle(color: AppColors.primaryYellow.withOpacity(0.8), fontSize: 18.0),
                      ),
                      const SizedBox(height: 10.0),
                      Divider(
                        color: AppColors.primaryYellow.withOpacity(0.5),
                        thickness: 1.0,
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: deviceWidth * 0.6, // Set button width to 60% of device width
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => const Shoplogin()),
                            // );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryYellow, // Blue accent background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0), // Circular button
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          ),
                          child: const Text(
                            "Shop Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: deviceWidth * 0.6, // Set button width to 60% of device width
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Userlogin()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primaryYellow), // Blue accent border
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0), // Circular button
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          ),
                          child: const Text(
                            "User Login",
                            style: TextStyle(color: AppColors.primaryYellow),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
