import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gt_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const GtLogo(size: 72),
            const SizedBox(height: 16),
            const Text(
              'Gravity Tech',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.white, letterSpacing: 1),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tecnología de vanguardia',
              style: TextStyle(fontSize: 12, color: AppColors.lavender),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 140,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const LinearProgressIndicator(
                  backgroundColor: Color(0x334c2f9e),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.purple),
                  minHeight: 3,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Dot(active: true),
                const SizedBox(width: 6),
                _Dot(active: false),
                const SizedBox(width: 6),
                _Dot(active: false),
              ],
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Text('Iniciando...', style: TextStyle(fontSize: 11, color: AppColors.gray)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.pink : AppColors.violet,
        shape: BoxShape.circle,
      ),
    );
  }
}
