import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saloonshop/authentication.dart'; // Replace with correct path to your authentication file
import 'package:saloonshop/shoplogin.dart'; // Replace with correct path to your shop login file
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isShopRegister = true;
  bool _isTextFieldFocused = false;
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _registrationNumberController = TextEditingController();
  final TextEditingController _gstNumberController = TextEditingController();
  File? _profileImage;
  File? _bannerImage;
  final ImagePicker _picker = ImagePicker();
  final Authentication _authentication = Authentication();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Container(
                width: deviceWidth * 0.85,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.black,
                ),
                child: IntrinsicHeight(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color:
                                _isShopRegister ? Colors.blueAccent : Colors.black,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isShopRegister = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                                ),
                                child: Text(
                                  'Shop Register',
                                  style: TextStyle(
                                    color: _isShopRegister
                                        ? Colors.white
                                        : Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color:
                                !_isShopRegister ? Colors.blueAccent : Colors.black,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isShopRegister = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                                ),
                                child: Text(
                                  'User Register',
                                  style: TextStyle(
                                    color: !_isShopRegister
                                        ? Colors.white
                                        : Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Divider(
                            color: Colors.blueAccent.withOpacity(0.5),
                            thickness: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        _isShopRegister
                            ? Column(
                          children: [
                            const SizedBox(height: 10.0),
                            TextFormField(
                              controller: _shopNameController,
                              decoration: InputDecoration(
                                hintText: 'Shop Name',
                                hintStyle: TextStyle(
                                    color: Colors.blueAccent
                                        .withOpacity(0.5)),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent, width: 2.0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.1),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                labelStyle:
                                const TextStyle(color: Colors.white),
                              ),
                              style: const TextStyle(color: Colors.white),
                              onTap: () {
                                setState(() {
                                  _isTextFieldFocused = true;
                                });
                              },
                              onFieldSubmitted: (value) {
                                setState(() {
                                  _isTextFieldFocused = false;
                                });
                              },
                              onChanged: (value) {
                                // Handle text changes
                              },
                            ),
                            const SizedBox(height: 10.0),
                            TextFormField(
                              controller: _registrationNumberController,
                              decoration: InputDecoration(
                                hintText:
                                'Registration Number / GST Number',
                                hintStyle: TextStyle(
                                    color: Colors.blueAccent
                                        .withOpacity(0.5)),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent, width: 2.0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.1),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                labelStyle:
                                const TextStyle(color: Colors.white),
                              ),
                              style: const TextStyle(color: Colors.white),
                              onTap: () {
                                setState(() {
                                  _isTextFieldFocused = true;
                                });
                              },
                              onFieldSubmitted: (value) {
                                setState(() {
                                  _isTextFieldFocused = false;
                                });
                              },
                              onChanged: (value) {
                                // Handle text changes
                              },
                            ),
                            const SizedBox(height: 10.0),
                            // Profile image upload button
                            ElevatedButton.icon(
                              onPressed: () async {
                                final pickedFile = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 50,
                                );
                                if (pickedFile != null) {
                                  setState(() {
                                    _profileImage = File(pickedFile.path);
                                  });
                                }
                              },
                              icon: Icon(Icons.upload),
                              label: Text('Upload Profile Image'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent), // background color
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // foreground color
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                ),
                                minimumSize: MaterialStateProperty.all<Size>(
                                  Size(double.infinity, 0), // full width available
                                ),
                              ),
                            ),


                            const SizedBox(height: 10.0),

                            ElevatedButton.icon(
                              onPressed: () async {
                                final pickedFile = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 50,
                                );
                                if (pickedFile != null) {
                                  setState(() {
                                    _bannerImage = File(pickedFile.path);
                                  });
                                }
                              },
                              icon: Icon(Icons.upload),
                              label: Text('Upload Banner Image'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent), // background color
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // foreground color
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                ),
                                minimumSize: MaterialStateProperty.all<Size>(
                                  Size(double.infinity, 0), // full width available
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),


                            const SizedBox(height: 10.0),


                            ElevatedButton.icon(
                              onPressed: () {
                                // Implement location selection logic
                              },
                              icon: Icon(Icons.location_on),
                              label: Text('Select Location'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent), // Background color
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                ),
                                minimumSize: MaterialStateProperty.all<Size>(
                                  Size(double.infinity, 0), // full width available
                                ),
                              ),
                            ),

                            const SizedBox(height: 10.0),


                          ],
                        )
                            : const SizedBox(),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle:
                            TextStyle(color: Colors.blueAccent.withOpacity(0.5)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5), width: 1.0),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.blueAccent, width: 2.0),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                          style: const TextStyle(color: Colors.white),
                          onTap: () {
                            setState(() {
                              _isTextFieldFocused = true;
                            });
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              _isTextFieldFocused = false;
                            });
                          },
                          onChanged: (value) {
                            // Handle text changes
                          },
                        ),
                        const SizedBox(height: 10.0),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                    color: Colors.blueAccent.withOpacity(0.5)),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent, width: 2.0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.1),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                              ),
                              style: const TextStyle(color: Colors.white),
                              onTap: () {
                                setState(() {
                                  _isTextFieldFocused = true;
                                });
                              },
                              onFieldSubmitted: (value) {
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
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
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
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () async {
                            String email = _emailController.text;
                            String password = _passwordController.text;
                            try {
                              if (_isShopRegister) {
                                String shopName = _shopNameController.text;
                                String registrationNumber =
                                    _registrationNumberController.text;
                                String gstNumber = _gstNumberController.text;
                                // Implement shop registration logic
                                // await _authentication.registerShopWithEmailAndPassword(context, shopName, email, password);
                              } else {
                                // Implement user registration logic
                                await _authentication.registerWithEmailAndPassword(
                                    context, email, password);
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Registration Successful')),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const Shoplogin()),
                              );
                            } catch (e) {
                              // Registration failed, handle error
                              if (e is FirebaseAuthException) {
                                switch (e.code) {
                                  case 'email-already-in-use':
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('This email is already registered.')),
                                    );
                                    break;
                                  case 'weak-password':
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Password is too weak. Please choose a stronger password.')),
                                    );
                                    break;
                                  case 'invalid-email':
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Please enter a valid email address.')),
                                    );
                                    break;
                                  default:
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Registration failed. Please try again later.')),
                                    );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Registration failed. Please try again later.')),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent, // Background color
                            foregroundColor: Colors.white, // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            minimumSize: Size(deviceWidth * 0.55, 0),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                      ],
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
