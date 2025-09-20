import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import '../provider/ads_provider.dart'; // Updated import
import '../widgets/ad_widget.dart';
import '../models/ads.dart';

class EarnScreen extends StatefulWidget {
  const EarnScreen({super.key});

  @override
  State<EarnScreen> createState() => _EarnScreenState();
}

class _EarnScreenState extends State<EarnScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    final adsProvider = Provider.of<AdsProvider>(context, listen: false);
    adsProvider.fetchAds('earn').then((_) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final adsProvider = Provider.of<AdsProvider>(context);
    final ads = adsProvider.getAds('earn');

    return Scaffold(
      appBar: AppBar(title: const Text('Earn Coins')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Reward Points: ${userProvider.rewardPoints}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ads.isEmpty
                        ? const Center(child: Text('No Ads available'))
                        : ListView.builder(
                            itemCount: ads.length,
                            itemBuilder: (context, index) {
                              final ad = ads[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: AdWidget(
                                  ad: ad,
                                  isPopup: true, // reward ad with timer
                                  onCompleted: () {
                                    adsProvider.completeReward(ad.id);
                                    userProvider.addRewardPoints(10); // example reward
                                  },
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
