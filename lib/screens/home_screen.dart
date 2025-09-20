import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import '../provider/user_provider.dart';
import '../provider/ads_provider.dart';

// Widgets & Models
import '../widgets/ad_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;
  Timer? _sessionTimer;

  @override
  void initState() {
    super.initState();

    // Fetch ads for "home"
    final adsProvider = Provider.of<AdsProvider>(context, listen: false);
    adsProvider.fetchAds('home').then((_) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });

    // Start periodic token check for auto-logout
    _startSessionTimer();
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Guests skip validation
      if (userProvider.isGuest) return;

      final isValid = await userProvider.checkLoginStatus();
      if (!isValid && mounted) {
        await userProvider.logout();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }

  // Called when ad is completed
  void _handleAdCompletion(String adId) {
    final adsProvider = Provider.of<AdsProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Mark ad as completed in AdsProvider
    adsProvider.completeReward(adId);

    // Add reward points (only for logged-in users)
    if (!userProvider.isGuest) {
      userProvider.addRewardPoints(5); // Example: 5 points per ad
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final adsProvider = Provider.of<AdsProvider>(context);
    final ads = adsProvider.getAds('home');

    return Scaffold(
      appBar: AppBar(
        title: const Text('CNETV Home'),
        actions: [
          if (userProvider.isLoggedIn && !userProvider.isGuest)
            IconButton(
              onPressed: () {
                userProvider.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
            ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === USER INFO BLOCK ===
                  if (userProvider.isGuest) ...[
                    const Text(
                      'Welcome, Guest',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text("Login / Sign Up"),
                    ),
                  ] else if (userProvider.isLoggedIn) ...[
                    Text(
                      'Welcome, ${userProvider.name}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Wallet Balance: \$${userProvider.walletBalance.toStringAsFixed(2)}',
                    ),
                    Text('Reward Points: ${userProvider.rewardPoints}'),
                    Text(
                      userProvider.isEmailVerified
                          ? 'Email Verified ✅'
                          : 'Email Not Verified ❌',
                      style: TextStyle(
                        color: userProvider.isEmailVerified
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  const SizedBox(height: 16),

                  // === ADS LIST ===
                  Expanded(
                    child: ads.isEmpty
                        ? const Center(child: Text('No Ads available'))
                        : ListView.builder(
                            itemCount: ads.length,
                            itemBuilder: (context, index) {
                              final ad = ads[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: AdWidget(
                                  ad: ad,
                                  isPopup: false,
                                  onCompleted: () => _handleAdCompletion(ad.id),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
