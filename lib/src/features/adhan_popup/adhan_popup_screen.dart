import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/adhan/adhan_service.dart';

/// شاشة الأذان الكاملة - تظهر وقت كل صلاة
class AdhanPopupScreen extends StatefulWidget {
  final String prayer;
  final String prayerTime;

  const AdhanPopupScreen({
    super.key,
    required this.prayer,
    required this.prayerTime,
  });

  @override
  State<AdhanPopupScreen> createState() => _AdhanPopupScreenState();
}

class _AdhanPopupScreenState extends State<AdhanPopupScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  final AdhanService _adhanService = AdhanService();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = CurvedAnimation(parent: _animController, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();

    // تشغيل الأذان تلقائياً
    _adhanService.playAdhan(widget.prayer);

    // إبقاء الشاشة مضاءة
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _animController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _stop() async {
    await _adhanService.stop();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final prayerArabic = AdhanService.prayerNames[widget.prayer] ?? widget.prayer;

    return Scaffold(
      body: Stack(
        children: [
          // خلفية - صورة الوالد
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (rect) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF0D1F12).withOpacity(0.6),
                  const Color(0xFF0D1F12).withOpacity(0.85),
                  const Color(0xFF0D1F12),
                ],
              ).createShader(rect),
              blendMode: BlendMode.srcOver,
              child: Image.asset(
                'assets/father_photo.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1B5E20), Color(0xFF0D1F12)],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // المحتوى
          FadeTransition(
            opacity: _fadeAnim,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // أيقونة المسجد
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1B5E20).withOpacity(0.9),
                        border: Border.all(color: const Color(0xFFFFD700), width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD700).withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🕌', style: TextStyle(fontSize: 54)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // حان وقت
                  const Text(
                    'حانَ وقتُ',
                    style: TextStyle(
                      fontFamily: 'Uthman',
                      fontSize: 20,
                      color: Color(0xFFA5D6A7),
                    ),
                    textDirection: TextDirection.rtl,
                  ),

                  const SizedBox(height: 8),

                  // اسم الصلاة
                  Text(
                    'صلاة $prayerArabic',
                    style: const TextStyle(
                      fontFamily: 'Uthman',
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                    ),
                    textDirection: TextDirection.rtl,
                  ),

                  const SizedBox(height: 8),

                  // الوقت
                  Text(
                    widget.prayerTime,
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 3,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // الشهادة
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFFD700).withOpacity(0.3),
                      ),
                    ),
                    child: const Text(
                      'حي على الصلاة • حي على الفلاح',
                      style: TextStyle(
                        fontFamily: 'Uthman',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ),

                  const Spacer(),

                  // إيقاف الأذان
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50, left: 40, right: 40),
                    child: ElevatedButton.icon(
                      onPressed: _stop,
                      icon: const Icon(Icons.stop_circle_outlined, size: 22),
                      label: const Text(
                        'إيقاف الأذان',
                        style: TextStyle(
                          fontFamily: 'Uthman',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        foregroundColor: const Color(0xFFFFD700),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Color(0xFFFFD700), width: 1.5),
                        ),
                        elevation: 8,
                      ),
                    ),
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
