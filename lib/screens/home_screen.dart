import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk SystemNavigator
import '../widgets/app_button.dart';
import '../screens/quiz_screen.dart';
import '../screens/achivement_screen.dart';
import '../screens/setting_screen.dart';

class NeoQuizHomeScreen extends StatefulWidget {
  const NeoQuizHomeScreen({Key? key}) : super(key: key);

  @override
  State<NeoQuizHomeScreen> createState() => _NeoQuizHomeScreenState();
}

class _NeoQuizHomeScreenState extends State<NeoQuizHomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Lakukan inisialisasi ulang di sini
      print("Aplikasi dibuka kembali");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF457686),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(117),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 198,
                        height: 196,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 198,
                            height: 196,
                            color: Colors.grey[300],
                            child:
                                const Icon(Icons.image_not_supported, size: 50),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'NeoQuiz',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Slabo 13px',
                        fontSize: 36,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.25,
                        height: 20 / 36,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 253,
                  ),
                  child: Column(
                    children: [
                      AppButton(
                        text: 'Start Kuis',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Halaman_pertama(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        text: 'Achievement',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AchievementScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        text: 'Setting',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        text: 'Exit',
                        onPressed: () {
                          // Keluar dari aplikasi
                          SystemNavigator.pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
