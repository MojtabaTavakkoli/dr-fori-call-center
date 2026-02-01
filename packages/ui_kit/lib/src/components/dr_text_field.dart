import 'package:flutter/material.dart';
import 'package:ui_kit/src/foundation/foundation.dart';

class DRTextField extends StatefulWidget {
  const DRTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.autofocus = false,
  }) : _isPassword = false;

  const DRTextField.password({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
  }) : obscureText = true,
       maxLines = 1,
       _isPassword = true;

  const DRTextField.multiline({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.keyboardType = TextInputType.multiline,
    this.textInputAction = TextInputAction.newline,
    this.maxLines = 4,
    this.autofocus = false,
  }) : obscureText = false,
       _isPassword = false;

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final bool autofocus;
  final bool _isPassword;

  bool get hasError => errorText != null && errorText!.isNotEmpty;

  @override
  State<DRTextField> createState() => _DRTextFieldState();
}

class _DRTextFieldState extends State<DRTextField> {
  bool _isFocused = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shouldObscure = widget._isPassword
        ? _obscureText
        : widget.obscureText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: DRTypography.label.copyWith(
              color: isDark
                  ? DRColors.neutral.shade300
                  : DRColors.neutral.shade600,
            ),
          ),
          const SizedBox(height: DRSpacing.sm),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: DRRadius.borderMd,
            boxShadow: _isFocused && !widget.hasError
                ? DRShadows.md
                : DRShadows.sm,
          ),
          child: Focus(
            onFocusChange: (focused) => setState(() => _isFocused = focused),
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              obscureText: shouldObscure,
              enabled: widget.enabled,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              maxLines: widget.maxLines,
              autofocus: widget.autofocus,
              textDirection: TextDirection.rtl,
              style: DRTypography.bodyMd.copyWith(
                color: isDark
                    ? DRColors.neutral.shade100
                    : DRColors.neutral.shade800,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: DRTypography.bodyMd.copyWith(
                  color: DRColors.neutral.shade400,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: _isFocused
                            ? DRColors.primary
                            : DRColors.neutral.shade400,
                        size: 22,
                      )
                    : null,
                suffixIcon: widget._isPassword
                    ? _buildPasswordToggle()
                    : widget.suffixIcon,
                filled: true,
                fillColor: isDark
                    ? (widget.enabled
                          ? DRColors.surfaceDark
                          : DRColors.neutral.shade800)
                    : (widget.enabled
                          ? DRColors.surface
                          : DRColors.neutral.shade100),
                contentPadding: const EdgeInsets.all(DRSpacing.inputPadding),
                border: _buildBorder(isDark),
                enabledBorder: _buildBorder(isDark, isError: widget.hasError),
                focusedBorder: _buildBorder(
                  isDark,
                  isFocused: true,
                  isError: widget.hasError,
                ),
                disabledBorder: _buildBorder(isDark),
              ),
            ),
          ),
        ),
        if (widget.hasError) ...[
          const SizedBox(height: DRSpacing.xs),
          Text(
            widget.errorText!,
            style: DRTypography.caption.copyWith(color: DRColors.error),
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordToggle() {
    return IconButton(
      icon: Icon(
        _obscureText
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
        color: DRColors.neutral.shade400,
        size: 22,
      ),
      onPressed: () => setState(() => _obscureText = !_obscureText),
    );
  }

  OutlineInputBorder _buildBorder(
    bool isDark, {
    bool isFocused = false,
    bool isError = false,
  }) {
    final defaultColor = isDark
        ? DRColors.neutral.shade700
        : DRColors.neutral.shade200;
    return OutlineInputBorder(
      borderRadius: DRRadius.borderMd,
      borderSide: BorderSide(
        color: isError
            ? DRColors.error
            : (isFocused ? DRColors.primary : defaultColor),
        width: isFocused ? 2 : 1,
      ),
    );
  }
}
