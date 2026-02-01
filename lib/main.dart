import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:dr_fori_call_center/screens/home_screen.dart';
import 'package:dr_fori_call_center/services/background_service.dart';
import 'package:dr_fori_call_center/services/notification_service.dart';
import 'package:dr_fori_call_center/services/settings_service.dart';

const _kAppTitle = 'دستیار تماس';
const _kLocaleLanguage = 'fa';
const _kLocaleCountry = 'IR';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await NotificationService().init();
  await BackgroundServiceManager().init();
  
  // Auto-start background service if it was previously enabled
  final settingsService = SettingsService();
  final wasEnabled = await settingsService.isBackgroundServiceEnabled();
  if (wasEnabled) {
    await BackgroundServiceManager().start();
  }
  
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
