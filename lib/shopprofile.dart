import 'package:flutter/material.dart';

class Shopprofile extends StatefulWidget {
  const Shopprofile({Key? key}) : super(key: key);

  @override
  State<Shopprofile> createState() => _ShopprofileState();
}

class _ShopprofileState extends State<Shopprofile> {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                image: DecorationImage(
                  image: AssetImage('assets/banner_image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.blueAccent,
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
                    ProfileRow(title: 'Owner', value: ' - '),
                    ProfileRow(title: 'Shop name', value: ' - '),
                    ProfileRow(title: 'Description', value: ' - '),
                    ProfileRow(title: 'Location', value: ' - '),
                    ProfileRow(title: 'Employees', value: ' - '),
                    ProfileRow(title: 'Working Hours', value: ' - '),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.25),
              child: ElevatedButton(
                onPressed: () {
                  // Handle edit details action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Colors.blueAccent),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 0),
                ),
                child: Text(
                  'Edit Details',
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
  final String value;

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
            child: Text(
              value,
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}






























//
// in this page in the place of value i want text fields which will be activated when the edit details button is clicked also the circular avataar and the banner image will also be activated so that when clicked on it user can add image in it from the gallery
// also the button text will be changed to submit
//
// when the text fields are activated if the user sets image in the banner and circular avataar and enters something in the text fields and clicks on the submit button then again the button text will be set to edit details as previous and all the value and images set will be set to fields and banner and circle