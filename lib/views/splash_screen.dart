import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 6), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Center sun image
          Center(
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/images/sun.png',
                width: 200,
                height: 200,
              ),
            ),
          ),

          // App title
          Center(
            child: Text(
              'Oshiwambo Translator',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.pink[700],
              ),
            ),
          ),

          // Footer text
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Made by Emmy.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.pink[300],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
