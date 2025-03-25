import 'package:http/http.dart' as http;
import 'dart:convert';

class UserAchievementService {
  static const String _baseUrl = 'http://192.168.0.110/aplikasiquizz/';

  static Future<Map<String, dynamic>> getUserAchievementData(
      String deviceId, int quizId) async {
    final response = await http.get(
      Uri.parse(
          '${_baseUrl}check_user_by_device.php?device_id=$deviceId&quiz_id=$quizId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get user achievement data');
    }
  }

  static Future<Map<String, dynamic>> claimLevelAchievement(
      String username, String deviceId, int level, List<int> quizIds) async {
    final response = await http.post(
      Uri.parse('${_baseUrl}claim_achievement.php'),
      body: {
        'username': username,
        'device_id': deviceId,
        'level': level.toString(),
        'quiz_ids': quizIds.join(','),
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to claim level achievement');
    }
  }
}
