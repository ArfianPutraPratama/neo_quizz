import 'package:http/http.dart' as http;
import 'dart:convert';

class Menu_Service {
  static const String _baseUrl = 'http://192.168.0.110/aplikasiquizz/';

  Future<List<Menu_Category>> fetchQuizzes() async {
    try {
      final response = await http.get(Uri.parse('${_baseUrl}get_quizzes.php'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          return (responseData['data'] as List)
              .map((quiz) => Menu_Category.fromJson(quiz))
              .toList();
        } else {
          throw Exception('Failed to load quizzes: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to load quizzes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching quizzes: $e');
    }
  }
}

class Menu_Category {
  final int id;
  final String title;
  final String subtitle;
  final String description;
  final int questionCount;
  final String duration;
  final String iconPath;

  Menu_Category({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.questionCount,
    required this.duration,
    required this.iconPath,
  });

  factory Menu_Category.fromJson(Map<String, dynamic> json) {
    return Menu_Category(
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      description: json['description'] as String,
      questionCount: int.parse(json['question_count'].toString()),
      duration: json['duration'] as String,
      iconPath: json['icon_path'] as String,
    );
  }
}
