import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/ads_provider.dart'; // Updated import
import '../widgets/ad_widget.dart';
import '../models/ads.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    final adsProvider = Provider.of<AdsProvider>(context, listen: false);
    adsProvider.fetchAds('chat').then((_) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final adsProvider = Provider.of<AdsProvider>(context);
    final ads = adsProvider.getAds('chat');

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
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
