import 'package:flutter/material.dart';
import 'package:ui_kit/src/foundation/foundation.dart';

class DRListItem extends StatelessWidget {
  const DRListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.isSelected = false,
    this.showDivider = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: isSelected
              ? DRColors.primary.withValues(alpha: isDark ? 0.15 : 0.08)
              : Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DRSpacing.listItemPadding,
                vertical: DRSpacing.sm + 4,
              ),
              child: Row(
                children: [
                  if (leading != null) ...[
                    _buildLeading(),
                    const SizedBox(width: DRSpacing.md),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: DRTypography.bodyMd.copyWith(
                            color: isDark
                                ? DRColors.neutral.shade100
                                : DRColors.neutral.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: DRTypography.caption.copyWith(
                              color: isDark
                                  ? DRColors.neutral.shade400
                                  : DRColors.neutral.shade500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: DRSpacing.sm),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: isDark
                ? DRColors.neutral.shade700
                : DRColors.neutral.shade200,
            indent: leading != null ? 72 : DRSpacing.listItemPadding,
            endIndent: DRSpacing.listItemPadding,
          ),
      ],
    );
  }

  Widget _buildLeading() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: DRColors.primaryGradient,
        borderRadius: DRRadius.borderMd,
      ),
      child: Center(
        child: IconTheme(
          data: const IconThemeData(color: Colors.white, size: 22),
          child: leading!,
        ),
      ),
    );
  }
}
