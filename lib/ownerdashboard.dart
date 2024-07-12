import 'package:flutter/material.dart';
import 'package:saloonshop/employeemangement.dart';
import 'package:saloonshop/menumanagement.dart';
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
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Set drawer icon color to white
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              const DrawerHeader(
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
                      leading: const Icon(Icons.home, color: Colors.blueAccent),
                      title: const Text('Home', style: TextStyle(color: Colors.blueAccent)),
                      onTap: () {
                        //Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Ownerdashboard()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.blueAccent),
                      title: const Text('Profile', style: TextStyle(color: Colors.blueAccent)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Shopprofile()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.menu, color: Colors.blueAccent),
                      title: const Text('Menu', style: TextStyle(color: Colors.blueAccent)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Menumanagement()),
                        );
                      },
                    ),

                    ListTile(
                      leading: const Icon(Icons.people, color: Colors.blueAccent),
                      title: const Text('Employee', style: TextStyle(color: Colors.blueAccent)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Employeemangement()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                      title: const Text('Appointments', style: TextStyle(color: Colors.blueAccent)),
                      onTap: () {
                        // Navigate to appointments
                      },
                    ),
                    const Divider(), // Divider before Sign Out
                    ListTile(
                      leading: const Icon(Icons.exit_to_app, color: Colors.redAccent),
                      title: const Text('Sign Out', style: TextStyle(color: Colors.redAccent)),
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
      body: const SafeArea(
        child: Column(
          children: [
            // Your content widgets here
          ],
        ),
      ),
    );
  }
}

