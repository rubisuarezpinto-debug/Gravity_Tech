import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum GtButtonVariant { primary, secondary, pink }

class GtButton extends StatelessWidget {
  const GtButton({
    super.key,
    required this.label,
    this.onTap,
    this.variant = GtButtonVariant.primary,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onTap;
  final GtButtonVariant variant;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          gradient: _gradient,
          border: variant == GtButtonVariant.secondary
              ? Border.all(color: AppColors.violet)
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: variant == GtButtonVariant.secondary
                      ? AppColors.lavender
                      : AppColors.white,
                ),
              ),
      ),
    );
  }

  Gradient? get _gradient {
    switch (variant) {
      case GtButtonVariant.primary:
        return AppColors.gradientPrimary;
      case GtButtonVariant.pink:
        return AppColors.gradientPink;
      case GtButtonVariant.secondary:
        return null;
    }
  }
}
