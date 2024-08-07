import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:saloonshop/accountoptionpage.dart';
import 'package:saloonshop/userdashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthChecker()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/splashscreen/splashscreenimg.webp', // Adjust path as needed
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.grey.withOpacity(0.5), // Semi-transparent grey color
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5), // Semi-transparent grey color
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35), // Only top left corner is circular
                ),
              ),
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), // Clip image to match container's top left circular edge
                ),
                child: Image.asset("assets/splashscreen/barber.png"), // Adjust path as needed
              ),
            ),
          ),
          Positioned(
            top: deviceHeight * 0.15,
            left: deviceWidth * 0.07,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "LOCATE THE",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7), // Lower the opacity
                    fontWeight: FontWeight.bold,
                    fontSize: 37,
                  ),
                ),
                Text(
                  "NEAREST",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7), // Lower the opacity
                    fontWeight: FontWeight.bold,
                    fontSize: 37,
                  ),
                ),
                Text(
                  "BARBERSHOP",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7), // Lower the opacity
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                  ),
                ),
                Text(
                  "TO YOU",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7), // Lower the opacity
                    fontWeight: FontWeight.bold,
                    fontSize: 37,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  late Future<bool> _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = _checkLoginStatus();
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    print("user id of logged user is : $userId");
    return userId != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          if (snapshot.data!) {
            // User is logged in
            return const Userdashboard(); // Replace with your actual home page widget
          } else {
            // User is not logged in
            return const Accountoptionpage(); // Replace with your actual login page widget
          }
        }
        return const Center(child: Text('Error checking login status'));
      },
    );
  }
}
