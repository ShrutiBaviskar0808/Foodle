import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class MemberService {
  static Future<Map<String, dynamic>> addMember({
    required int ownerUserId,
    int? linkedUserId,
    required String displayName,
    required String relation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/add_member.php'),
        headers: AppConfig.jsonHeaders,
        body: json.encode({
          'owner_user_id': ownerUserId,
          'linked_user_id': linkedUserId,
          'display_name': displayName,
          'relation': relation,
        }),
      ).timeout(AppConfig.requestTimeout);

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getMembers(int ownerUserId) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/get_members.php'),
        headers: AppConfig.jsonHeaders,
        body: json.encode({'owner_user_id': ownerUserId}),
      ).timeout(AppConfig.requestTimeout);

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateMemberSettings({
    required int memberId,
    required bool allowSharedView,
    required bool showAllergyWarning,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/update_member_settings.php'),
        headers: AppConfig.jsonHeaders,
        body: json.encode({
          'member_id': memberId,
          'allow_shared_view': allowSharedView ? 1 : 0,
          'show_allergy_warning': showAllergyWarning ? 1 : 0,
        }),
      ).timeout(AppConfig.requestTimeout);

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
