import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GtLogo extends StatelessWidget {
  const GtLogo({super.key, this.size = 56});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.gradientPrimary,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(Icons.rocket_launch_rounded, size: size * 0.5, color: AppColors.white),
    );
  }
}
