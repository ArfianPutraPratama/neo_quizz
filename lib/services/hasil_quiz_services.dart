import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizService {
  static const String _baseUrl = 'http://192.168.0.110/aplikasiquizz/';

  // Update user's score for a specific level
  static Future<Map<String, dynamic>> updateLevelScore({
    required String deviceId,
    required int quizId,
    required int level,
    required int score,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}update_level_score.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'device_id': deviceId,
          'quiz_id': quizId,
          'level': level,
          'score': score,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update score: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating score: $e');
    }
  }

  // Get user's score for a specific level
  static Future<Map<String, dynamic>> getUserScore({
    required String deviceId,
    required int quizId,
    required int level,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${_baseUrl}get_user_score.php?device_id=$deviceId&quiz_id=$quizId&level=$level'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch score: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching score: $e');
    }
  }
}
