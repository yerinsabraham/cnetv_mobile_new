import 'package:dio/dio.dart';

class ApiHelper {
  // Base URL of your API
  static const String baseUrl = 'https://your-api-base-url.com';

  final Dio _dio;

  ApiHelper({String? token})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: Duration(milliseconds: 15000),
          receiveTimeout: Duration(milliseconds: 15000),
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ));

  // GET request
  Future<T> getData<T>(
    String endpoint,
    T Function(Map<String, dynamic>) parser,
  ) async {
    try {
      final response = await _dio.get(endpoint);
      if (response.statusCode == 200) {
        return parser(response.data);
      } else {
        throw Exception('Failed GET request: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<T> postData<T>(
    String endpoint,
    Map<String, dynamic> body,
    T Function(Map<String, dynamic>) parser,
  ) async {
    try {
      final response = await _dio.post(endpoint, data: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return parser(response.data);
      } else {
        throw Exception('Failed POST request: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
