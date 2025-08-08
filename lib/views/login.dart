import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sun logo + App name
            Center(
              child: Column(
                children: [
                  Opacity(
                    opacity: 0.15,
                    child: Image.asset(
                      'assets/images/sun.png',
                      width: 120,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Oshiwambo Translator",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Email field
            const Text("Email"),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                hintText: "Enter your email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Password field
            const Text("Password"),
            const SizedBox(height: 8),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "********",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.visibility),
              ),
            ),

            const SizedBox(height: 8),

            // Forgot password link
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  // TODO: Navigate to forgot password screen
                },
                child: const Text(
                  "Forgot Password ?",
                  style: TextStyle(color: Colors.pink),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Next button
            ElevatedButton(
              onPressed: () {
                // TODO: Authenticate and navigate
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("NEXT"),
            ),

            const SizedBox(height: 24),

            // OR separator
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("Or"),
                ),
                Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 16),

            // Social buttons
            _socialButton("Continue with Apple", "apple"),
            _socialButton("Continue with Google", "google"),
            _socialButton("Continue with Facebook", "facebook"),

            const SizedBox(height: 16),

            // Create account link
            Center(
              child: GestureDetector(
                onTap: () {
                  // TODO: Navigate to create_account.dart
                },
                child: const Text(
                  "Create a Account",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper for social buttons
  Widget _socialButton(String label, String iconName) {
    IconData icon;
    switch (iconName) {
      case "apple":
        icon = Icons.apple;
        break;
      case "google":
        icon = Icons.g_mobiledata;
        break;
      case "facebook":
        icon = Icons.facebook;
        break;
      default:
        icon = Icons.login;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: OutlinedButton.icon(
        onPressed: () {
          // TODO: Implement auth
        },
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
