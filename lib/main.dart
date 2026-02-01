import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:dr_fori_call_center/screens/home_screen.dart';

const _kAppTitle = 'دستیار تماس';
const _kLocaleLanguage = 'fa';
const _kLocaleCountry = 'IR';

void main() {
  runApp(const CallerAssistantApp());
}

class CallerAssistantApp extends StatefulWidget {
  const CallerAssistantApp({super.key});

  @override
  State<CallerAssistantApp> createState() => _CallerAssistantAppState();
}

class _CallerAssistantAppState extends State<CallerAssistantApp> {
  final ThemeMode _themeMode = ThemeMode.light;

  // void _toggleTheme() {
  //   setState(() {
  //     _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _kAppTitle,
      debugShowCheckedModeBanner: false,
      theme: DRTheme.light,
      darkTheme: DRTheme.dark,
      themeMode: _themeMode,
      locale: const Locale(_kLocaleLanguage, _kLocaleCountry),
      builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
      home: const HomeScreen(),
    );
  }
}
