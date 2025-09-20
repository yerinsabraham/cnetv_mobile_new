import 'package:flutter/material.dart';
import '../models/ads.dart';
import '../helpers/ads_service.dart';

class AdsProvider extends ChangeNotifier {
  final AdsService _adsService;

  Map<String, List<Ads>> _adsPerPage = {};
  Map<String, bool> _rewardCompleted = {};

  AdsProvider({String? token}) : _adsService = AdsService(token: token);

  /// Fetch ads for a page and cache them
  Future<void> fetchAds(String page) async {
    try {
      List<Ads> ads = await _adsService.getAdsForPage(page);
      _adsPerPage[page] = ads;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching ads: $e');
      _adsPerPage[page] = []; // Ensure UI can handle empty list
      notifyListeners();
    }
  }

  /// Get ads for a page
  List<Ads> getAds(String page) {
    return _adsPerPage[page] ?? [];
  }

  /// Mark reward as completed for a specific ad
  void completeReward(String adId) {
    _rewardCompleted[adId] = true;
    notifyListeners();
    // TODO: Add logic to update user wallet/rewards
  }

  /// Check if reward is completed
  bool isRewardCompleted(String adId) {
    return _rewardCompleted[adId] ?? false;
  }
}
