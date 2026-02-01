import 'package:flutter/material.dart';
import 'package:ui_kit/src/foundation/foundation.dart';

class DRText extends StatelessWidget {
  const DRText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _variant = _Variant.bodyMd;

  const DRText.headlineLg(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _variant = _Variant.headlineLg;

  const DRText.headlineMd(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _variant = _Variant.headlineMd;

  const DRText.headlineSm(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _variant = _Variant.headlineSm;

  const DRText.bodyLg(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _variant = _Variant.bodyLg;

  const DRText.label(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _variant = _Variant.label;

  const DRText.caption(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _variant = _Variant.caption;

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final _Variant _variant;

  TextStyle get _baseStyle => switch (_variant) {
    _Variant.headlineLg => DRTypography.headlineLg,
    _Variant.headlineMd => DRTypography.headlineMd,
    _Variant.headlineSm => DRTypography.headlineSm,
    _Variant.bodyLg => DRTypography.bodyLg,
    _Variant.bodyMd => DRTypography.bodyMd,
    _Variant.label => DRTypography.label,
    _Variant.caption => DRTypography.caption,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark
        ? DRColors.neutral.shade100
        : DRColors.neutral.shade700;

    return Text(
      text,
      style: _baseStyle.copyWith(color: color ?? defaultColor),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

enum _Variant {
  headlineLg,
  headlineMd,
  headlineSm,
  bodyLg,
  bodyMd,
  label,
  caption,
}
