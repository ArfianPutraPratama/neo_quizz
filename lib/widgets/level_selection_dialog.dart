import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import '../screens/level_screen.dart';

class LevelSelectionDialog extends StatefulWidget {
  final String quizTitle;
  final int quizId;
  final int userId;

  const LevelSelectionDialog({
    Key? key,
    required this.quizTitle,
    required this.quizId,
    required this.userId,
  }) : super(key: key);

  @override
  State<LevelSelectionDialog> createState() => _LevelSelectionDialogState();
}

class _LevelSelectionDialogState extends State<LevelSelectionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  int? selectedLevel;
  bool isLevel1Completed = false;
  bool isLevel2Completed = false;
  bool isLevel3Completed = false;
  bool isLevel4Completed = false;
  String username = '';
  String deviceId = '';
  final TextEditingController _usernameController = TextEditingController();
  bool isUserAssigned = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getDeviceIdAndCheckUser();
  }

  Future<void> _getDeviceIdAndCheckUser() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String id = '';
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        id = androidInfo.id ?? 'unknown_android';
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        id = iosInfo.identifierForVendor ?? 'unknown_ios';
      } else {
        id = 'unsupported_platform';
      }
      setState(() => deviceId = id);
      await _checkUserByDeviceId();
    } catch (e) {
      print('Error fetching device ID: $e');
      setState(() => deviceId = 'error_$e');
    }
  }

  Future<void> _checkUserByDeviceId() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.0.110/aplikasiquizz/check_user_by_device.php?device_id=$deviceId&quiz_id=${widget.quizId}'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success' && data['username'] != null) {
          setState(() {
            isUserAssigned = true;
            username = data['username'];
            _usernameController.text = username;
            isLevel1Completed = data['level1_completed'] == 1;
            isLevel2Completed = data['level2_completed'] == 1;
            isLevel3Completed = data['level3_completed'] == 1;
            isLevel4Completed = data['level4_completed'] == 1;
          });
        }
      }
    } catch (e) {
      print('Error checking user by device: $e');
    }
  }

  Future<void> _saveUsername(String deviceId, String username) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.110/aplikasiquizz/save_username.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'device_id': deviceId,
          'username': username,
        }),
      );
      print('Save username response: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            isUserAssigned = true;
            this.username = username;
          });
          await _checkUserByDeviceId();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        }
      }
    } catch (e) {
      print('Error saving username: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return GestureDetector(
          onTap: () =>
              _controller.reverse().then((_) => Navigator.pop(context)),
          child: Material(
            color: Colors.transparent,
            child: SlideTransition(
              position: _animation,
              child: Dialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 410,
                    height: 490,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 410,
                            height: 510,
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
                        Positioned(
                          left: 50,
                          top: 80,
                          child: Container(
                            width: 308,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: TextField(
                              controller: _usernameController,
                              enabled: !isUserAssigned,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: isUserAssigned
                                    ? 'Nama Pengguna: $username'
                                    : 'Masukkan Nama Pengguna',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        // Level 1
                        Positioned(
                          left: 50,
                          top: 160,
                          child: _buildLevelContainer(
                            level: 1,
                            isCompleted: isLevel1Completed,
                            selectedLevel: selectedLevel,
                            levelText: 'Level 1',
                          ),
                        ),
                        // Level 2
                        Positioned(
                          left: 50,
                          top: 220,
                          child: _buildLevelContainer(
                            level: 2,
                            isCompleted: isLevel2Completed,
                            selectedLevel: selectedLevel,
                            levelText: 'Level 2',
                          ),
                        ),
                        // Level 3
                        Positioned(
                          left: 50,
                          top: 280,
                          child: _buildLevelContainer(
                            level: 3,
                            isCompleted: isLevel3Completed,
                            selectedLevel: selectedLevel,
                            levelText: 'Level 3',
                          ),
                        ),
                        // Level 4
                        Positioned(
                          left: 50,
                          top: 340,
                          child: _buildLevelContainer(
                            level: 4,
                            isCompleted: isLevel4Completed,
                            selectedLevel: selectedLevel,
                            levelText: 'Level 4',
                          ),
                        ),
                        Positioned(
                          left: 50,
                          top: 410,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE2AC42),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 10),
                            ),
                            onPressed: () {
                              if (!isUserAssigned &&
                                  _usernameController.text.isNotEmpty) {
                                _saveUsername(
                                    deviceId, _usernameController.text);
                              }
                              if (selectedLevel != null && isUserAssigned) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Level_Screen(
                                      deviceId: deviceId,
                                      quizId: widget.quizId,
                                      level: selectedLevel!,
                                      onLevelCompleted: () =>
                                          _checkUserByDeviceId(),
                                    ),
                                  ),
                                );
                              } else if (!isUserAssigned) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Masukkan nama pengguna terlebih dahulu.")),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Silakan pilih level terlebih dahulu.")),
                                );
                              }
                            },
                            child: const Text(
                              'Start Kuis',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600),
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

  Widget _buildLevelContainer({
    required int level,
    required bool isCompleted,
    required int? selectedLevel,
    required String levelText,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          this.selectedLevel = level;
        });
      },
      child: Container(
        width: 308,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white, // Warna latar belakang tetap putih
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selectedLevel == level
                ? const Color.fromARGB(
                    255, 0, 0, 0) // Warna border saat dipilih
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              levelText,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isCompleted)
              Icon(Icons.check_circle, color: Colors.green)
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedLevel == level ? Colors.blue : Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
