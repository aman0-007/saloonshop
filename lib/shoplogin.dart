import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saloonshop/authentication.dart';
import 'package:saloonshop/ownerside.dart';

class Shoplogin extends StatefulWidget {
  const Shoplogin({super.key});

  @override
  State<Shoplogin> createState() => _ShoploginState();
}

class _ShoploginState extends State<Shoplogin> {
  bool _isTextFieldFocused = false;
  bool _isPasswordVisible = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final Authentication _authentication = Authentication();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: deviceHeight * 0.17),
            Container(
              child: Image.asset(
                "assets/logo/shop.png",
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(height: deviceHeight * 0.07),
            Center(
              child: IntrinsicHeight(
                child: Container(
                  width: deviceWidth*0.76,
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      SizedBox(height: deviceHeight * 0.03),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _isTextFieldFocused ? Colors.grey : Colors.grey.withOpacity(0.5),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.1),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                      SizedBox(height: deviceHeight * 0.01),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: _isTextFieldFocused ? Colors.grey : Colors.grey.withOpacity(0.5),
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.1),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                          IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey.withOpacity(0.7),
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: deviceHeight * 0.033),
                      ElevatedButton(
                        onPressed: () async {
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          User? user = await _authentication.signInWithEmailAndPassword(email, password);
                          if (user != null) {

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) =>  const Ownerside()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey, // Button color
                          foregroundColor: Colors.black, // Text color
                          padding: EdgeInsets.symmetric(vertical: deviceHeight*0.013, horizontal: deviceWidth*0.21),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18),
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
