// import 'package:flutter/material.dart';
// import 'package:saloonshop/shoplogin.dart';
//
// class Accountoptionpage extends StatefulWidget {
//   const Accountoptionpage({super.key});
//
//   @override
//   State<Accountoptionpage> createState() => _AccountoptionpageState();
// }
//
// class _AccountoptionpageState extends State<Accountoptionpage> {
//   @override
//   Widget build(BuildContext context) {
//     final double deviceWidth = MediaQuery.of(context).size.width;
//     final double deviceHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: Colors.black, // Changed background color to black
//       body: Center(
//         child: Container(
//           width: deviceWidth * 0.85, // 85% of device width
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.yellowAccent), // Yellow accent border
//             borderRadius: BorderRadius.circular(10.0), // Rounded corners
//             color: Colors.transparent, // Transparent body color
//           ),
//           padding: EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 "Login Type",
//                 style: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 18.0),
//               ),
//               SizedBox(height: 10.0),
//               Divider(
//                 color: Colors.grey.withOpacity(0.5),
//                 thickness: 1.0,
//               ),
//               SizedBox(height: 20.0),
//               ElevatedButton(
//                 onPressed: () {
//                   // Handle Teacher Login button press
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.yellowAccent, // Yellow accent background
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30.0), // Circular button
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 20.0),
//                 ),
//                 child: Text(
//                   "Teacher Login",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               SizedBox(height: 10.0),
//               OutlinedButton(
//                 onPressed: () {
//                   // Handle Student Login button press
//                 },
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(color: Colors.yellowAccent), // Yellow accent border
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30.0), // Circular button
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 20.0),
//                 ),
//                 child: Text(
//                   "Student Login",
//                   style: TextStyle(color: Colors.yellowAccent),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:saloonshop/register.dart';
import 'package:saloonshop/shoplogin.dart';

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
              child: Padding(
                padding: const EdgeInsets.only(top: 16,right: 30),
                child: Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.blueAccent,
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
                    border: Border.all(color: Colors.blueAccent), // Blue accent border
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    color: Colors.transparent, // Transparent body color
                  ),
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Login Type",
                        style: TextStyle(color: Colors.blueAccent.withOpacity(0.8), fontSize: 18.0),
                      ),
                      SizedBox(height: 10.0),
                      Divider(
                        color: Colors.blueAccent.withOpacity(0.5),
                        thickness: 1.0,
                      ),
                      SizedBox(height: 20.0),
                      SizedBox(
                        width: deviceWidth * 0.6, // Set button width to 60% of device width
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle Shop Login button press
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent, // Blue accent background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0), // Circular button
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                          ),
                          child: Text(
                            "Shop Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      SizedBox(
                        width: deviceWidth * 0.6, // Set button width to 60% of device width
                        child: OutlinedButton(
                          onPressed: () {
                            // Handle User Login button press
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.blueAccent), // Blue accent border
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0), // Circular button
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                          ),
                          child: Text(
                            "User Login",
                            style: TextStyle(color: Colors.blueAccent),
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
