import 'package:flutter/material.dart';
import 'views/splash_screen.dart'; // ✅ Adjust this path if needed

void main() {
  runApp(const OshiwamboTranslatorApp());
}

class OshiwamboTranslatorApp extends StatelessWidget {
  const OshiwamboTranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oshiwambo Translator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto', // Optional: set default font
      ),
      home: const SplashScreen(), // ✅ Starts with splash screen
    );
  }
}
