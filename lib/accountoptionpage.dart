import 'package:flutter/material.dart';
import 'package:saloonshop/dashboard.dart';
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
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onLongPress: () {
                  Future.delayed(const Duration(seconds: 3), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserLogin()),
                    );
                  });
                },
                child: SizedBox(
                  width: deviceWidth * 0.2,
                  height: deviceHeight * 0.2,
                  child: Image.asset("assets/logo/img.png"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
