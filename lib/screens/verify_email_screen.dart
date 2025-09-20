import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isLoading = false;

  Future<void> _resendEmail() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<UserProvider>(context, listen: false)
          .resendVerificationEmail();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verification email resent")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to resend email: $e")),
      );
    }
    setState(() => _isLoading = false);
  }

  Future<void> _checkVerification() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<UserProvider>(context, listen: false)
          .checkEmailVerification();

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (!mounted) return;
      if (userProvider.isEmailVerified) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email not verified yet. Please check your inbox."),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error checking verification: $e")),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                "Verify Your Email",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "We’ve sent a verification link to your email address. "
                "Please check your inbox and click the link to verify.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _checkVerification,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("I’ve Verified"),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _isLoading ? null : _resendEmail,
                child: const Text("Resend Verification Email"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
