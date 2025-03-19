import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double menuSoundValue = 0.5;
  double effectSoundValue = 0.5;
  String selectedLanguage = 'Bahasa Indonesia';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF457686), // Dark blue-grey background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          'Setting',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE49B3B), // Orange container
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menu Sound Slider
                  const Text(
                    'Menu Suara',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF7BD3EA),
                      inactiveTrackColor: Colors.white,
                      thumbColor: const Color(0xFF7BD3EA),
                      overlayColor: Colors.white.withOpacity(0.3),
                    ),
                    child: Slider(
                      value: menuSoundValue,
                      onChanged: (value) {
                        setState(() {
                          menuSoundValue = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Effect Sound Slider
                  const Text(
                    'Efek Suara',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF7BD3EA),
                      inactiveTrackColor: Colors.white,
                      thumbColor: const Color(0xFF7BD3EA),
                      overlayColor: Colors.white.withOpacity(0.3),
                    ),
                    child: Slider(
                      value: effectSoundValue,
                      onChanged: (value) {
                        setState(() {
                          effectSoundValue = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Language Dropdown
                  const Text(
                    'Pilih Bahasa:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedLanguage,
                      isExpanded: true,
                      underline: Container(),
                      items: ['Bahasa Indonesia', 'English', 'العربية']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedLanguage = newValue;
                          });
                        }
                      },
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
}
