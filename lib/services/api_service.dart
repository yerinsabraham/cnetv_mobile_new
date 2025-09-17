import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/ad.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<User?> fetchUser(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<List<Ad>> fetchAds() async {
    final url = Uri.parse('$baseUrl/ads');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Ad.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
