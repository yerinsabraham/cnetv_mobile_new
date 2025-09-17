import 'package:flutter/foundation.dart';

class AdsProvider with ChangeNotifier {
  int _activeAdsCount = 0;
  int _rewardPoints = 0;

  // Getters
  int get activeAdsCount => _activeAdsCount;
  int get rewardPoints => _rewardPoints;

  // Actions
  void setActiveAds(int count) {
    _activeAdsCount = count;
    notifyListeners();
  }

  void addRewardPoints(int points) {
    _rewardPoints += points;
    notifyListeners();
  }

  void resetRewards() {
    _rewardPoints = 0;
    notifyListeners();
  }
}
