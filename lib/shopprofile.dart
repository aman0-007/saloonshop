import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Shopprofile extends StatefulWidget {
  const Shopprofile({Key? key}) : super(key: key);

  @override
  State<Shopprofile> createState() => _ShopprofileState();
}

class _ShopprofileState extends State<Shopprofile> {
  bool isEditMode = false;
  TextEditingController ownerController = TextEditingController();
  TextEditingController shopNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController employeesController = TextEditingController();
  TextEditingController workingHoursController = TextEditingController();

  String bannerImagePath = 'assets/banner_image.jpg'; // Initial image path
  String avatarImagePath = ''; // You can set a default if needed

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        if (source == ImageSource.gallery) {
          // Handle gallery image pick for banner
          bannerImagePath = pickedFile.path;
        } else {
          // Handle camera image pick for avatar
          avatarImagePath = pickedFile.path;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (isEditMode) {
                  _pickImage(ImageSource.gallery); // Handle image selection for banner in edit mode
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  image: DecorationImage(
                    image: AssetImage(bannerImagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (isEditMode) {
                        _pickImage(ImageSource.camera); // Handle image selection for avatar in edit mode
                      }
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage: avatarImagePath.isNotEmpty
                          ? FileImage(File(avatarImagePath))
                          : null,
                      child: avatarImagePath.isEmpty
                          ? Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.blueAccent,
                      )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileRow(
                      title: 'Owner',
                      value: isEditMode
                          ? TextFormField(
                        controller: ownerController,
                        style: TextStyle(color: Colors.blueAccent),
                        decoration: InputDecoration(
                          hintText: 'Enter owner name',
                          hintStyle: TextStyle(
                              color: Colors.blueAccent.withOpacity(0.5)),
                        ),
                      )
                          : Text(ownerController.text.isEmpty
                          ? ' - '
                          : ownerController.text),
                    ),
                    ProfileRow(
                      title: 'Shop name',
                      value: isEditMode
                          ? TextFormField(
                        controller: shopNameController,
                        style: TextStyle(color: Colors.blueAccent),
                        decoration: InputDecoration(
                          hintText: 'Enter shop name',
                          hintStyle: TextStyle(
                              color: Colors.blueAccent.withOpacity(0.5)),
                        ),
                      )
                          : Text(shopNameController.text.isEmpty
                          ? ' - '
                          : shopNameController.text),
                    ),
                    ProfileRow(
                      title: 'Description',
                      value: isEditMode
                          ? TextFormField(
                        controller: descriptionController,
                        style: TextStyle(color: Colors.blueAccent),
                        decoration: InputDecoration(
                          hintText: 'Enter description',
                          hintStyle: TextStyle(
                              color: Colors.blueAccent.withOpacity(0.5)),
                        ),
                      )
                          : Text(descriptionController.text.isEmpty
                          ? ' - '
                          : descriptionController.text),
                    ),
                    ProfileRow(
                      title: 'Location',
                      value: isEditMode
                          ? TextFormField(
                        controller: locationController,
                        style: TextStyle(color: Colors.blueAccent),
                        decoration: InputDecoration(
                          hintText: 'Enter location',
                          hintStyle: TextStyle(
                              color: Colors.blueAccent.withOpacity(0.5)),
                        ),
                      )
                          : Text(locationController.text.isEmpty
                          ? ' - '
                          : locationController.text),
                    ),
                    ProfileRow(
                      title: 'Employees',
                      value: isEditMode
                          ? TextFormField(
                        controller: employeesController,
                        style: TextStyle(color: Colors.blueAccent),
                        decoration: InputDecoration(
                          hintText: 'Enter employees count',
                          hintStyle: TextStyle(
                              color: Colors.blueAccent.withOpacity(0.5)),
                        ),
                      )
                          : Text(employeesController.text.isEmpty
                          ? ' - '
                          : employeesController.text),
                    ),
                    ProfileRow(
                      title: 'Working Hours',
                      value: isEditMode
                          ? TextFormField(
                        controller: workingHoursController,
                        style: TextStyle(color: Colors.blueAccent),
                        decoration: InputDecoration(
                          hintText: 'Enter working hours',
                          hintStyle: TextStyle(
                              color: Colors.blueAccent.withOpacity(0.5)),
                        ),
                      )
                          : Text(workingHoursController.text.isEmpty
                          ? ' - '
                          : workingHoursController.text),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.25),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (isEditMode) {
                      // Handle submit action
                      // Typically, you would update data to backend or storage here
                      // For demo purpose, let's assume it's saving data locally
                      // Update values and images with controller values

                      // Optionally, update image paths with new selections
                      // bannerImagePath = ''; // Set new banner image path
                      // avatarImagePath = ''; // Set new avatar image path

                      // Switch back to view mode
                      isEditMode = false;
                    } else {
                      // Switch to edit mode
                      isEditMode = true;
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Colors.blueAccent),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  minimumSize:
                  Size(MediaQuery.of(context).size.width * 0.5, 0),
                ),
                child: Text(
                  isEditMode ? 'Submit' : 'Edit Details',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  final String title;
  final dynamic value; // Changed type to dynamic to accommodate different widgets

  const ProfileRow({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title:',
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Expanded(
            child: value, // Display different widgets based on whether in edit mode or view mode
          ),
        ],
      ),
    );
  }
}
