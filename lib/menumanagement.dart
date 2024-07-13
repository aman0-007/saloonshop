import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saloonshop/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Menu {
  String name;
  String time;
  String price;

  Menu({
    required this.name,
    required this.time,
    required this.price,
  });
}


class Menumanagement extends StatefulWidget {
  const Menumanagement({super.key});

  @override
  State<Menumanagement> createState() => _MenumanagementState();
}

class _MenumanagementState extends State<Menumanagement> {
  late PageController _pageController;
  int _selectedTabIndex = 0; // Track the selected section index

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedTabIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Manage Menu',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Icon color set to white
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    _pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        'My Menu',
                        style: TextStyle(
                          color: _selectedTabIndex == 0
                              ? Colors.blueAccent
                              : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                        width: 100, // Expanded width for the underline
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == 0
                                ? Colors.blueAccent
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        'Manage Menu',
                        style: TextStyle(
                          color: _selectedTabIndex == 1
                              ? Colors.blueAccent
                              : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                        width: 150, // Expanded width for the underline
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == 1
                                ? Colors.blueAccent
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              children: [
                MyMenuSection(),
                ManageMenuSection(
                    onAddMenu: _addNewMenu),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addNewMenu(Menu newMenu) {
    setState(() {
      _pageController.jumpToPage(0); // Switch to My Employees page after adding
    });
  }


}

class MyMenuSection extends StatelessWidget {

  const MyMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
    );
  }
}

class ManageMenuSection extends StatefulWidget {
  final Function(Menu) onAddMenu;

  const ManageMenuSection({super.key,
    required this.onAddMenu,
  });

  @override
  _ManageMenuSectionState createState() => _ManageMenuSectionState();
}

class _ManageMenuSectionState extends State<ManageMenuSection> {
  final TextEditingController _menuNameController = TextEditingController();
  final TextEditingController _menuTimeController = TextEditingController();
  final TextEditingController _menuPriceController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _isTextFieldFocused = false;
  final Authentication _authentication = Authentication();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 2.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(5.0),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear, color: Colors.blueAccent.withOpacity(0.5)),
                onPressed: () {
                  _searchController.clear();
                },
              )
                  : null,
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
          child: Container(
            child: Center(
              child: Text(
                'Manage Menu',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 35.0,bottom: 30.0),
              child: FloatingActionButton(
                onPressed: () {
                  _showAddMenuDialog(context);
                },
                backgroundColor: Colors.blueAccent,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showAddMenuDialog(BuildContext context) {
    Menu newMenu = Menu(
      name: '',
      price: '',
      time: '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Add New Menu',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Colors.blueAccent), // Border color here
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Divider(
                    color: Colors.blueAccent.withOpacity(0.5),
                    thickness: 1.5,
                  ),
                ),
                TextFormField(
                  controller: _menuNameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
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
                const SizedBox(height: 10),
                TextFormField(
                  controller: _menuPriceController,
                  decoration: InputDecoration(
                    hintText: 'Price',
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
                const SizedBox(height: 10),
                TextFormField(
                  controller: _menuTimeController,
                  decoration: InputDecoration(
                    hintText: 'Time',
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
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  String name = _menuNameController.text;
                  String price = _menuPriceController.text;
                  String time = _menuTimeController.text;
                  await _authentication.addShopMenuItem( context, name, price, time);
                  widget.onAddMenu(newMenu);
                  Navigator.of(context).pop();

                }catch (e) {
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
                widget.onAddMenu(newMenu);
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.blueAccent),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

  }
}
