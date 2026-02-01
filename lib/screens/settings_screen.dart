import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:dr_fori_call_center/services/call_service.dart';
import 'package:dr_fori_call_center/services/settings_service.dart';
import 'package:dr_fori_call_center/services/background_service.dart';
import 'package:dr_fori_call_center/services/notification_service.dart';

const _kAppBarTitle = 'تنظیمات';
const _kPermissionsSection = 'دسترسی‌ها';
const _kCallLogPermission = 'دسترسی به تاریخچه تماس';
const _kCallLogDescription = 'برای نمایش تماس‌های اخیر نیاز است';
const _kGranted = 'فعال';
const _kDenied = 'غیرفعال';
const _kRequest = 'درخواست';
const _kOpenSettings = 'تنظیمات';
const _kBackgroundSection = 'سرویس پس‌زمینه';
const _kBackgroundServiceTitle = 'اجرا در پس‌زمینه';
const _kBackgroundServiceDescription = 'اعلان برای تماس‌های جدید';
const _kNotificationPermissionRequired =
    'برای دریافت اعلان، اجازه دسترسی نیاز است';
const _kBackgroundServiceEnabled = 'سرویس پس‌زمینه فعال شد';
const _kBackgroundServiceDisabled = 'سرویس پس‌زمینه غیرفعال شد';
const _kAboutSection = 'درباره';
const _kAppName = 'دستیار تماس';
const _kAppVersion = 'نسخه ۱.۰.۰';
const _kPermissionGrantedMessage = 'دسترسی با موفقیت فعال شد';
const _kPermissionDeniedMessage =
    'دسترسی رد شد. لطفاً از تنظیمات گوشی اقدام کنید';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final CallService _callService = CallService();
  final SettingsService _settingsService = SettingsService();
  final BackgroundServiceManager _backgroundService =
      BackgroundServiceManager();
  final NotificationService _notificationService = NotificationService();

  PermissionStatus _phonePermissionStatus = PermissionStatus.denied;
  bool _isBackgroundServiceEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    final status = await _callService.getPermissionStatus();
    final isBackgroundEnabled = await _settingsService
        .isBackgroundServiceEnabled();
    final isServiceRunning = await _backgroundService.isRunning();

    setState(() {
      _phonePermissionStatus = status;
      _isBackgroundServiceEnabled = isBackgroundEnabled && isServiceRunning;
      _isLoading = false;
    });
  }

  Future<void> _loadPermissionStatus() async {
    setState(() => _isLoading = true);
    final status = await _callService.getPermissionStatus();
    setState(() {
      _phonePermissionStatus = status;
      _isLoading = false;
    });
  }

  Future<void> _toggleBackgroundService(bool enabled) async {
    if (enabled) {
      // Check notification permission first
      final hasNotificationPermission = await _notificationService
          .hasPermission();
      if (!hasNotificationPermission) {
        final granted = await _notificationService.requestPermission();
        if (!granted) {
          _showSnackBar(_kNotificationPermissionRequired, DRColors.warning);
          return;
        }
      }

      // Start background service
      await _backgroundService.start();
      await _settingsService.setBackgroundServiceEnabled(true);

      // Set last checked timestamp to now to avoid showing old notifications
      await _settingsService.setLastCheckedTimestamp(
        DateTime.now().millisecondsSinceEpoch,
      );

      setState(() => _isBackgroundServiceEnabled = true);
      _showSnackBar(_kBackgroundServiceEnabled, DRColors.success);
    } else {
      // Stop background service
      await _backgroundService.stop();
      await _settingsService.setBackgroundServiceEnabled(false);

      setState(() => _isBackgroundServiceEnabled = false);
      _showSnackBar(_kBackgroundServiceDisabled, DRColors.neutral);
    }
  }

  Future<void> _requestPermission() async {
    final granted = await _callService.requestPermission();
    await _loadPermissionStatus();

    if (mounted) {
      _showSnackBar(
        granted ? _kPermissionGrantedMessage : _kPermissionDeniedMessage,
        granted ? DRColors.success : DRColors.error,
      );
    }
  }

  Future<void> _openAppSettings() async {
    await openAppSettings();
    await Future.delayed(const Duration(seconds: 1));
    await _loadPermissionStatus();
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: DRTypography.bodyMd.copyWith(color: Colors.white),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: DRRadius.borderMd),
        margin: const EdgeInsets.all(DRSpacing.md),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text(_kAppBarTitle)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(DRSpacing.md),
              children: [
                _buildSectionHeader(_kBackgroundSection, isDark),
                const SizedBox(height: DRSpacing.sm),
                _buildBackgroundServiceCard(isDark),
                const SizedBox(height: DRSpacing.xl),
                _buildSectionHeader(_kPermissionsSection, isDark),
                const SizedBox(height: DRSpacing.sm),
                _buildPermissionCard(isDark),
                const SizedBox(height: DRSpacing.xl),
                _buildSectionHeader(_kAboutSection, isDark),
                const SizedBox(height: DRSpacing.sm),
                _buildAboutCard(isDark),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return DRText.label(
      title,
      color: isDark ? DRColors.neutral.shade400 : DRColors.neutral.shade500,
    );
  }

  Widget _buildBackgroundServiceCard(bool isDark) {
    return DRCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:
                  (_isBackgroundServiceEnabled
                          ? DRColors.primary
                          : DRColors.neutral)
                      .withValues(alpha: 0.1),
              borderRadius: DRRadius.borderMd,
            ),
            child: Icon(
              _isBackgroundServiceEnabled
                  ? Icons.notifications_active
                  : Icons.notifications_outlined,
              color: _isBackgroundServiceEnabled
                  ? DRColors.primary
                  : DRColors.neutral,
              size: 24,
            ),
          ),
          const SizedBox(width: DRSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DRText.label(_kBackgroundServiceTitle),
                const SizedBox(height: 2),
                const DRText.caption(_kBackgroundServiceDescription),
              ],
            ),
          ),
          DRSwitch(
            value: _isBackgroundServiceEnabled,
            onChanged: _toggleBackgroundService,
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionCard(bool isDark) {
    final isGranted = _phonePermissionStatus.isGranted;
    final isPermanentlyDenied = _phonePermissionStatus.isPermanentlyDenied;

    return DRCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (isGranted ? DRColors.success : DRColors.warning)
                      .withValues(alpha: 0.1),
                  borderRadius: DRRadius.borderMd,
                ),
                child: Icon(
                  isGranted
                      ? Icons.check_circle_outline
                      : Icons.phone_locked_outlined,
                  color: isGranted ? DRColors.success : DRColors.warning,
                  size: 24,
                ),
              ),
              const SizedBox(width: DRSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DRText.label(_kCallLogPermission),
                    const SizedBox(height: 2),
                    const DRText.caption(_kCallLogDescription),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DRSpacing.sm,
                  vertical: DRSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: (isGranted ? DRColors.success : DRColors.error)
                      .withValues(alpha: 0.1),
                  borderRadius: DRRadius.borderSm,
                ),
                child: DRText.caption(
                  isGranted ? _kGranted : _kDenied,
                  color: isGranted ? DRColors.success : DRColors.error,
                ),
              ),
            ],
          ),
          if (!isGranted) ...[
            const SizedBox(height: DRSpacing.md),
            SizedBox(
              width: double.infinity,
              child: isPermanentlyDenied
                  ? DRButton.outlined(
                      label: _kOpenSettings,
                      icon: Icons.settings_outlined,
                      size: DRButtonSize.sm,
                      onPressed: _openAppSettings,
                    )
                  : DRButton.gradient(
                      label: _kRequest,
                      icon: Icons.lock_open,
                      size: DRButtonSize.sm,
                      onPressed: _requestPermission,
                    ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAboutCard(bool isDark) {
    return DRCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: DRColors.primaryGradient,
              borderRadius: DRRadius.borderMd,
            ),
            child: const Icon(
              Icons.phone_in_talk,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: DRSpacing.md),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DRText.label(_kAppName),
                SizedBox(height: 2),
                DRText.caption(_kAppVersion),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
