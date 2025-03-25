import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'http://192.168.0.110/aplikasiquizz';

  Future<List<dynamic>> fetchQuestions(int quizId, int levelId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_questions.php?quiz_id=$quizId&level_id=$levelId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        return responseData['data'];
      } else {
        throw Exception('Failed to load questions: ${responseData['message']}');
      }
    } else {
      throw Exception('Failed to load questions: ${response.statusCode}');
    }
  }

  Future<bool> updateLevelCompletion(
    String deviceId,
    int quizId,
    int level,
    List<int> questionIds,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_level_completion.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'device_id': deviceId,
          'quiz_id': quizId,
          'level': level,
          'question_ids': questionIds,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          print('Level completion updated: ${responseData['message']}');
          return true;
        } else {
          print('Failed to update level: ${responseData['message']}');
          return false;
        }
      } else {
        print('Failed to update level: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating level completion: $e');
      return false;
    }
  }
}
