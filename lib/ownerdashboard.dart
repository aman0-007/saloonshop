import 'package:flutter/material.dart';
import 'package:saloonshop/shopprofile.dart';

class Ownerdashboard extends StatefulWidget {
  const Ownerdashboard({super.key});

  @override
  State<Ownerdashboard> createState() => _OwnerdashboardState();
}

class _OwnerdashboardState extends State<Ownerdashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Set drawer icon color to white
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white, // Background color of the avatar
                      child: Icon(
                        Icons.person,
                        size: 40, // Adjust the size of the person icon
                        color: Colors.blueAccent, // Color of the person icon
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Dashboard Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.home, color: Colors.blueAccent),
                      title: Text('Home', style: TextStyle(color: Colors.blueAccent)),
                      onTap: () {
                        //Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Ownerdashboard()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.blueAccent),
                      title: Text('Profile', style: TextStyle(color: Colors.blueAccent)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Shopprofile()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.menu, color: Colors.blueAccent),
                      title: Text('Menu', style: TextStyle(color: Colors.blueAccent)),
                      onTap: () {
                        // Navigate to profile
                      },
                    ),

                    ListTile(
                      leading: Icon(Icons.people, color: Colors.blueAccent),
                      title: Text('Employee', style: TextStyle(color: Colors.blueAccent)),
                      onTap: () {
                        // Navigate to employee
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.calendar_today, color: Colors.blueAccent),
                      title: Text('Appointments', style: TextStyle(color: Colors.blueAccent)),
                      onTap: () {
                        // Navigate to appointments
                      },
                    ),
                    Divider(), // Divider before Sign Out
                    ListTile(
                      leading: Icon(Icons.exit_to_app, color: Colors.redAccent),
                      title: Text('Sign Out', style: TextStyle(color: Colors.redAccent)),
                      onTap: () {
                        // Perform sign out
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Your content widgets here
          ],
        ),
      ),
    );
  }
}

