import 'package:flutter/material.dart';
import '../screens/level1_screen.dart'; // Pastikan import ini sesuai dengan struktur proyek Anda

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Level Selection Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LevelSelectionPage(),
    );
  }
}

class LevelSelectionPage extends StatelessWidget {
  const LevelSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Level'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return const LevelSelectionDialog(quizTitle: 'Kuis');
              },
            );
          },
          child: const Text('Tampilkan Dialog Level'),
        ),
      ),
    );
  }
}

class LevelSelectionDialog extends StatefulWidget {
  final String quizTitle;

  const LevelSelectionDialog({super.key, required this.quizTitle});

  @override
  State<LevelSelectionDialog> createState() => _LevelSelectionDialogState();
}

class _LevelSelectionDialogState extends State<LevelSelectionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  int? selectedLevel; // Menyimpan level yang dipilih
  bool isLevel1Completed = false; // Contoh: Level 1 sudah selesai
  bool isLevel2Completed = false; // Contoh: Level 2 belum selesai

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start from bottom
      end: Offset.zero, // End at original position
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showLockedLevelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const LockedLevelDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            _controller.reverse().then((_) {
              Navigator.of(context).pop(); // Tutup dialog setelah animasi
            });
          },
          child: Material(
            color: Colors.transparent,
            child: SlideTransition(
              position: _animation,
              child: Dialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {}, // Mencegah penutupan saat dialog diklik
                  child: Container(
                    width: 410,
                    height: 420, // Sesuaikan tinggi sesuai desain baru
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 410,
                            height: 500,
                            decoration: ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(0.50, -0.00),
                                end: Alignment(0.50, 1.00),
                                colors: [Color(0xFFE2AB42), Color(0xFFC15D2D)],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 50,
                          top: 30,
                          child: Text(
                            'Pilih Level ${widget.quizTitle} :',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Level 1
                        Positioned(
                          left: 50,
                          top: 80,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedLevel = 1; // Pilih Level 1
                              });
                            },
                            hoverColor: const Color.fromARGB(255, 255, 255, 255)
                                .withOpacity(0.2), // Efek hover
                            borderRadius: BorderRadius.circular(
                                10), // Sesuaikan dengan border container
                            child: Container(
                              width: 308,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedLevel == 1
                                    ? const Color.fromARGB(255, 255, 255, 255)
                                        .withOpacity(0.2)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Level 1',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Level 2
                        Positioned(
                          left: 50,
                          top: 140,
                          child: InkWell(
                            onTap: () {
                              if (isLevel1Completed) {
                                setState(() {
                                  selectedLevel = 2; // Pilih Level 2
                                });
                              } else {
                                _showLockedLevelDialog(
                                    context); // Tampilkan dialog level terkunci
                              }
                            },
                            hoverColor:
                                Colors.grey.withOpacity(0.2), // Efek hover
                            borderRadius: BorderRadius.circular(
                                10), // Sesuaikan dengan border container
                            child: Container(
                              width: 308,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedLevel == 2
                                    ? Colors.grey.withOpacity(0.2)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Level 2',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (!isLevel1Completed)
                                    Icon(
                                      Icons.lock,
                                      color: Colors.grey.shade600,
                                      size: 24,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Level 3
                        Positioned(
                          left: 50,
                          top: 200,
                          child: InkWell(
                            onTap: () {
                              if (isLevel2Completed) {
                                setState(() {
                                  selectedLevel = 3; // Pilih Level 3
                                });
                              } else {
                                _showLockedLevelDialog(
                                    context); // Tampilkan dialog level terkunci
                              }
                            },
                            hoverColor:
                                Colors.grey.withOpacity(0.2), // Efek hover
                            borderRadius: BorderRadius.circular(
                                10), // Sesuaikan dengan border container
                            child: Container(
                              width: 308,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedLevel == 3
                                    ? Colors.grey.withOpacity(0.2)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Level 3',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (!isLevel2Completed)
                                    Icon(
                                      Icons.lock,
                                      color: Colors.grey.shade600,
                                      size: 24,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Level 4
                        Positioned(
                          left: 50,
                          top: 260,
                          child: InkWell(
                            onTap: () {
                              if (isLevel2Completed) {
                                setState(() {
                                  selectedLevel = 4; // Pilih Level 4
                                });
                              } else {
                                _showLockedLevelDialog(
                                    context); // Tampilkan dialog level terkunci
                              }
                            },
                            hoverColor:
                                Colors.grey.withOpacity(0.2), // Efek hover
                            borderRadius: BorderRadius.circular(
                                10), // Sesuaikan dengan border container
                            child: Container(
                              width: 308,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedLevel == 4
                                    ? Colors.grey.withOpacity(0.2)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Level 4',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (!isLevel2Completed)
                                    Icon(
                                      Icons.lock,
                                      color: Colors.grey.shade600,
                                      size: 24,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Tombol "Start Kuis"
                        Positioned(
                          left: 50,
                          top: 340,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE2AC42),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 10),
                            ),
                            onPressed: () {
                              if (selectedLevel != null) {
                                // Navigasi ke halaman sesuai level yang dipilih
                                switch (selectedLevel) {
                                  case 1:
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Level1Screen(),
                                      ),
                                    );
                                    break;
                                  case 2:
                                    // Navigasi ke Level2Screen (jika sudah dibuat)
                                    break;
                                  case 3:
                                    // Navigasi ke Level3Screen (jika sudah dibuat)
                                    break;
                                  case 4:
                                    // Navigasi ke Level4Screen (jika sudah dibuat)
                                    break;
                                }
                              } else {
                                // Tampilkan pesan jika belum memilih level
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Silakan pilih level terlebih dahulu."),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Start Kuis',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}

class LockedLevelDialog extends StatelessWidget {
  const LockedLevelDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.lock,
                size: 60,
                color: Colors.orange,
              ),
              const SizedBox(height: 15),
              const Text(
                'Level Terkunci',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Silahkan selesaikan Level 1 terlebih dahulu.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
