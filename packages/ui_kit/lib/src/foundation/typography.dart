import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class DRTypography {
  static String get fontFamily => GoogleFonts.vazirmatn().fontFamily!;

  static TextStyle get headlineLg => GoogleFonts.vazirmatn(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.5,
  );

  static TextStyle get headlineMd => GoogleFonts.vazirmatn(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static TextStyle get headlineSm => GoogleFonts.vazirmatn(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle get bodyLg => GoogleFonts.vazirmatn(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static TextStyle get bodyMd => GoogleFonts.vazirmatn(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get label => GoogleFonts.vazirmatn(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle get caption => GoogleFonts.vazirmatn(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle get button => GoogleFonts.vazirmatn(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );
}
