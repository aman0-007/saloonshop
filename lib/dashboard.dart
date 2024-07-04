import 'package:flutter/material.dart';
import 'package:saloonshop/shopinfo.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isTextFieldFocused = false;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.notifications,color: Colors.grey.withOpacity(0.7)),
                    Text("Monday,July 2024",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey.withOpacity(0.7)),),
                    Icon(Icons.settings,color: Colors.grey.withOpacity(0.7))
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 25.0,right: 10.0,bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Hey,  ",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 27.0),),
                    Text("Aman",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 27.0))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: Colors.grey,fontSize: 17.0),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _isTextFieldFocused ? Colors.grey : Colors.grey.withOpacity(0.5),
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.1),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 2.0),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _isTextFieldFocused = true;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      _isTextFieldFocused = false;
                    });
                  },
                  onChanged: (value) {
                    // Handle text changes
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 35.0,top: 23.0,bottom: 11.0),
                child: Row(
                  children: [
                    Text("LATEST VISITS",style: TextStyle(color: Colors.grey,fontSize: 14.0,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ShopInfo()),
                          );
                        },
                        child: Container(
                          width: deviceWidth * 0.77,
                          height: deviceHeight * 0.08,
                          decoration: BoxDecoration(
                            color: Colors.grey[100], // Light grey background color
                            borderRadius: BorderRadius.circular(10), // Circular edges
                            border: Border.all(
                              color: Colors.grey[400]!, // Dark grey border color
                              width: 2.0, // Increased border width
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: deviceWidth*0.07,),
                      Container(
                        width: deviceWidth * 0.77,
                        height: deviceHeight * 0.08,
                        decoration: BoxDecoration(
                          color: Colors.grey[100], // Light grey background color
                          borderRadius: BorderRadius.circular(10), // Circular edges
                          border: Border.all(
                            color: Colors.grey[400]!, // Dark grey border color
                            width: 2.0, // Increased border width
                          ),
                        ),
                      ),
                      SizedBox(width: deviceWidth*0.07,),
                      Container(
                        width: deviceWidth * 0.77,
                        height: deviceHeight * 0.08,
                        decoration: BoxDecoration(
                          color: Colors.grey[100], // Light grey background color
                          borderRadius: BorderRadius.circular(10), // Circular edges
                          border: Border.all(
                            color: Colors.grey[400]!, // Dark grey border color
                            width: 2.0, // Increased border width
                          ),
                        ),
                      ),
                      SizedBox(width: deviceWidth*0.07,),
                    ],
                  ),
                ),
              ),
          
              const Padding(
                padding: EdgeInsets.only(left: 35.0,top: 23.0,bottom: 11.0),
                child: Row(
                  children: [
                    Text("NEARBY BARBERSHOPS",style: TextStyle(color: Colors.grey,fontSize: 14.0,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        width: deviceWidth * 0.47,
                        height: deviceHeight * 0.35,
                        decoration: BoxDecoration(
                          color: Colors.grey[100], // Light grey background color
                          borderRadius: BorderRadius.circular(10), // Circular edges
                          border: Border.all(
                            color: Colors.grey[400]!, // Dark grey border color
                            width: 2.0, // Increased border width
                          ),
                        ),
                      ),
                      SizedBox(width: deviceWidth*0.097,),
                      Container(
                        width: deviceWidth * 0.47,
                        height: deviceHeight * 0.35,
                        decoration: BoxDecoration(
                          color: Colors.grey[100], // Light grey background color
                          borderRadius: BorderRadius.circular(10), // Circular edges
                          border: Border.all(
                            color: Colors.grey[400]!, // Dark grey border color
                            width: 2.0, // Increased border width
                          ),
                        ),
                      ),
                      SizedBox(width: deviceWidth*0.097,),
                      Container(
                        width: deviceWidth * 0.47,
                        height: deviceHeight * 0.35,
                        decoration: BoxDecoration(
                          color: Colors.grey[100], // Light grey background color
                          borderRadius: BorderRadius.circular(10), // Circular edges
                          border: Border.all(
                            color: Colors.grey[400]!, // Dark grey border color
                            width: 2.0, // Increased border width
                          ),
                        ),
                      ),
                      SizedBox(width: deviceWidth*0.07,),
                    ],
                  ),
                ),
              ),
        
        
              const Padding(
                padding: EdgeInsets.only(left: 35.0,top: 23.0,bottom: 11.0),
                child: Row(
                  children: [
                    Text("BEST BARBERS",style: TextStyle(color: Colors.grey,fontSize: 14.0,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        width: deviceWidth * 0.47,
                        height: deviceHeight * 0.35,
                        decoration: BoxDecoration(
                          color: Colors.grey[100], // Light grey background color
                          borderRadius: BorderRadius.circular(10), // Circular edges
                          border: Border.all(
                            color: Colors.grey[400]!, // Dark grey border color
                            width: 2.0, // Increased border width
                          ),
                        ),
                      ),
                      SizedBox(width: deviceWidth*0.097,),
                      Container(
                        width: deviceWidth * 0.47,
                        height: deviceHeight * 0.35,
                        decoration: BoxDecoration(
                          color: Colors.grey[100], // Light grey background color
                          borderRadius: BorderRadius.circular(10), // Circular edges
                          border: Border.all(
                            color: Colors.grey[400]!, // Dark grey border color
                            width: 2.0, // Increased border width
                          ),
                        ),
                      ),
                      SizedBox(width: deviceWidth*0.097,),
                      Container(
                        width: deviceWidth * 0.47,
                        height: deviceHeight * 0.35,
                        decoration: BoxDecoration(
                          color: Colors.grey[100], // Light grey background color
                          borderRadius: BorderRadius.circular(10), // Circular edges
                          border: Border.all(
                            color: Colors.grey[400]!, // Dark grey border color
                            width: 2.0, // Increased border width
                          ),
                        ),
                      ),
                      SizedBox(width: deviceWidth*0.07,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
