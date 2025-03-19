import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../screens/setting_screen.dart';
import '../screens/level1_screen.dart';
import '../screens/quiz_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;
  final Duration timeSpent;

  const QuizResultScreen({
    Key? key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.timeSpent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF457686),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Sempurna',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      // Navigate to tampilan_menu.dart
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Score Circle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: CircularPercentIndicator(
                radius: 80.0,
                lineWidth: 12.0,
                percent: correctAnswers / totalQuestions,
                center: Text(
                  '${(correctAnswers / totalQuestions * 100).round()}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                progressColor: Colors.cyan,
                backgroundColor: Colors.cyan.withOpacity(0.2),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ),

            // Stats Container
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
                        text: '$correctAnswers Soal',
                        textColor: Colors.white,
                      ),
                      _buildStatItem(
                        icon: Icons.cancel,
                        color: Colors.red,
                        text: '${totalQuestions - correctAnswers} Soal',
                        textColor: Colors.white,
                      ),
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
                            '${timeSpent.inMinutes}:${(timeSpent.inSeconds % 60).toString().padLeft(2, '0')}',
                        textColor: Colors.white,
                      ),
                      _buildStatItem(
                        icon: Icons.info,
                        color: Colors.blue,
                        text: '$correctAnswers/$totalQuestions',
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Bottom Buttons
            // Bottom Buttons
            // Bottom Buttons
            Container(
              padding: const EdgeInsets.symmetric(vertical: 50),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Play Again (diberi padding kanan untuk geser ke kanan)
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 30.0), // Geser ke kanan
                      child: _buildBottomButton(
                        icon: Icons.refresh,
                        label: 'Play Again',
                        onPressed: () {
                          // Navigate to tampilan_menu.dart
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Level1Screen(),
                            ),
                          );
                        },
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Menu (tetap di tengah)
                  Expanded(
                    child: _buildBottomButton(
                      icon: Icons.menu,
                      label: 'Menu',
                      onPressed: () {
                        // Navigate to tampilan_menu.dart
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Halaman_pertama(),
                          ),
                        );
                      },
                      color: Colors.white,
                    ),
                  ),

                  // Next (diberi padding kiri untuk geser ke kiri)
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 30.0), // Geser ke kiri
                      child: _buildBottomButton(
                        icon: Icons.play_arrow,
                        label: 'Next',
                        onPressed: () {},
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
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
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
        overlayColor: MaterialStateProperty.all(
            Colors.transparent), // Hilangkan efek splash dan highlight
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
