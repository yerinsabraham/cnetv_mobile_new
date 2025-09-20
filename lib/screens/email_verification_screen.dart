import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.email, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              "Check your inbox and click the verification link we sent to your email.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                userProvider.resendVerificationEmail();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Verification email resent")),
                );
              },
              child: const Text("Resend Verification Email"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                userProvider.checkEmailVerification();

                if (userProvider.isEmailVerified) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              child: const Text("I’ve Verified, Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
