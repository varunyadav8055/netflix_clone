import 'package:flutter/material.dart';
import 'package:intern_varun/HomeScreen.dart';
import 'package:intern_varun/ModelShow.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ShowListScreen()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
   
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Image.asset(
              'assets/images/logo.png',
              width: screenWidth * 0.6,  
              height: screenHeight * 0.3,  
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text("TV Shows", style: TextStyle(fontSize: screenWidth*0.04, fontWeight: FontWeight.bold,color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
