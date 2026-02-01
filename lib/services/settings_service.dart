import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _keyBackgroundServiceEnabled = 'background_service_enabled';
  static const _keyLastCheckedTimestamp = 'last_checked_timestamp';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> isBackgroundServiceEnabled() async {
    await init();
    return _prefs?.getBool(_keyBackgroundServiceEnabled) ?? false;
  }

  Future<void> setBackgroundServiceEnabled(bool enabled) async {
    await init();
    await _prefs?.setBool(_keyBackgroundServiceEnabled, enabled);
  }

  Future<int> getLastCheckedTimestamp() async {
    await init();
    return _prefs?.getInt(_keyLastCheckedTimestamp) ?? 0;
  }

  Future<void> setLastCheckedTimestamp(int timestamp) async {
    await init();
    await _prefs?.setInt(_keyLastCheckedTimestamp, timestamp);
  }
}
