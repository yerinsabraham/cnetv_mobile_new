import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/ads_provider.dart';
import '../widgets/ad_widget.dart';
import '../models/ads.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    final adsProvider = Provider.of<AdsProvider>(context, listen: false);
    adsProvider.fetchAds('live_tv').then((_) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final adsProvider = Provider.of<AdsProvider>(context);
    final ads = adsProvider.getAds('live_tv');

    return Scaffold(
      appBar: AppBar(title: const Text('Live TV')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ads.isEmpty
              ? const Center(child: Text('No Ads available'))
              : ListView.builder(
                  itemCount: ads.length,
                  itemBuilder: (context, index) {
                    final ad = ads[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: AdWidget(
                        ad: ad,
                        isPopup: false, // banner style
                        onCompleted: () {
                          adsProvider.completeReward(ad.id);
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
