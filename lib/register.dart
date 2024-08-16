import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saloonshop/Color/colors.dart';
import 'package:saloonshop/authentication.dart'; // Replace with correct path to your authentication file

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final Authentication _authentication = Authentication();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Container(
            width: deviceWidth * 0.85,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryYellow),
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.black,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20.0),
                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      hintStyle: TextStyle(
                          color: AppColors.primaryYellow.withOpacity(0.5)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.5), width: 1.0),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColors.primaryYellow, width: 2.0),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10.0),
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(
                          color: AppColors.primaryYellow.withOpacity(0.5)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.5), width: 1.0),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColors.primaryYellow, width: 2.0),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10.0),
                  // Password Field
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                              color: AppColors.primaryYellow.withOpacity(0.5)),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.primaryYellow, width: 2.0),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.1),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                        ),
                        style: const TextStyle(color: Colors.white),
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
                      String name = _nameController.text;
                      String email = _emailController.text;
                      String password = _passwordController.text;
                      try {
                        // Implement user registration logic
                        await _authentication.registerUserWithEmailAndPassword(context,name, email, password);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registration Successful')),
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
                      backgroundColor: AppColors.primaryYellow,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
    );
  }
}
