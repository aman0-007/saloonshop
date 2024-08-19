import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saloonshop/bookingbottomsheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopInfo extends StatefulWidget {
  final String name;
  final String docId;

  const ShopInfo({super.key, required this.name, required this.docId});

  @override
  State<ShopInfo> createState() => _ShopInfoState();
}

class _ShopInfoState extends State<ShopInfo> {
  String? _selectedEmployeeId;
  List<Map<String, dynamic>> _employees = [];
  List<Map<String, dynamic>> _menuItems = [];
  final Set<String> _selectedMenuIds = {};
  String? _bannerImageUrl;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchShopDetails();
    _updateFavoriteStatus();
  }

  void _showBookingBottomSheet() {
    final selectedMenuItems = _menuItems
        .where((menuItem) => _selectedMenuIds.contains(menuItem['id']))
        .map((menuItem) => {
      'id': menuItem['id'],
      'menuName': menuItem['menuName'],
      'menuPrice': menuItem['menuPrice'],
    })
        .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return BookingBottomSheet(
          selectedEmployeeId: _selectedEmployeeId,
          selectedMenuItems: selectedMenuItems,
          selectedShopId: widget.docId,
        );
      },
    );
  }



  Future<void> _fetchShopDetails() async {
    try {
      final shopDoc = await FirebaseFirestore.instance
          .collection('shops')
          .doc(widget.docId)
          .get();

      if (shopDoc.exists) {
        final data = shopDoc.data() as Map<String, dynamic>;
        setState(() {
          _bannerImageUrl = data['bannerImage']; // Fetch banner image URL
        });

        // Fetch employees and menu items
        _fetchEmployees();
        _fetchMenuItems();
      }
    } catch (e) {
      print('Error fetching shop details: $e');
    }
  }

  Future<void> _fetchEmployees() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('shops')
          .doc(widget.docId)
          .collection('employees')
          .get();

      final employees = snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();

      setState(() {
        _employees = employees;
      });
    } catch (e) {
      print('Error fetching employees: $e');
    }
  }

  Future<void> _fetchMenuItems() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('shops')
          .doc(widget.docId)
          .collection('menu')
          .get();

      final menuItems = snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();

      setState(() {
        _menuItems = menuItems;
      });
    } catch (e) {
      print('Error fetching menu items: $e');
    }
  }

  void _toggleMenuSelection(String menuId) {
    setState(() {
      if (_selectedMenuIds.contains(menuId)) {
        _selectedMenuIds.remove(menuId);
      } else {
        _selectedMenuIds.add(menuId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image
            if (_bannerImageUrl != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: deviceWidth,
                  height: deviceHeight * 0.37, // Adjust height as needed
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(_bannerImageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: deviceHeight * 0.25, // Placeholder height if no image
              ),

            // Top buttons
            Positioned(
              top: 13,
              left: deviceWidth * 0.05,
              child: _buildTopButtons(deviceWidth),
            ),

            // Info Container
            Positioned(
              bottom: 0.0,
              child: _buildInfoContainer(deviceWidth, deviceHeight),
            ),

            // Bottom button
            Positioned(
              bottom: 0.0,
              child: _buildBottomButton(deviceWidth, deviceHeight),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildTopButtons(double deviceWidth) {
    return Positioned(
      top: 13,
      left: deviceWidth * 0.05,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBackButton(),
          SizedBox(width: deviceWidth * 0.65), // Add spacing here
          _buildImportantButton(),
        ],
      ),
    );
  }


  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(); // Close current page
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[800], // Darker grey
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.grey[600]!, // Darker grey border
            width: 2.0,
          ),
        ),
        child: const Icon(Icons.arrow_back, color: Colors.yellow),
      ),
    );
  }

  Widget _buildImportantButton() {
    return GestureDetector(
      onTap: () async {
        // Get current user ID from SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userId = prefs.getString('userId') ?? '';
        print("user id of logged user is : $userId");

        // Toggle favorite status
        await _toggleFavoriteStatus(userId);

        // Update the favorite status
        await _updateFavoriteStatus();
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[800], // Darker grey
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.grey[600]!, // Darker grey border
            width: 2.0,
          ),
        ),
        child: Icon(
          Icons.label_important_rounded,
          color: _isFavorite ? Colors.yellow : Colors.grey, // Change color based on favorite status
        ),
      ),
    );
  }

  Future<void> _toggleFavoriteStatus(String userId) async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
      final shopDocId = widget.docId;
      final userSnapshot = await userDoc.get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final favorites = Set<String>.from(userData['favorites'] ?? []);

        if (favorites.contains(shopDocId)) {
          // Remove from favorites
          favorites.remove(shopDocId);
        } else {
          // Add to favorites
          favorites.add(shopDocId);
        }

        await userDoc.update({'favorites': favorites.toList()});
      } else {
        // Create new favorites list if user document does not exist
        await userDoc.set({
          'favorites': [shopDocId],
        });
      }
    } catch (e) {
      print('Error toggling favorite status: $e');
    }
  }


  Future<void> _updateFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final userSnapshot = await userDoc.get();
    final shopDocId = widget.docId;

    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      final favorites = Set<String>.from(userData['favorites'] ?? []);
      setState(() {
        _isFavorite = favorites.contains(shopDocId);
      });
    }
  }


  Widget _buildInfoContainer(double deviceWidth, double deviceHeight) {
    return Positioned(
      bottom: 0.0,
      child: Container(
        width: deviceWidth,
        height: deviceHeight * 0.66,
        decoration: BoxDecoration(
          color: Colors.grey[900], // Dark grey background
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          border: Border.all(
            color: Colors.grey[700]!, // Slightly lighter grey border
            width: 2.0,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: deviceHeight * 0.01),
                _buildNameText(),
                SizedBox(height: deviceHeight * 0.01),
                _buildRatingRow(deviceWidth),
                SizedBox(height: deviceHeight * 0.02),
                _buildEmployeeList(deviceWidth),
                SizedBox(height: deviceHeight * 0.00), // Reduced space here
                _buildMenuItemsList(deviceWidth, deviceHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameText() {
    return Text(
      widget.name, // Use the name passed from the constructor
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19),
    );
  }

  Widget _buildRatingRow(double deviceWidth) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.yellow),
        SizedBox(width: deviceWidth * 0.02),
        const Text(
          "4.9",
          style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: deviceWidth * 0.02),
        const Icon(Icons.circle, color: Colors.grey, size: 7),
        SizedBox(width: deviceWidth * 0.02),
        const Text("114 reviews", style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildMenuItemsList(double deviceWidth, double deviceHeight) {
    // Calculate the height to allow scrolling even if all items are visible
    final double menuListHeight = deviceHeight * 0.3; // Adjust as needed

    return SizedBox(
      height: menuListHeight,
      child: SingleChildScrollView(
        child: Column(
          children: _menuItems.map((menuItem) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey[600]!,
                    width: 2.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          menuItem['menuName'] ?? 'Unknown',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.01),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${menuItem['menuPrice']} INR",
                                style: const TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 12,
                                ),
                              ),
                              const TextSpan(
                                text: " • ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: menuItem['menuTime'].toString().contains('0h')
                                    ? menuItem['menuTime'].toString().replaceAll('0h ', '')
                                    : menuItem['menuTime'] ?? 'Unknown',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _selectedMenuIds.contains(menuItem['id']),
                      onChanged: (value) {
                        _toggleMenuSelection(menuItem['id']);
                      },
                      activeColor: Colors.yellow,
                      inactiveTrackColor: Colors.grey[700],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBottomButton(double deviceWidth, double deviceHeight) {
    return Positioned(
      bottom: 0.0,
      child: Container(
        width: deviceWidth,
        height: deviceHeight * 0.11,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          border: Border.all(
            color: Colors.grey[700]!,
            width: 2.0,
          ),
        ),
        child: Center(
          child: SizedBox(
            width: deviceWidth * 0.67,
            height: deviceHeight * 0.055,
            child: ElevatedButton(
              onPressed: () {
                _showBookingBottomSheet(); // Show the bottom sheet
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.yellow, // Button color
                foregroundColor: Colors.black, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Center(
                child: Text(
                  'Book Now',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildEmployeeList(double deviceWidth) {
    return SizedBox(
      height: 150, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _employees.length,
        itemBuilder: (context, index) {
          final employee = _employees[index];
          final isSelected = _selectedEmployeeId == employee['id'];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedEmployeeId = employee['id'];
                print("Employee Id $_selectedEmployeeId");
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.yellow : Colors.transparent,
                        width: 3,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(employee['profileImage'] ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    employee['employeeName'] ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
