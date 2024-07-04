import 'package:flutter/material.dart';

class Shoplogin extends StatefulWidget {
  const Shoplogin({super.key});

  @override
  State<Shoplogin> createState() => _ShoploginState();
}

class _ShoploginState extends State<Shoplogin> {
  bool _isTextFieldFocused = false;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset("assets/logo/shop.png",),
          ),
          SizedBox(height: deviceHeight*0.07),
          Center(
            child: IntrinsicHeight(
              child: Container(
                width: 300,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3), // Adjusted opacity for less blur effect
                      blurRadius: 5, // Reduced blur radius
                      spreadRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      color: Colors.grey, // Color of the divider
                      thickness: 1, // Thickness of the line
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Username',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: _isTextFieldFocused ? Colors.grey : Colors.grey.withOpacity(0.5),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey, // Dark grey color when focused
                            width: 2.0,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1), // Light grey background
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
                          borderRadius: BorderRadius.circular(5),
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
                    SizedBox(height: deviceHeight*0.01),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: _isTextFieldFocused ? Colors.grey : Colors.grey.withOpacity(0.5),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey, // Dark grey color when focused
                            width: 2.0,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1), // Light grey background
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
                          borderRadius: BorderRadius.circular(5),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
