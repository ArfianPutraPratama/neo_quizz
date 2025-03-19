import 'package:flutter/material.dart';
import '../widgets/quiz_category_card.dart';
import '../screens/home_screen.dart';

class Halaman_pertama extends StatelessWidget {
  const Halaman_pertama({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF457686),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient and welcome message
          Container(
            width: double.infinity,
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.50, -0.00),
                end: Alignment(0.50, 1.00),
                colors: [Color(0xFFE2AC42), Color(0xBFFFFFFF)],
              ),
              borderRadius: BorderRadius.only(
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
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  top: 63,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NeoQuizHomeScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 40, // Tinggi container ikon
                      width: 40, // Lebar container ikon
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.black,
                        size: 32, // Ukuran ikon disesuaikan
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: const [
                  QuizCard(
                    title: 'Pemrograman Web',
                    subtitle: 'Pertanyaan Pilihan Ganda',
                    description:
                        'Pemrograman Web untuk melatih jawaban kuis pemrograman web dasar.',
                    questionCount: '20 Soal',
                    duration: '25 Menit',
                    iconPath: 'assets/images/Web.png',
                  ),
                  SizedBox(height: 16),
                  QuizCard(
                    title: 'Struktur Data',
                    subtitle: 'Pertanyaan Pilihan Ganda',
                    description:
                        'Struktur data untuk melatih jawaban kuis Struktur Data dasar.',
                    questionCount: '20 Soal',
                    duration: '25 Menit',
                    iconPath: 'assets/images/Struktur_Data.png',
                  ),
                  SizedBox(height: 16),
                  QuizCard(
                    title: 'UI - UX',
                    subtitle: 'Pertanyaan Pilihan Ganda',
                    description:
                        'UI - UX untuk melatih jawaban kuis UI - UX dasar.',
                    questionCount: '20 Soal',
                    duration: '25 Menit',
                    iconPath: 'assets/images/UX_design.png',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
