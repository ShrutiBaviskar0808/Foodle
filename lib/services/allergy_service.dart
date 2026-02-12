import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class AllergyService {
  static Future<Map<String, dynamic>> addAllergy({
    required int memberId,
    required String allergyName,
    String severity = 'mild',
    String? notes,
    String visibility = 'private',
    int? createdByUserId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/add_allergy.php'),
        headers: AppConfig.jsonHeaders,
        body: json.encode({
          'member_id': memberId,
          'allergy_name': allergyName,
          'severity': severity,
          'notes': notes,
          'visibility': visibility,
          'created_by_user_id': createdByUserId,
        }),
      ).timeout(AppConfig.requestTimeout);

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getAllergies(int memberId) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/get_allergies.php'),
        headers: AppConfig.jsonHeaders,
        body: json.encode({'member_id': memberId}),
      ).timeout(AppConfig.requestTimeout);

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
