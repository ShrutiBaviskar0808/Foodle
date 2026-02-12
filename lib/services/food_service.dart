import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class FoodService {
  static Future<Map<String, dynamic>> addFood({
    required int memberId,
    required String foodName,
    String preferenceType = 'like',
    String? moodTag,
    String? photoPath,
    String? notes,
    String visibility = 'private',
    int? createdByUserId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/add_food.php'),
        headers: AppConfig.jsonHeaders,
        body: json.encode({
          'member_id': memberId,
          'food_name': foodName,
          'preference_type': preferenceType,
          'mood_tag': moodTag,
          'photo_path': photoPath,
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

  static Future<Map<String, dynamic>> getFoods(int memberId) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/get_foods.php'),
        headers: AppConfig.jsonHeaders,
        body: json.encode({'member_id': memberId}),
      ).timeout(AppConfig.requestTimeout);

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
