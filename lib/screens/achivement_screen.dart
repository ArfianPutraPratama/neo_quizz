import 'package:flutter/material.dart';
import '../services/device_info_services.dart';
import '../services/user_achievement_services.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  _AchievementScreenState createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen>
    with WidgetsBindingObserver {
  String deviceId = '';
  String username = '';
  bool isUserAssigned = false;
  Map<int, bool> levelCompletionStatus = {
    1: false,
    2: false,
    3: false,
    4: false,
  };
  Map<int, List<int>> completedQuestions = {
    1: [],
    2: [],
    3: [],
    4: [],
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getDeviceIdAndCheckUser();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _getDeviceIdAndCheckUser() async {
    if (!mounted) return;

    try {
      final id = await DeviceInfoService(context).getDeviceId();

      if (!mounted) return;
      setState(() => deviceId = id);

      await _checkUserByDeviceId();
    } catch (e) {
      if (!mounted) return;
      setState(() => deviceId = 'error_$e');
      print('Error fetching device ID: $e');
    }
  }

  Future<void> _checkUserByDeviceId() async {
    if (!mounted) return;

    try {
      final data =
          await UserAchievementService.getUserAchievementData(deviceId, 1);

      if (!mounted) return;
      print('API Response: $data');

      if (data['status'] == 'success') {
        if (!mounted) return;
        setState(() {
          username = data['username'];
          isUserAssigned = true;

          _updateLevelData(
              1, data['level1_completed'], data['level1_questions']);
          _updateLevelData(
              2, data['level2_completed'], data['level2_questions']);
          _updateLevelData(
              3, data['level3_completed'], data['level3_questions']);
          _updateLevelData(
              4, data['level4_completed'], data['level4_questions']);
        });
      }
    } catch (e) {
      print('Error checking user: $e');
    }
  }

  void _updateLevelData(
      int level, dynamic completedStatus, dynamic questionsData) {
    levelCompletionStatus[level] = (completedStatus ?? 0) == 1;

    if (questionsData != null && questionsData is String) {
      completedQuestions[level] = questionsData
          .split(',')
          .map((e) => int.tryParse(e.trim()) ?? 0)
          .where((id) => id > 0)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF457686),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Achievement', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                _buildAchievementCard(
                  level: 1,
                  title: 'Percobaan Yang Baik',
                  description:
                      'Selesaikan 3 Kuis Mata Kuliah Dengan Tingkat Kesulitan Level 1',
                  iconPath: 'assets/images/1.png',
                  requiredQuizIds: [1, 2, 3],
                ),
                const SizedBox(height: 16),
                _buildAchievementCard(
                  level: 2,
                  title: 'Mudah Sekali!!',
                  description:
                      'Selesaikan 3 Kuis Mata Kuliah Dengan Tingkat Kesulitan Level 2',
                  iconPath: 'assets/images/2.png',
                  requiredQuizIds: [4, 5, 6],
                ),
                const SizedBox(height: 16),
                _buildAchievementCard(
                  level: 3,
                  title: 'Sini Aku Ajari!!',
                  description:
                      'Selesaikan 3 Kuis Mata Kuliah Dengan Tingkat Kesulitan Level Ujian Pertengahan',
                  iconPath: 'assets/images/3.png',
                  requiredQuizIds: [7, 8, 9],
                ),
                const SizedBox(height: 16),
                _buildAchievementCard(
                  level: 4,
                  title: 'Sepuh Nih Sangat Dang!!',
                  description:
                      'Selesaikan Semua Kuis Mata Kuliah Dengan Tingkat Kesulitan Level Ujian Akhir',
                  iconPath: 'assets/images/4.png',
                  requiredQuizIds: [10, 11, 12],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard({
    required int level,
    required String title,
    required String description,
    required String iconPath,
    required List<int> requiredQuizIds,
  }) {
    final completedQuizIds = completedQuestions[level] ?? [];
    final isUnlocked =
        requiredQuizIds.every((quizId) => completedQuizIds.contains(quizId));
    final isCompleted = levelCompletionStatus[level] ?? false;

    return _AchievementCard(
      title: title,
      description: description,
      iconPath: iconPath,
      isUnlocked: isUnlocked,
      isCompleted: isCompleted,
      height: 120,
      width: MediaQuery.of(context).size.width * 0.9,
      level: level,
      username: username,
      onClaim: () => _claimAchievement(level, requiredQuizIds),
    );
  }

  Future<void> _claimAchievement(int level, List<int> quizIds) async {
    if (!mounted) return;

    try {
      final data = await UserAchievementService.claimLevelAchievement(
        username,
        deviceId,
        level,
        quizIds,
      );

      if (!mounted) return;
      if (data['status'] == 'success') {
        if (!mounted) return;
        setState(() {
          levelCompletionStatus[level] = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Achievement berhasil diklaim!')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengklaim: $e')),
      );
    }
  }
}

class _AchievementCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;
  final bool isUnlocked;
  final bool isCompleted;
  final double height;
  final double width;
  final int level;
  final String username;
  final VoidCallback onClaim;

  const _AchievementCard({
    required this.title,
    required this.description,
    required this.iconPath,
    required this.isUnlocked,
    required this.isCompleted,
    required this.height,
    required this.width,
    required this.level,
    required this.username,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          isUnlocked && !isCompleted ? () => _showClaimDialog(context) : null,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: isCompleted
              ? Colors.green[100]
              : isUnlocked
                  ? Colors.amber[50]
                  : Colors.white,
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (isCompleted) {
      return const Icon(Icons.check_circle, color: Colors.green, size: 30);
    } else if (isUnlocked) {
      return const Icon(Icons.lock_open, color: Colors.amber, size: 30);
    } else {
      return const Icon(Icons.lock, color: Colors.grey, size: 30);
    }
  }

  void _showClaimDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(iconPath, width: 80, height: 80),
            const SizedBox(height: 10),
            const Text(
              'Ingin Mengklaim Achievement Ini?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onClaim();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 29, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      const Text('Iya', style: TextStyle(color: Colors.white)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
      ),
    );
  }
}
