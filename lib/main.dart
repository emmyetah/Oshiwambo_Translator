import 'package:flutter/material.dart';

import 'views/splash_screen.dart';
import 'views/login.dart';
import 'views/create_account.dart';
import 'views/verification.dart';
import 'views/forgot_password.dart';
import 'views/home_engtooshi.dart';
import 'views/home_oshitoeng.dart';
import 'views/favourites.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oshiwambo Translator',
      initialRoute: '/splash',
      routes: {
        '/splash'      : (_) => const SplashScreen(),
        '/login'       : (_) => const LoginScreen(),
        '/signup'      : (_) => const CreateAccountScreen(),
        '/verify'      : (_) => const VerificationScreen(),
        '/forgot'      : (_) => const ForgotPasswordScreen(),
        '/home_eng'    : (_) => const HomeEngToOshi(),
        '/home_oshi'   : (_) => const HomeOshiToEng(),
        '/favourites'  : (_) => const FavouritesScreen(),
      },
      theme: ThemeData(primarySwatch: Colors.pink),
    );
  }
}

