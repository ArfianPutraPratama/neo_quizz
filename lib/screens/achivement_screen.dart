import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor:
            const Color(0xFF457686), // Ubah warna latar belakang dasar
      ),
      home: const AchievementScreen(),
    );
  }
}

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF457686), // Warna AppBar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 32, // Ukuran ikon disesuaikan
          ),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: const Text(
          'Achievement',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // Shape Orange sebagai latar belakang
          Positioned(
            top: 0,
            left: 10,
            right: 10,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.50, -0.00),
                  end: Alignment(0.50, 1.00),
                  colors: [Color(0xFFC15D2D), Color(0xFFE2AC42)],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
            ),
          ),
          // List AchievementCard
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                AchievementCard(
                  title: 'Percobaan Yang Baik',
                  description:
                      'Selesaikan 3 Kuis Mata Kuliah Dengan Tingkat Kesulitan Level 3',
                  iconPath: 'assets/images/1.png',
                  isLocked: false,
                  height: 120,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
                const SizedBox(height: 16),
                AchievementCard(
                  title: 'Mudah Sekali!!',
                  description:
                      'Selesaikan 3 Kuis Mata Kuliah Dengan Tingkat Kesulitan Level 5',
                  iconPath: 'assets/images/2.png',
                  isLocked: true,
                  height: 120,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
                const SizedBox(height: 16),
                AchievementCard(
                  title: 'Sini Aku Ajari!!',
                  description:
                      'Selesaikan 6 Kuis Mata Kuliah Dengan Tingkat Kesulitan Level Ujian Pertengahan',
                  iconPath: 'assets/images/3.png',
                  isLocked: true,
                  height: 120,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
                const SizedBox(height: 16),
                AchievementCard(
                  title: 'Sepuh Nih Sangat Dang!!',
                  description:
                      'Selesaikan Semua Kuis Mata Kuliah Dengan Tingkat Kesulitan Level Ujian Akhir',
                  iconPath: 'assets/images/4.png',
                  isLocked: true,
                  height: 120,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AchievementCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;
  final bool isLocked;
  final double height;
  final double width;

  const AchievementCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.isLocked,
    this.height = 100,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isLocked) {
          // Tampilkan dialog konfirmasi
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      iconPath,
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Ingin Mengklaim Achievement Ini??',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Logika untuk mengklaim achievement
                          Navigator.of(context).pop(); // Tutup dialog
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 29, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('Iya',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Tutup dialog
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('Tidak',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        }
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF87CEEB),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                        Icons.error); // Fallback jika gambar tidak ditemukan
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isLocked)
                const Icon(
                  Icons.lock,
                  color: Colors.grey,
                )
              else
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
