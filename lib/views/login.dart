// lib/views/login.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/auth_state.dart';
import '../state/app_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _loading = false;

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _postLoginSync() async {
    final auth = context.read<AuthState>();
    final app = context.read<AppState>();
    final uid = auth.user?.uid;
    if (uid == null) return;

    // 1) Attach live Firestore sync
    await app.attachUser(uid);

    // 2) One-time migrate any local favourites up to Firestore
    await app.migrateLocalToCloudIfNeeded(uid);
  }

  Future<void> _signInWithEmail() async {
    final auth = context.read<AuthState>();
    setState(() => _loading = true);
    try {
      await auth.signInWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // 🔗 Firestore favourites sync
      await _postLoginSync();

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home_eng');
      }
    } catch (e) {
      _showError("Login failed: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    final auth = context.read<AuthState>();
    setState(() => _loading = true);
    try {
      await auth.signInWithGoogle();

      // 🔗 Firestore favourites sync
      await _postLoginSync();

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home_eng');
      }
    } catch (e) {
      _showError("Google sign-in failed: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),

            // App Title
            const Text(
              "Oshiwambo Translator",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 32),

            // Email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Password
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),

            // Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/forgot'),
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.pink),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Login Button
            ElevatedButton(
              onPressed: _loading ? null : _signInWithEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("NEXT"),
            ),

            const SizedBox(height: 24),

            // Divider
            Row(
              children: const [
                Expanded(child: Divider(color: Colors.grey)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("Or", style: TextStyle(color: Colors.black)),
                ),
                Expanded(child: Divider(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 24),

            // Social login buttons
            _socialButton(
              label: "Continue with Google",
              icon: Icons.g_mobiledata,
              onPressed: _signInWithGoogle,
            ),
            const SizedBox(height: 12),
            _socialButton(
              label: "Continue with Apple",
              icon: Icons.apple,
              onPressed: () {
                // TODO: add Apple sign-in later (needs iOS setup)
              },
            ),
            const SizedBox(height: 12),
            _socialButton(
              label: "Continue with Facebook",
              icon: Icons.facebook,
              onPressed: () {
                // TODO: add Facebook sign-in later
              },
            ),

            const SizedBox(height: 24),

            // Sign up link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don’t have an account? ", style: TextStyle(color: Colors.black)),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: _loading ? null : onPressed,
      icon: Icon(icon, color: Colors.black),
      label: Text(label, style: const TextStyle(color: Colors.black)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: Colors.grey),
      ),
    );
  }
}
