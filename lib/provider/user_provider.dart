// lib/provider/user_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

const String BASE_URL = 'http://10.0.2.2:3000'; 
// <-- CHANGE this to your backend URL when running on a real phone 
// (e.g. http://192.168.1.42:3000)

class UserProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late final Dio _dio;

  UserProvider() {
    _dio = Dio(
      BaseOptions(
        baseUrl: BASE_URL,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );
  }

  String _userId = '';
  String _name = '';
  double _walletBalance = 0.0;
  bool _isLoggedIn = false;
  int _rewardPoints = 0;
  bool _isEmailVerified = false;
  bool _isLoading = false;
  bool _isGuest = false; // NEW: guest mode flag

  // Getters
  String get userId => _userId;
  String get name => _name;
  double get walletBalance => _walletBalance;
  bool get isLoggedIn => _isLoggedIn;
  int get rewardPoints => _rewardPoints;
  bool get isEmailVerified => _isEmailVerified;
  bool get isLoading => _isLoading;
  bool get isGuest => _isGuest; // NEW getter

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  // Try auto login on app start
  Future<void> tryAutoLogin() async {
    _setLoading(true);
    final prefs = await SharedPreferences.getInstance();

    // Check if guest
    final guestFlag = prefs.getBool("isGuest") ?? false;
    if (guestFlag) {
      _isGuest = true;
      _isLoggedIn = false;
      _name = "Guest";
      _userId = "guest";
      _setLoading(false);
      notifyListeners();
      return;
    }

    // Otherwise check token
    final token = await _secureStorage.read(key: 'token');
    final expiryStr = await _secureStorage.read(key: 'token_expiry');

    bool valid = false;
    if (token != null && expiryStr != null) {
      final expiry = int.tryParse(expiryStr) ?? 0;
      if (DateTime.now().millisecondsSinceEpoch < expiry) valid = true;
    }

    if (valid) {
      try {
        final tok = token!;
        final resp = await _dio.get(
          '/auth/validate-token',
          options: Options(headers: {'Authorization': 'Bearer $tok'}),
        );
        if (resp.statusCode == 200) {
          _isLoggedIn = true;
          await setUserFromPrefs();
        } else {
          await logout();
        }
      } catch (_) {
        _isLoggedIn = true;
        await setUserFromPrefs();
      }
    } else {
      _isLoggedIn = false;
    }

    _setLoading(false);
  }

  // check login status
  Future<bool> checkLoginStatus() async {
    if (_isGuest) return false; // Guest is not treated as logged in
    final token = await _secureStorage.read(key: 'token');
    final expiryStr = await _secureStorage.read(key: 'token_expiry');

    if (token == null || expiryStr == null) return false;
    final expiry = int.tryParse(expiryStr) ?? 0;
    if (DateTime.now().millisecondsSinceEpoch > expiry) {
      await logout();
      return false;
    }

    try {
      final resp = await _dio.get(
        '/auth/validate-token',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return resp.statusCode == 200;
    } catch (_) {
      await logout();
      return false;
    }
  }

  // load user from SharedPreferences (local)
  Future<void> setUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString("userId") ?? '';
    _name = prefs.getString("userName") ?? '';
    _walletBalance = prefs.getDouble("walletBalance") ?? 0.0;
    _rewardPoints = prefs.getInt("rewardPoints") ?? 0;
    _isEmailVerified = prefs.getBool("isEmailVerified") ?? false;
    _isLoggedIn = prefs.getBool("isLoggedIn") ?? _isLoggedIn;
    _isGuest = prefs.getBool("isGuest") ?? false;
    notifyListeners();
  }

  // Login
  Future<bool> login(String email, String password,
      {bool rememberMe = true}) async {
    _setLoading(true);
    try {
      final resp = await _dio.post('/auth/login',
          data: {'email': email, 'password': password});
      if (resp.statusCode == 200) {
        final data = resp.data;
        final token = data['token'] as String?;
        _userId = data['userId'].toString();
        _name = data['name'] ?? '';
        _walletBalance = (data['walletBalance'] ?? 0).toDouble();
        _rewardPoints = data['rewardPoints'] ?? 0;
        _isEmailVerified = data['isEmailVerified'] ?? false;
        _isLoggedIn = true;
        _isGuest = false;

        if (token != null && rememberMe) {
          await _secureStorage.write(key: 'token', value: token);
          final expiry = DateTime.now()
              .add(const Duration(hours: 1))
              .millisecondsSinceEpoch;
          await _secureStorage.write(
              key: 'token_expiry', value: expiry.toString());
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isLoggedIn", true);
        await prefs.setBool("isGuest", false);
        await prefs.setString("userId", _userId);
        await prefs.setString("userName", _name);
        await prefs.setString("userEmail", email);
        await prefs.setDouble("walletBalance", _walletBalance);
        await prefs.setInt("rewardPoints", _rewardPoints);
        await prefs.setBool("isEmailVerified", _isEmailVerified);

        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setLoading(false);
        return false;
      }
    } catch (e) {
      debugPrint('Login error: $e');
      _setLoading(false);
      return false;
    }
  }

  // Signup
  Future<bool> signup(String name, String email, String password) async {
    _setLoading(true);
    try {
      final resp = await _dio.post('/auth/signup',
          data: {'name': name, 'email': email, 'password': password});
      if (resp.statusCode == 200) {
        final data = resp.data;
        final token = data['token'] as String?;
        _userId = data['userId'].toString();
        _name = data['name'] ?? name;
        _walletBalance = (data['walletBalance'] ?? 0).toDouble();
        _rewardPoints = data['rewardPoints'] ?? 0;
        _isEmailVerified = data['isEmailVerified'] ?? false;
        _isLoggedIn = true;
        _isGuest = false;

        if (token != null) {
          await _secureStorage.write(key: 'token', value: token);
          final expiry = DateTime.now()
              .add(const Duration(hours: 1))
              .millisecondsSinceEpoch;
          await _secureStorage.write(
              key: 'token_expiry', value: expiry.toString());
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isLoggedIn", true);
        await prefs.setBool("isGuest", false);
        await prefs.setString("userId", _userId);
        await prefs.setString("userName", _name);
        await prefs.setString("userEmail", email);
        await prefs.setDouble("walletBalance", _walletBalance);
        await prefs.setInt("rewardPoints", _rewardPoints);
        await prefs.setBool("isEmailVerified", _isEmailVerified);

        _setLoading(false);
        notifyListeners();
        return true;
      }

      _setLoading(false);
      return false;
    } catch (e) {
      debugPrint('Signup error: $e');
      _setLoading(false);
      return false;
    }
  }

  // Guest login
  Future<void> loginAsGuest() async {
    _setLoading(true);
    _userId = "guest";
    _name = "Guest";
    _walletBalance = 0.0;
    _rewardPoints = 0;
    _isEmailVerified = false;
    _isLoggedIn = false;
    _isGuest = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
    await prefs.setBool("isGuest", true);
    await prefs.setString("userId", _userId);
    await prefs.setString("userName", _name);

    _setLoading(false);
    notifyListeners();
  }

  Future<void> logout() async {
    _setLoading(true);
    _userId = '';
    _name = '';
    _walletBalance = 0.0;
    _isLoggedIn = false;
    _isGuest = false;
    _rewardPoints = 0;
    _isEmailVerified = false;

    await _secureStorage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _setLoading(false);
    notifyListeners();
  }

  void addRewardPoints(int points) async {
    _rewardPoints += points;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("rewardPoints", _rewardPoints);
    notifyListeners();
  }

  Future<void> resendVerificationEmail() async {
    try {
      final token = await _secureStorage.read(key: 'token');
      final resp = await _dio.post(
        '/auth/resend-verification',
        data: {},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (kDebugMode) {
        print('resendVerification response: ${resp.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print('resendVerification error: $e');
    }
  }

  Future<void> checkEmailVerification() async {
    final token = await _secureStorage.read(key: 'token');
    if (token == null) return;
    try {
      final resp = await _dio.get(
        '/auth/user',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (resp.statusCode == 200) {
        _isEmailVerified =
            resp.data['isEmailVerified'] ?? _isEmailVerified;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isEmailVerified', _isEmailVerified);
        notifyListeners();
      }
    } catch (_) {}
  }
}
