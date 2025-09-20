import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import '../provider/ads_provider.dart';
import '../widgets/ad_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loadingAds = true;

  @override
  void initState() {
    super.initState();
    // Fetch ads for the "wallet" section
    final adsProvider = Provider.of<AdsProvider>(context, listen: false);
    adsProvider.fetchAds('wallet').then((_) {
      if (mounted) {
        setState(() {
          _loadingAds = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final adsProvider = Provider.of<AdsProvider>(context);
    final ads = adsProvider.getAds('wallet');

    // If user is not logged in
    if (!userProvider.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Navigate to Login screen
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text("Login to view profile"),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _loadingAds || userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await userProvider.setUser(); // refresh user data
                await adsProvider.fetchAds('wallet'); // refresh ads
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User info
                    Text("Name: ${userProvider.name}",
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text("User ID: ${userProvider.userId}",
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text("Reward Points: ${userProvider.rewardPoints}",
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      "Email Verified: ${userProvider.isEmailVerified ? 'Yes' : 'No'}",
                      style: const TextStyle(fontSize: 16),
                    ),

                    const Divider(height: 32),

                    // Wallet info
                    Text(
                      "Wallet Balance: \$${userProvider.walletBalance.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Ads section
                    Text("Earn More",
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    ads.isEmpty
                        ? const Center(child: Text('No Ads available'))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ads.length,
                            itemBuilder: (context, index) {
                              final ad = ads[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: AdWidget(
                                  ad: ad,
                                  isPopup: false,
                                  onCompleted: () {
                                    adsProvider.completeReward(ad.id);
                                  },
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
