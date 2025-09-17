import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/ad.dart';
import '../provider/user_provider.dart';
import '../provider/ads_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService(baseUrl: 'https://api.example.com');
  List<Ad> ads = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAds();
  }

  Future<void> loadAds() async {
    final fetchedAds = await api.fetchAds();
    setState(() {
      ads = fetchedAds;
      loading = false;
    });
    // Update provider with number of active ads
    final adsProvider = Provider.of<AdsProvider>(context, listen: false);
    adsProvider.setActiveAds(fetchedAds.length);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final adsProvider = Provider.of<AdsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('CNETV Home')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // User Info
                  Text(
                    userProvider.isLoggedIn
                        ? 'Welcome, ${userProvider.name}'
                        : 'Welcome, Guest',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text('Wallet Balance: \$${userProvider.walletBalance.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  Text('Reward Points: ${adsProvider.rewardPoints}'),
                  const SizedBox(height: 16),
                  // Ads list
                  Expanded(
                    child: ListView.builder(
                      itemCount: ads.length,
                      itemBuilder: (context, index) {
                        final ad = ads[index];
                        return ListTile(
                          leading: Image.network(ad.imageUrl),
                          title: Text(ad.title),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // Simulate watching ad → add points
                              adsProvider.addRewardPoints(10);
                            },
                            child: const Text('+10 Points'),
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
