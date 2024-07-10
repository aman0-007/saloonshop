import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saloonshop/authentication.dart';
import 'package:saloonshop/shoplogin.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isShopRegister = true; // Initially show Shop Register section
  bool _isTextFieldFocused = false;
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();

  final Authentication _authentication = Authentication();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Container(
            width: deviceWidth * 0.85, // Set width to 85% of device width
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent), // Set container border color
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.black, // Set container body color
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: _isShopRegister ? Colors.blueAccent : Colors.black,
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
                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                ),
                                child: Text(
                                  'Shop Register',
                                  style: TextStyle(
                                    color: _isShopRegister ? Colors.white : Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: !_isShopRegister ? Colors.blueAccent : Colors.black,
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
                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                ),
                                child: Text(
                                  'User Register',
                                  style: TextStyle(
                                    color: !_isShopRegister ? Colors.white : Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        _isShopRegister
                            ? Column(
                          children: [
                            TextFormField(
                              controller: _shopNameController,
                              decoration: InputDecoration(
                                hintText: 'Shop Name',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.1),
                                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              ),
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
                            SizedBox(height: 10.0),
                          ],
                        )
                            : SizedBox(),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
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
                        SizedBox(height: 10.0),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.1),
                                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              ),
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
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () async {
                            String email = _emailController.text;
                            String password = _passwordController.text;
                            try {
                              if (_isShopRegister) {
                                String shopName = _shopNameController.text;
                                //await _authentication.registerShopWithEmailAndPassword(context, shopName, email, password);
                              } else {
                                await _authentication.registerWithEmailAndPassword(context, email, password);
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
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          ),
                          child: Text(
                            'Register',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
