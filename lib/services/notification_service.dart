import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dr_fori_call_center/models/call.dart';

const _kChannelId = 'call_notifications';
const _kChannelName = 'اعلان تماس';
const _kChannelDescription = 'اعلان‌های مربوط به تماس‌های جدید';

const _kIncomingCallTitle = 'تماس ورودی جدید';
const _kOutgoingCallTitle = 'تماس خروجی جدید';
const _kMissedCallTitle = 'تماس از دست رفته';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create notification channel for Android
    await _createNotificationChannel();

    _isInitialized = true;
  }

  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      _kChannelId,
      _kChannelName,
      description: _kChannelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  void _onNotificationTap(NotificationResponse response) {
    // Handle notification tap - could navigate to specific call details
  }

  Future<bool> requestPermission() async {
    final android = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }
    return false;
  }

  Future<bool> hasPermission() async {
    final android = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (android != null) {
      final enabled = await android.areNotificationsEnabled();
      return enabled ?? false;
    }
    return false;
  }

  Future<void> showCallNotification(Call call) async {
    if (!_isInitialized) await init();

    final (title, icon) = switch (call.type) {
      CallType.incoming => (_kIncomingCallTitle, 'call_received'),
      CallType.outgoing => (_kOutgoingCallTitle, 'call_made'),
      CallType.missed => (_kMissedCallTitle, 'call_missed'),
    };

    final simInfo = call.simLabel.isNotEmpty ? ' (${call.simLabel})' : '';
    final body = '${call.displayName}$simInfo';

    final androidDetails = AndroidNotificationDetails(
      _kChannelId,
      _kChannelName,
      channelDescription: _kChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      ticker: title,
      category: AndroidNotificationCategory.call,
      visibility: NotificationVisibility.public,
    );

    final details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      call.timestamp.millisecondsSinceEpoch ~/
          1000, // Unique ID based on timestamp
      title,
      body,
      details,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
