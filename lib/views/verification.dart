import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/auth_state.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool _checking = false;
  bool _sending = false;

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _resend() async {
    setState(() => _sending = true);
    try {
      await context.read<AuthState>().resendVerificationEmail();
      _show('Verification email sent. Please check your inbox.');
    } catch (e) {
      _show('Failed to send verification email: $e');
    } finally {
      setState(() => _sending = false);
    }
  }

  Future<void> _checkVerified() async {
    setState(() => _checking = true);
    try {
      final user = await context.read<AuthState>().reloadUser();
      if (user != null && user.emailVerified) {
        if (mounted) {
          _show('Email verified!');
          Navigator.pushNamedAndRemoveUntil(context, '/home_eng', (_) => false);
        }
      } else {
        _show('Not verified yet — please check your email.');
      }
    } catch (e) {
      _show('Could not check verification: $e');
    } finally {
      setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pink = Colors.pink;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Verify your email', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "We've sent a verification link to your email.\nOpen it and then tap Continue.",
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _checking ? null : _checkVerified,
              style: ElevatedButton.styleFrom(
                backgroundColor: pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _checking
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Continue'),
            ),
            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: _sending ? null : _resend,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _sending
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Resend verification email', style: TextStyle(color: Colors.black)),
            ),

            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false),
              child: const Text('Back to Login', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
