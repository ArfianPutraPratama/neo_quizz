import 'package:coba/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import '../screens/hasil_quiz_screen.dart';
import '../screens/setting_screen.dart';

void main() {
  runApp(const Level1Screen());
}

class Level1Screen extends StatelessWidget {
  const Level1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor:
            const Color(0xFF457686), // Warna latar belakang
      ),
      home: const Lavel(),
    );
  }
}

class Lavel extends StatelessWidget {
  const Lavel({super.key});

  @override
  Widget build(BuildContext context) {
    // Function untuk membangun opsi jawaban
    Widget buildAnswerOption(String option, String text, Color color) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(10),
          color: color,
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              '$option. $text',
              style: const TextStyle(fontSize: 14),
            ),
            onTap: () {
              if (option == 'A') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizResultScreen(
                      correctAnswers: 8,
                      totalQuestions: 10,
                      timeSpent: const Duration(minutes: 5),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Halaman_pertama(),
                        ),
                      );
                    },
                    child: Container(
                      height: 40, // Tinggi container ikon
                      width: 40, // Lebar container ikon
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 32, // Ukuran ikon disesuaikan
                      ),
                    ),
                  ),
                  const Spacer(),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progres Pengerjaan : 50%',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.5,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: 0.5,
                      strokeWidth: 8,
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.cyan.shade300,
                      ),
                    ),
                  ),
                  const Text(
                    '50:00',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 135, 135, 135)
                                .withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Apa kegunaan dan tag <meta charset="UTF-8"> dalam HTML?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildAnswerOption(
                      'A',
                      'Menentukan warna latar belakang halaman',
                      const Color.fromARGB(255, 198, 213, 236),
                    ),
                    buildAnswerOption(
                      'B',
                      'Menentukan jenis encoding karakter yang digunakan',
                      const Color.fromARGB(255, 198, 213, 236),
                    ),
                    buildAnswerOption(
                      'C',
                      'Menghubungkan file CSS eksternal',
                      const Color.fromARGB(255, 198, 213, 236),
                    ),
                    buildAnswerOption(
                      'D',
                      'Menambahkan gambar ke halaman web',
                      const Color.fromARGB(255, 198, 213, 236),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
