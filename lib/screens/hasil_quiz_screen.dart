import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../services/hasil_quiz_services.dart';
import 'menu_screen.dart';
import 'level_screen.dart';
import '../screens/setting_screen.dart';

class HasilQuizScreen extends StatefulWidget {
  final int correctAnswers;
  final int totalQuestions;
  final Duration timeSpent;
  final String deviceId;
  final int level;
  final int quizId;

  const HasilQuizScreen({
    Key? key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.timeSpent,
    required this.deviceId,
    required this.level,
    required this.quizId,
  }) : super(key: key);

  @override
  _HasilQuizScreenState createState() => _HasilQuizScreenState();
}

class _HasilQuizScreenState extends State<HasilQuizScreen> {
  bool _hasUpdatedScore = false;
  int? _fetchedScore;
  int _percentageScore = 0;

  @override
  void initState() {
    super.initState();
    _percentageScore = widget.totalQuestions > 0
        ? ((widget.correctAnswers / widget.totalQuestions) * 100).round()
        : 0;
    _updateLevelScore();
  }

  Future<void> _updateLevelScore() async {
    if (_hasUpdatedScore) return;
    setState(() => _hasUpdatedScore = true);

    const int maxRetries = 3;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        final response = await QuizService.updateLevelScore(
          deviceId: widget.deviceId,
          quizId: widget.quizId,
          level: widget.level,
          score: _percentageScore,
        );

        if (response['status'] == 'success') {
          await _fetchScore();
          break;
        } else {
          print('Failed to update score: ${response['message']}');
          break;
        }
      } catch (e) {
        print('Error updating score (attempt ${retryCount + 1}): $e');
        retryCount++;
        if (retryCount == maxRetries) {
          print('Max retries reached. Failed to update score.');
          break;
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  Future<void> _fetchScore() async {
    try {
      final response = await QuizService.getUserScore(
        deviceId: widget.deviceId,
        quizId: widget.quizId,
        level: widget.level,
      );

      if (response['status'] == 'success') {
        setState(() {
          _fetchedScore = response['data']['score'];
        });
      }
    } catch (e) {
      print('Error fetching score: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF457686),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Menyeimbangkan elemen
                children: [
                  // Tambahkan widget kosong untuk menyeimbangkan tata letak
                  IconButton(
                    icon: const Icon(Icons.menu,
                        color: Colors.transparent), // Ikon transparan
                    onPressed: null, // Tidak ada aksi
                  ),
                  Expanded(
                    child: Text(
                      'Hasil Quiz',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: CircularPercentIndicator(
                radius: 80.0,
                lineWidth: 12.0,
                percent: widget.correctAnswers / widget.totalQuestions,
                center: Text(
                  '$_percentageScore%',
                  style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                progressColor: Colors.cyan,
                backgroundColor: Colors.cyan.withOpacity(0.2),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(
                          icon: Icons.check_circle,
                          color: Colors.green,
                          text: '${widget.correctAnswers} Benar',
                          textColor: Colors.white),
                      _buildStatItem(
                          icon: Icons.cancel,
                          color: Colors.red,
                          text:
                              '${widget.totalQuestions - widget.correctAnswers} Salah',
                          textColor: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(
                        icon: Icons.timer,
                        color: Colors.blue,
                        text:
                            '${widget.timeSpent.inMinutes}:${(widget.timeSpent.inSeconds % 60).toString().padLeft(2, '0')}',
                        textColor: Colors.white,
                      ),
                      _buildStatItem(
                          icon: Icons.help_outline,
                          color: Colors.blue,
                          text:
                              '${widget.correctAnswers}/${widget.totalQuestions}',
                          textColor: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_fetchedScore != null)
                    _buildStatItem(
                      icon: Icons.star,
                      color: Colors.yellow,
                      text: 'Skor: $_fetchedScore%',
                      textColor: Colors.white,
                    ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 50),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: _buildBottomButton(
                        icon: Icons.refresh,
                        label: 'Ulangi',
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Level_Screen(
                                deviceId: widget.deviceId,
                                quizId: widget.quizId,
                                level: widget.level,
                                onLevelCompleted: () => print('Level selesai!'),
                              ),
                            ),
                          );
                        },
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildBottomButton(
                      icon: Icons.menu,
                      label: 'Menu',
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Menu_Screens()),
                        );
                      },
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: _buildBottomButton(
                        icon: Icons.play_arrow,
                        label: 'Lanjut',
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Level_Screen(
                                deviceId: widget.deviceId,
                                quizId: widget.quizId,
                                level: widget.level + 1,
                                onLevelCompleted: () => print('Level selesai!'),
                              ),
                            ),
                          );
                        },
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color color,
    required String text,
    required Color textColor,
  }) {
    return Container(
      width: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
                color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
                color: color, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
