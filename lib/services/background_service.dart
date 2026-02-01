import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:call_log/call_log.dart' as call_log;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dr_fori_call_center/models/call.dart';

const _kNotificationChannelId = 'background_service';
const _kNotificationTitle = 'دستیار تماس';
const _kNotificationContent = 'در حال نظارت بر تماس‌ها...';

const _kCallNotificationChannelId = 'call_notifications';
const _kCallNotificationChannelName = 'اعلان تماس';

const _kIncomingCallTitle = 'تماس ورودی جدید';
const _kOutgoingCallTitle = 'تماس خروجی جدید';
const _kMissedCallTitle = 'تماس از دست رفته';

const _kKeyLastCheckedTimestamp = 'last_checked_timestamp';
const _kCheckInterval = Duration(seconds: 15);

class BackgroundServiceManager {
  static final BackgroundServiceManager _instance =
      BackgroundServiceManager._internal();
  factory BackgroundServiceManager() => _instance;
  BackgroundServiceManager._internal();

  final FlutterBackgroundService _service = FlutterBackgroundService();

  Future<void> init() async {
    await _service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: _onStart,
        onBackground: _onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: _onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: _kNotificationChannelId,
        initialNotificationTitle: _kNotificationTitle,
        initialNotificationContent: _kNotificationContent,
        foregroundServiceNotificationId: 888,
        foregroundServiceTypes: [AndroidForegroundType.phoneCall],
      ),
    );
  }

  Future<bool> isRunning() async {
    return await _service.isRunning();
  }

  Future<void> start() async {
    final isRunning = await _service.isRunning();
    if (!isRunning) {
      await _service.startService();
    }
  }

  Future<void> stop() async {
    _service.invoke('stopService');
  }
}

@pragma('vm:entry-point')
Future<bool> _onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void _onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final notifications = FlutterLocalNotificationsPlugin();

  // Initialize notifications
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);
  await notifications.initialize(initSettings);

  // Create call notification channel
  const callChannel = AndroidNotificationChannel(
    _kCallNotificationChannelId,
    _kCallNotificationChannelName,
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  await notifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(callChannel);

  // Listen for stop command
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // Get SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Check for new calls periodically
  Timer.periodic(_kCheckInterval, (timer) async {
    await _checkForNewCalls(prefs, notifications);
  });

  // Also check immediately on start
  await _checkForNewCalls(prefs, notifications);
}

Future<void> _checkForNewCalls(
  SharedPreferences prefs,
  FlutterLocalNotificationsPlugin notifications,
) async {
  try {
    final lastChecked = prefs.getInt(_kKeyLastCheckedTimestamp) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    // Get recent call logs
    final entries = await call_log.CallLog.get();
    final entriesList = entries.toList();

    // Find new calls since last check
    final newCalls = entriesList.where((entry) {
      final timestamp = entry.timestamp ?? 0;
      return timestamp > lastChecked;
    }).toList();

    // Show notification for each new call
    for (final entry in newCalls) {
      await _showCallNotification(entry, notifications);
    }

    // Update last checked timestamp
    await prefs.setInt(_kKeyLastCheckedTimestamp, now);
  } catch (e) {
    // Silently handle errors in background
  }
}

Future<void> _showCallNotification(
  call_log.CallLogEntry entry,
  FlutterLocalNotificationsPlugin notifications,
) async {
  final callType = _mapCallType(entry.callType);

  final title = switch (callType) {
    CallType.incoming => _kIncomingCallTitle,
    CallType.outgoing => _kOutgoingCallTitle,
    CallType.missed => _kMissedCallTitle,
  };

  final displayName = entry.name ?? entry.number ?? 'ناشناس';
  final simInfo =
      entry.simDisplayName != null && entry.simDisplayName!.isNotEmpty
      ? ' (${entry.simDisplayName})'
      : '';
  final body = '$displayName$simInfo';

  const androidDetails = AndroidNotificationDetails(
    _kCallNotificationChannelId,
    _kCallNotificationChannelName,
    importance: Importance.high,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
    category: AndroidNotificationCategory.call,
    visibility: NotificationVisibility.public,
  );

  const details = NotificationDetails(android: androidDetails);

  await notifications.show(
    (entry.timestamp ?? DateTime.now().millisecondsSinceEpoch) ~/ 1000,
    title,
    body,
    details,
  );
}

CallType _mapCallType(call_log.CallType? type) {
  return switch (type) {
    call_log.CallType.incoming ||
    call_log.CallType.answeredExternally => CallType.incoming,
    call_log.CallType.outgoing => CallType.outgoing,
    call_log.CallType.missed ||
    call_log.CallType.rejected ||
    call_log.CallType.blocked ||
    call_log.CallType.voiceMail => CallType.missed,
    _ => CallType.incoming,
  };
}
