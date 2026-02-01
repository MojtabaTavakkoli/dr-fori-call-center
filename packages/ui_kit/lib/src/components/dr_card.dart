import 'package:flutter/material.dart';
import 'package:ui_kit/src/foundation/foundation.dart';

class DRCard extends StatelessWidget {
  const DRCard({super.key, required this.child, this.padding, this.onTap})
    : _useGradient = false;

  const DRCard.gradient({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  }) : _useGradient = true;

  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final bool _useGradient;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(DRSpacing.cardPadding),
        decoration: BoxDecoration(
          gradient: _useGradient ? DRColors.primaryGradient : null,
          color: _useGradient
              ? null
              : (isDark ? DRColors.surfaceDark : DRColors.surface),
          borderRadius: DRRadius.borderLg,
          border: _useGradient
              ? null
              : Border.all(
                  color: isDark
                      ? DRColors.neutral.shade700
                      : DRColors.neutral.shade200,
                ),
          boxShadow: _useGradient
              ? DRShadows.glow
              : (isDark ? null : DRShadows.md),
        ),
        child: child,
      ),
    );
  }
}
