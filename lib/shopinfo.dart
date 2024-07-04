import 'package:flutter/material.dart';

class ShopInfo extends StatefulWidget {
  const ShopInfo({super.key});

  @override
  State<ShopInfo> createState() => _ShopInfoState();
}

class _ShopInfoState extends State<ShopInfo> {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 13,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // Close current page
                        },
                        child: Container(
                          width: 50, // Adjust width as needed
                          height: 50, // Adjust height as needed
                          decoration: BoxDecoration(
                            color: Colors.grey[100], // Light grey background color
                            borderRadius: BorderRadius.circular(100), // Circular edges
                            border: Border.all(
                              color: Colors.grey[400]!, // Dark grey border color
                              width: 2.0, // Increased border width
                            ),
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.grey),
                        ),
                      ),
                    const SizedBox(width: 290,),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // Close current page
                        },
                        child: Container(
                          width: 50, // Adjust width as needed
                          height: 50, // Adjust height as needed
                          decoration: BoxDecoration(
                            color: Colors.grey[100], // Light grey background color
                            borderRadius: BorderRadius.circular(100), // Circular edges
                            border: Border.all(
                              color: Colors.grey[400]!, // Dark grey border color
                              width: 2.0, // Increased border width
                            ),
                          ),
                          child: const Icon(Icons.label_important_rounded, color: Colors.grey),
                        ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                width: deviceWidth,
                height: deviceHeight * 0.63,
                decoration: BoxDecoration(
                  color: Colors.grey[100], // Light grey background color
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)), // Circular edges
                  border: Border.all(
                    color: Colors.grey[400]!, // Dark grey border color
                    width: 2.0, // Increased border width
                  ),
                ),
                child: const SingleChildScrollView(
                  child: Column(
                    children: [
        
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
