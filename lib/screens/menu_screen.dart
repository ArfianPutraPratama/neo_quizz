import 'package:flutter/material.dart';
import '../services/menu_services.dart';
import '../widgets/quiz_category_card.dart';
import '../screens/home_screen.dart';
import '../widgets/level_selection_dialog.dart';

class Menu_Screens extends StatefulWidget {
  const Menu_Screens({super.key});

  @override
  State<Menu_Screens> createState() => _Menu_ScreensState();
}

class _Menu_ScreensState extends State<Menu_Screens> {
  List<Menu_Category> quizzes = [];
  bool isLoading = true;
  String errorMessage = '';
  final Menu_Service _Menu_Service = Menu_Service();

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    try {
      final fetchedQuizzes = await _Menu_Service.fetchQuizzes();
      setState(() {
        quizzes = fetchedQuizzes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  void _handleQuizTap(Menu_Category quiz) {
    showDialog(
      context: context,
      builder: (context) => LevelSelectionDialog(
        quizTitle: quiz.title,
        quizId: quiz.id,
        userId: 2, // You might want to make this dynamic
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF457686),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 10),
          _buildQuizList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.50, -0.00),
          end: Alignment(0.50, 1.00),
          colors: [Color(0xFFE2AC42), Color(0xBFFFFFFF)],
        ),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(45),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 120,
            child: SizedBox(
              width: 328,
              child: Text(
                "Halo, Pemikir Hebat! Selamat datang di NeoQuiz, arena seru untuk menguji seberapa luas pengetahuanmu. Tantang dirimu, raih pencapaian, dan jadilah juara!",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 63,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NeoQuizHomeScreen()),
              ),
              child: Container(
                height: 40,
                width: 40,
                child: const Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizList() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : ListView.separated(
                    itemCount: quizzes.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final quiz = quizzes[index];
                      return GestureDetector(
                        onTap: () => _handleQuizTap(quiz),
                        child: QuizCard(
                          title: quiz.title,
                          subtitle: quiz.subtitle,
                          description: quiz.description,
                          questionCount: '${quiz.questionCount} Soal',
                          duration: quiz.duration,
                          iconPath: quiz.iconPath,
                          quizId: quiz.id,
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
