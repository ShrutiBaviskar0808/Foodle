import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class AuthService {
  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    String? phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/signup.php'),
        headers: AppConfig.jsonHeaders,
        body: json.encode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      ).timeout(AppConfig.requestTimeout);

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.loginEndpoint),
        headers: AppConfig.jsonHeaders,
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ).timeout(AppConfig.requestTimeout);

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/verify_otp.php'),
        headers: AppConfig.jsonHeaders,
        body: json.encode({
          'email': email,
          'otp': otp,
        }),
      ).timeout(AppConfig.requestTimeout);

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
