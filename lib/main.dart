import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import untuk audioplayers
import '../audio/audio_manager.dart'; // Import AudioManager
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Inisialisasi dan putar musik saat aplikasi dimulai
    AudioManager().initAndPlay();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Hentikan musik dan bersihkan AudioPlayer saat aplikasi ditutup
    AudioManager().stop();
    AudioManager().dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Jeda musik saat aplikasi masuk ke background
      AudioManager().pause();
      print("App paused");
    } else if (state == AppLifecycleState.resumed) {
      // Lanjutkan musik saat aplikasi kembali aktif
      AudioManager().resume();
      print("App resumed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor:
            const Color(0xFF457686), // Warna latar belakang
      ),
      home: const NeoQuizHomeScreen(),
    );
  }
}
