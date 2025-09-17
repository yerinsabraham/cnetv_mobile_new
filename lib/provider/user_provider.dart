import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String _userId = '';
  String _name = '';
  double _walletBalance = 0.0;
  bool _isLoggedIn = false;

  // Getters
  String get userId => _userId;
  String get name => _name;
  double get walletBalance => _walletBalance;
  bool get isLoggedIn => _isLoggedIn;

  // Setters / Actions
  void login(String userId, String name) {
    _userId = userId;
    _name = name;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _userId = '';
    _name = '';
    _walletBalance = 0.0;
    _isLoggedIn = false;
    notifyListeners();
  }

  void updateWallet(double amount) {
    _walletBalance = amount;
    notifyListeners();
  }
}
