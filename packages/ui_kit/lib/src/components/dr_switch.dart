import 'package:flutter/material.dart';
import 'package:ui_kit/src/foundation/foundation.dart';

class DRSwitch extends StatelessWidget {
  const DRSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.disabled = false,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final trackActiveColor = activeColor ?? DRColors.primary;
    final trackInactiveColor = inactiveColor ?? 
        (isDark ? DRColors.neutral.shade700 : DRColors.neutral.shade300);
    final thumbColor = Colors.white;
    final disabledOpacity = disabled ? 0.5 : 1.0;

    return Opacity(
      opacity: disabledOpacity,
      child: GestureDetector(
        onTap: disabled ? null : () => onChanged?.call(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: 52,
          height: 28,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DRRadius.full),
            color: value ? trackActiveColor : trackInactiveColor,
            boxShadow: value ? DRShadows.glow : null,
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: thumbColor,
                boxShadow: DRShadows.sm,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DRSwitchListTile extends StatelessWidget {
  const DRSwitchListTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.leading,
    this.disabled = false,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? leading;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disabledOpacity = disabled ? 0.5 : 1.0;

    return Opacity(
      opacity: disabledOpacity,
      child: GestureDetector(
        onTap: disabled ? null : () => onChanged?.call(!value),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: DRSpacing.sm,
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: DRSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: DRTypography.bodyMd.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : DRColors.neutral.shade900,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: DRTypography.caption.copyWith(
                          color: DRColors.neutral.shade500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: DRSpacing.md),
              DRSwitch(
                value: value,
                onChanged: disabled ? null : onChanged,
                disabled: disabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
