import 'package:flutter/material.dart';
import 'package:saloonshop/accountoptionpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:saloonshop/register.dart';
import 'package:saloonshop/shoplogin.dart';
import 'package:saloonshop/userlogin.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: const UserLogin(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Accountoptionpage()),
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
              'assets/splashscreen/splashscreenimg.webp',
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
                child: Image.asset("assets/splashscreen/barber.png"),
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
          )
        ],
      ),
    );
  }
}
