import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';

/// AuthGuard is a wrapper for any screen that should only be accessible
/// when the user is authenticated. If the user is not authenticated
/// and not in guest mode, they will be redirected to the login screen.
class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // If user is logged in OR using guest mode → allow access
    if (userProvider.isLoggedIn || userProvider.isGuest) {
      return child;
    }

    // Otherwise redirect to login
    return FutureBuilder(
      future: Future.microtask(() {
        Navigator.of(context).pushReplacementNamed('/login');
      }),
      builder: (context, snapshot) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

