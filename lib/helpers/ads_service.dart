import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/ads.dart';

class AdsService {
  AdsService({String? token});

  /// Fetch ads for a specific page/tab from local JSON
  Future<List<Ads>> getAdsForPage(String page) async {
    try {
      // Load the mock JSON file
      final String jsonString = await rootBundle.loadString('assets/json/mock_ads.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      // Get ads for the requested page
      final List<dynamic> adsJson = jsonMap[page] as List? ?? [];
      return adsJson.map((e) => Ads.fromJson(e)).toList();
    } catch (e) {
      print('Error loading mock ads: $e');
      return [];
    }
  }

  /// Fetch all ads from local JSON (optional)
  Future<List<Ads>> getAllAds() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/json/mock_ads.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      // Combine all ads from all pages
      List<Ads> allAds = [];
      jsonMap.forEach((key, value) {
        final List<dynamic> adsJson = value as List? ?? [];
        allAds.addAll(adsJson.map((e) => Ads.fromJson(e)));
      });
      return allAds;
    } catch (e) {
      print('Error loading mock ads: $e');
      return [];
    }
  }
}
