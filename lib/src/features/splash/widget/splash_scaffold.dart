import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../routes/routes.dart';
import '../../../core/util/bloc/database/database_bloc.dart';
import '../../../core/util/constants.dart';

class SplashScaffold extends StatelessWidget {
  const SplashScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DatabaseBloc, DatabaseState>(
      listener: (context, state) async {
        await Future.delayed(const Duration(milliseconds: 2500));
        if (state is DatabaseLoaded) {
          Navigator.of(context).pushReplacementNamed(RouteGenerator.tabScreen);
        } else if (state is DatabaseFailed) {
          Navigator.of(context).pushReplacementNamed(RouteGenerator.databaseError);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1F12),
        body: Stack(
          children: [
            // صورة الوالد كخلفية كاملة مع تأثير شفافية
            Positioned.fill(
              child: ShaderMask(
                shaderCallback: (rect) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF0D1F12).withOpacity(0.3),
                    const Color(0xFF0D1F12).withOpacity(0.85),
                    const Color(0xFF0D1F12),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ).createShader(rect),
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  'assets/father_photo.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF1B5E20),
                  ),
                ),
              ),
            ),

            // المحتوى فوق الصورة
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // شعار المسجد
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1B5E20),
                      border: Border.all(color: const Color(0xFFFFD700), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🕌', style: TextStyle(fontSize: 44)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // اسم التطبيق
                  const Text(
                    'محمد عبد العظيم الطويل',
                    style: TextStyle(
                      fontFamily: 'Uthman',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),

                  const SizedBox(height: 8),

                  // التطبيق الإسلامي
                  const Text(
                    'التطبيق الإسلامي',
                    style: TextStyle(
                      fontFamily: 'Uthman',
                      fontSize: 16,
                      color: Color(0xFFA5D6A7),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  // آية
                  const Text(
                    '﴿ وَذَكِّرْ فَإِنَّ الذِّكْرَىٰ تَنفَعُ الْمُؤْمِنِينَ ﴾',
                    style: TextStyle(
                      fontFamily: 'Uthman',
                      fontSize: 14,
                      color: Color(0xFF66BB6A),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),

                  const SizedBox(height: 40),

                  // loading dots
                  const _LoadingDots(),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final value = (_controller.value - delay).clamp(0.0, 1.0);
            final opacity = (value < 0.5 ? value * 2 : (1 - value) * 2).clamp(0.2, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD700).withOpacity(opacity),
              ),
            );
          }),
        );
      },
    );
  }
}
