import 'package:flutter/material.dart';
import 'package:ui_kit/src/foundation/foundation.dart';

enum DRButtonSize { sm, md, lg }

class DRButton extends StatefulWidget {
  const DRButton({
    super.key,
    required this.label,
    this.onPressed,
    this.size = DRButtonSize.md,
    this.isLoading = false,
    this.icon,
    this.width,
  }) : _variant = _Variant.filled,
       _useGradient = false;

  const DRButton.gradient({
    super.key,
    required this.label,
    this.onPressed,
    this.size = DRButtonSize.md,
    this.isLoading = false,
    this.icon,
    this.width,
  }) : _variant = _Variant.filled,
       _useGradient = true;

  const DRButton.outlined({
    super.key,
    required this.label,
    this.onPressed,
    this.size = DRButtonSize.md,
    this.isLoading = false,
    this.icon,
    this.width,
  }) : _variant = _Variant.outlined,
       _useGradient = false;

  const DRButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.size = DRButtonSize.md,
    this.isLoading = false,
    this.icon,
    this.width,
  }) : _variant = _Variant.ghost,
       _useGradient = false;

  final String label;
  final VoidCallback? onPressed;
  final DRButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final _Variant _variant;
  final bool _useGradient;

  bool get isEnabled => !isLoading && onPressed != null;

  @override
  State<DRButton> createState() => _DRButtonState();
}

enum _Variant { filled, outlined, ghost }

class _DRButtonState extends State<DRButton> {
  bool _isPressed = false;

  EdgeInsets get _padding => switch (widget.size) {
    DRButtonSize.sm => const EdgeInsets.symmetric(
      horizontal: DRSpacing.md,
      vertical: DRSpacing.sm,
    ),
    DRButtonSize.md => const EdgeInsets.symmetric(
      horizontal: DRSpacing.buttonPaddingH,
      vertical: DRSpacing.buttonPaddingV,
    ),
    DRButtonSize.lg => const EdgeInsets.symmetric(
      horizontal: DRSpacing.xl,
      vertical: DRSpacing.md,
    ),
  };

  double get _fontSize => switch (widget.size) {
    DRButtonSize.sm => 14,
    DRButtonSize.md => 16,
    DRButtonSize.lg => 18,
  };

  double get _borderRadius => switch (widget.size) {
    DRButtonSize.sm => DRRadius.sm,
    DRButtonSize.md => DRRadius.md,
    DRButtonSize.lg => DRRadius.lg,
  };

  bool get _shouldUseGradient =>
      widget._variant == _Variant.filled &&
      widget._useGradient &&
      widget.isEnabled;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: widget.width,
      child: GestureDetector(
        onTapDown: widget.isEnabled
            ? (_) => setState(() => _isPressed = true)
            : null,
        onTapUp: widget.isEnabled
            ? (_) => setState(() => _isPressed = false)
            : null,
        onTapCancel: widget.isEnabled
            ? () => setState(() => _isPressed = false)
            : null,
        onTap: widget.isEnabled ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.diagonal3Values(
            _isPressed ? 0.97 : 1.0,
            _isPressed ? 0.97 : 1.0,
            1.0,
          ),
          transformAlignment: Alignment.center,
          padding: _padding,
          decoration: BoxDecoration(
            gradient: _shouldUseGradient ? DRColors.primaryGradient : null,
            color: _backgroundColor(isDark),
            borderRadius: BorderRadius.circular(_borderRadius),
            border: widget._variant == _Variant.outlined
                ? Border.all(
                    color: widget.isEnabled
                        ? DRColors.primary
                        : DRColors.neutral.shade300,
                    width: 1.5,
                  )
                : null,
            boxShadow:
                widget._variant == _Variant.filled &&
                    widget.isEnabled &&
                    !_isPressed
                ? (widget._useGradient ? DRShadows.glow : DRShadows.sm)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading) ...[
                SizedBox(
                  width: _fontSize,
                  height: _fontSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _textColor(isDark),
                    ),
                  ),
                ),
                const SizedBox(width: DRSpacing.sm),
              ] else if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: _fontSize + 2,
                  color: _textColor(isDark),
                ),
                const SizedBox(width: DRSpacing.sm),
              ],
              Text(
                widget.label,
                style: DRTypography.button.copyWith(
                  fontSize: _fontSize,
                  color: _textColor(isDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color? _backgroundColor(bool isDark) {
    if (_shouldUseGradient) return null;
    if (!widget.isEnabled) {
      return widget._variant == _Variant.filled
          ? (isDark ? DRColors.neutral.shade700 : DRColors.neutral.shade200)
          : Colors.transparent;
    }
    return switch (widget._variant) {
      _Variant.filled => DRColors.primary,
      _Variant.outlined || _Variant.ghost => Colors.transparent,
    };
  }

  Color _textColor(bool isDark) {
    if (!widget.isEnabled) {
      return isDark ? DRColors.neutral.shade500 : DRColors.neutral.shade400;
    }
    return switch (widget._variant) {
      _Variant.filled => Colors.white,
      _Variant.outlined || _Variant.ghost => DRColors.primary,
    };
  }
}
