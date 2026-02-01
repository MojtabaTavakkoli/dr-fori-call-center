import 'package:flutter/material.dart';
import 'package:ui_kit/src/foundation/foundation.dart';
import 'package:ui_kit/src/components/dr_list_item.dart';

class DRList extends StatelessWidget {
  const DRList({
    super.key,
    required this.children,
    this.header,
    this.emptyMessage,
    this.showDividers = true,
    this.padding,
  });

  final List<DRListItem> children;
  final String? header;
  final String? emptyMessage;
  final bool showDividers;
  final EdgeInsets? padding;

  bool get isEmpty => children.isEmpty && emptyMessage != null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (header != null) ...[
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: padding?.left ?? DRSpacing.listItemPadding,
              end: padding?.right ?? DRSpacing.listItemPadding,
              bottom: DRSpacing.sm,
            ),
            child: Text(
              header!,
              style: DRTypography.label.copyWith(
                color: isDark
                    ? DRColors.neutral.shade400
                    : DRColors.neutral.shade500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        if (isEmpty)
          _buildEmptyState(isDark)
        else
          Container(
            decoration: BoxDecoration(
              color: isDark ? DRColors.surfaceDark : DRColors.surface,
              borderRadius: DRRadius.borderLg,
              border: Border.all(
                color: isDark
                    ? DRColors.neutral.shade700
                    : DRColors.neutral.shade200,
              ),
              boxShadow: isDark ? null : DRShadows.sm,
            ),
            child: ClipRRect(
              borderRadius: DRRadius.borderLg,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _buildItems(),
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildItems() {
    return children.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return DRListItem(
        key: item.key,
        title: item.title,
        subtitle: item.subtitle,
        leading: item.leading,
        trailing: item.trailing,
        onTap: item.onTap,
        isSelected: item.isSelected,
        showDivider: showDividers && index != children.length - 1,
      );
    }).toList();
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(DRSpacing.xl),
      decoration: BoxDecoration(
        color: isDark ? DRColors.surfaceDark : DRColors.neutral.shade50,
        borderRadius: DRRadius.borderLg,
        border: Border.all(
          color: isDark ? DRColors.neutral.shade700 : DRColors.neutral.shade200,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isDark
                    ? DRColors.neutral.shade800
                    : DRColors.neutral.shade100,
                borderRadius: DRRadius.borderFull,
              ),
              child: Icon(
                Icons.inbox_outlined,
                size: 32,
                color: DRColors.neutral.shade400,
              ),
            ),
            const SizedBox(height: DRSpacing.md),
            Text(
              emptyMessage!,
              style: DRTypography.bodyMd.copyWith(
                color: isDark
                    ? DRColors.neutral.shade400
                    : DRColors.neutral.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
