import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../services/level_services.dart';
import '../screens/setting_screen.dart';
import '../screens/hasil_quiz_screen.dart';

class Level_Screen extends StatelessWidget {
  final String deviceId;
  final int quizId;
  final int level;
  final VoidCallback onLevelCompleted;

  const Level_Screen({
    Key? key,
    required this.deviceId,
    required this.quizId,
    required this.level,
    required this.onLevelCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF457686),
      ),
      home: Lavel(
        deviceId: deviceId,
        quizId: quizId,
        level: level,
        onLevelCompleted: onLevelCompleted,
      ),
    );
  }
}

class Lavel extends StatefulWidget {
  final String deviceId;
  final int quizId;
  final int level;
  final VoidCallback onLevelCompleted;

  const Lavel({
    Key? key,
    required this.deviceId,
    required this.quizId,
    required this.level,
    required this.onLevelCompleted,
  }) : super(key: key);

  @override
  _LavelState createState() => _LavelState();
}

class _LavelState extends State<Lavel> {
  late Future<List<dynamic>> questions;
  List<dynamic> questionsData = [];
  int currentQuestionIndex = 0;
  double progress = 0.0;
  int correctAnswers = 0;
  List<int> completedQuestionIds = [];
  late Timer _timer;
  int _timeLeft = 25 * 60;
  bool _isTimeUp = false;
  double _timerProgress = 1.0;

  @override
  void initState() {
    super.initState();
    questions = ApiService().fetchQuestions(widget.quizId, widget.level);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
          _timerProgress = _timeLeft / (25 * 60);
        } else {
          _timer.cancel();
          _isTimeUp = true;
          _handleTimeUp();
        }
      });
    });
  }

  void _handleTimeUp() {
    setState(() {
      if (questionsData[currentQuestionIndex].containsKey('id')) {
        completedQuestionIds.add(questionsData[currentQuestionIndex]['id']);
      }
      progress += 1 / questionsData.length;
      currentQuestionIndex++;
    });

    if (currentQuestionIndex >= questionsData.length) {
      _showCompletionPopup(context);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _updateLevelCompletion() async {
    final success = await ApiService().updateLevelCompletion(
      widget.deviceId,
      widget.quizId,
      widget.level,
      completedQuestionIds,
    );

    if (success) {
      widget.onLevelCompleted();
    }
  }

  void _showCompletionPopup(BuildContext context) {
    _updateLevelCompletion().then((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Selamat!'),
          content: const Text('Semua soal telah selesai!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HasilQuizScreen(
                      correctAnswers: correctAnswers,
                      totalQuestions: questionsData.length,
                      timeSpent: Duration(seconds: 25 * 60 - _timeLeft),
                      deviceId: widget.deviceId,
                      level: widget.level,
                      quizId: widget.quizId,
                    ),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  Widget buildAnswerOption(String option, String text, Color color) {
    bool isCorrect =
        option == questionsData[currentQuestionIndex]['correct_answer'];
    bool isSelected = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: _isTimeUp
              ? null
              : () {
                  setState(() => isSelected = true);
                  if (isCorrect) correctAnswers++;

                  setState(() {
                    if (questionsData[currentQuestionIndex].containsKey('id')) {
                      completedQuestionIds
                          .add(questionsData[currentQuestionIndex]['id']);
                    }
                    progress += 1 / questionsData.length;
                    currentQuestionIndex++;
                  });

                  if (currentQuestionIndex >= questionsData.length) {
                    _timer.cancel();
                    _showCompletionPopup(context);
                  }
                },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: isSelected
                  ? (isCorrect
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2))
                  : color,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListTile(
                  leading: isSelected
                      ? Icon(
                          isCorrect ? Icons.check_circle : Icons.cancel,
                          color: isCorrect ? Colors.green : Colors.red,
                        )
                      : null,
                  title: Text(
                    '$option. $text',
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
          future: questions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Tidak ada soal yang tersedia.'));
            } else {
              questionsData = snapshot.data!;
              if (currentQuestionIndex >= questionsData.length) {
                return const Center(child: Text('Semua soal telah selesai!'));
              }
              final question = questionsData[currentQuestionIndex];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Progres Pengerjaan : ${(progress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: CircularPercentIndicator(
                            radius: 50.0,
                            lineWidth: 8.0,
                            percent: _timerProgress,
                            center: Text(
                              '${(_timeLeft ~/ 60).toString().padLeft(2, '0')}.${(_timeLeft % 60).toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            progressColor: Colors.green,
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question['question_text'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            buildAnswerOption('A', question['option_a'],
                                const Color.fromARGB(255, 222, 230, 243)),
                            buildAnswerOption('B', question['option_b'],
                                const Color.fromARGB(255, 222, 230, 243)),
                            buildAnswerOption('C', question['option_c'],
                                const Color.fromARGB(255, 222, 230, 243)),
                            buildAnswerOption('D', question['option_d'],
                                const Color.fromARGB(255, 222, 230, 243)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
