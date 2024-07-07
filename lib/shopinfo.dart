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
                    Padding(
                      padding:EdgeInsets.only( right: deviceWidth*0.68),
                      child: GestureDetector(
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
                    ),
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
                height: deviceHeight * 0.66,
                decoration: BoxDecoration(
                  color: Colors.grey[100], // Light grey background color
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)), // Circular edges
                  border: Border.all(
                    color: Colors.grey[400]!, // Dark grey border color
                    width: 2.0, // Increased border width
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0,left: 33.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: deviceWidth*0.17,
                              height: deviceHeight*0.05,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: deviceHeight*0.005),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("AMAN DWIVEDI",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 19),),
                          ],
                        ),
                        SizedBox(height: deviceHeight*0.004),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.star,color: Colors.grey,),
                            SizedBox(width: deviceWidth*0.007,),
                            Text("4.9",style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.bold),),
                            SizedBox(width: deviceWidth*0.01,),
                            const Icon(Icons.circle,color: Colors.grey,size: 7,),
                            SizedBox(width: deviceWidth*0.01,),
                            const Text("114 reviews", style: TextStyle(color: Colors.grey),)
                          ],
                        ),
                        SizedBox(height: deviceHeight*0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: deviceWidth * 0.77,
                              height: deviceHeight * 0.09,
                              decoration: BoxDecoration(
                                color: Colors.grey[300], // Light grey background color
                                borderRadius: BorderRadius.circular(10), // Circular edges
                                border: Border.all(
                                  color: Colors.grey[400]!, // Dark grey border color
                                  width: 2.0, // Increased border width
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: deviceHeight*0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IntrinsicHeight(
                              child: Container(
                                width: deviceWidth * 0.77,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300], // Light grey background color
                                  borderRadius: BorderRadius.circular(10), // Circular edges
                                  border: Border.all(
                                    color: Colors.grey[400]!, // Dark grey border color
                                    width: 2.0, // Increased border width
                                  ),
                                ),
                                child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(height: deviceHeight*0.03,),
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                        ),
                                        SizedBox(height: deviceHeight*0.03,),
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                        ),
                                        SizedBox(height: deviceHeight*0.03,),
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                        ),
                                        SizedBox(height: deviceHeight*0.03,),
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                        ),
                                        SizedBox(height: deviceHeight*0.03,),
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                        ),
                                        SizedBox(height: deviceHeight*0.03,),
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                        ),
                                        SizedBox(height: deviceHeight*0.03,),
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                        ),
                                        SizedBox(height: deviceHeight*0.03,),
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                        ),
                                        SizedBox(height: deviceHeight*0.03,),
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                        ),
                                        SizedBox(height: deviceHeight*0.03,),
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                        ),
                                        SizedBox(height: deviceHeight*0.03,),
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                        ),
                                        SizedBox(height: deviceHeight*0.03,),
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                width: deviceWidth,
                height: deviceHeight * 0.11,
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Light grey background color
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ), // Circular edges
                  border: Border.all(
                    color: Colors.grey[400]!, // Dark grey border color
                    width: 2.0, // Increased border width
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    width: deviceWidth * 0.67, // Adjust width of the button relative to the container
                    height: deviceHeight * 0.055, // Adjust height of the button
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const Dashboard()),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero, // Remove default padding
                        backgroundColor: Colors.grey, // Button color
                        foregroundColor: Colors.black, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Book Now',
                          style: TextStyle(
                            fontSize: 22, // Adjust text size as needed
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
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
