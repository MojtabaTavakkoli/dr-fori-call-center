import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:dr_fori_call_center/models/call.dart';
import 'package:dr_fori_call_center/services/call_service.dart';
import 'package:dr_fori_call_center/screens/settings_screen.dart';

const _kAppBarTitle = 'دستیار تماس';
const _kRecentCallsHeader = 'تماس‌های ۳۰ روز اخیر';
const _kNoCallsMessage = 'هنوز تماسی ثبت نشده است';
const _kSendMessageLabel = 'ارسال پیام';
const _kMessageSentLabel = 'پیام ارسال شد';
const _kIncomingCallLabel = 'تماس ورودی';
const _kOutgoingCallLabel = 'تماس خروجی';
const _kMissedCallLabel = 'تماس از دست رفته';
const _kPermissionTitle = 'دسترسی به تماس‌ها';
const _kPermissionMessage =
    'برای نمایش تماس‌های اخیر، به اپلیکیشن اجازه دسترسی به لیست تماس‌ها را بدهید.';
const _kGrantPermissionLabel = 'اعطای دسترسی';
const _kLoadingMessage = 'در حال بارگذاری...';
const _kRefreshLabel = 'بروزرسانی';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CallService _callService = CallService();
  List<Call> _calls = [];
  bool _isLoading = true;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndLoadCalls();
  }

  Future<void> _checkPermissionAndLoadCalls() async {
    setState(() => _isLoading = true);

    _hasPermission = await _callService.hasPermission();

    if (_hasPermission) {
      await _loadCalls();
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _requestPermission() async {
    final granted = await _callService.requestPermission();
    if (granted) {
      _hasPermission = true;
      await _loadCalls();
    } else {
      setState(() {});
    }
  }

  Future<void> _loadCalls() async {
    setState(() => _isLoading = true);

    final calls = await _callService.getRecentCalls();

    setState(() {
      _calls = calls;
      _isLoading = false;
    });
  }

  void _sendMessage(Call call) {
    final index = _calls.indexWhere((c) => c.id == call.id);
    if (index != -1) {
      setState(() {
        _calls[index] = call.copyWith(messageSent: true);
      });
      _showSnackBar('پیام تشکر به ${call.displayName} ارسال شد');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: DRTypography.bodyMd.copyWith(color: Colors.white),
        ),
        backgroundColor: DRColors.success,
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
      appBar: AppBar(
        title: const Text(_kAppBarTitle),
        actions: [
          if (_hasPermission)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _isLoading ? null : _loadCalls,
              tooltip: _kRefreshLabel,
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              _checkPermissionAndLoadCalls();
            },
          ),
        ],
      ),
      body: _buildBody(isDark),
    );
  }

  Widget _buildBody(bool isDark) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (!_hasPermission) {
      return _buildPermissionRequest();
    }

    if (_calls.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadCalls,
      color: DRColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(DRSpacing.md),
        itemCount: _calls.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: DRSpacing.md),
              child: DRText.label(
                _kRecentCallsHeader,
                color: isDark
                    ? DRColors.neutral.shade400
                    : DRColors.neutral.shade500,
              ),
            );
          }
          return _buildCallCard(_calls[index - 1]);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: DRSpacing.md),
          DRText(_kLoadingMessage),
        ],
      ),
    );
  }

  Widget _buildPermissionRequest() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DRSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: DRColors.warning.withValues(alpha: 0.1),
                borderRadius: DRRadius.borderFull,
              ),
              child: Icon(
                Icons.phone_locked_outlined,
                size: 40,
                color: DRColors.warning,
              ),
            ),
            const SizedBox(height: DRSpacing.lg),
            const DRText.headlineSm(
              _kPermissionTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DRSpacing.sm),
            const DRText(_kPermissionMessage, textAlign: TextAlign.center),
            const SizedBox(height: DRSpacing.xl),
            DRButton.gradient(
              label: _kGrantPermissionLabel,
              icon: Icons.lock_open,
              onPressed: _requestPermission,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: DRColors.primary.withValues(alpha: 0.1),
              borderRadius: DRRadius.borderFull,
            ),
            child: Icon(
              Icons.phone_outlined,
              size: 40,
              color: DRColors.primary,
            ),
          ),
          const SizedBox(height: DRSpacing.lg),
          const DRText.headlineSm(_kNoCallsMessage),
        ],
      ),
    );
  }

  Widget _buildCallCard(Call call) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DRSpacing.sm),
      child: DRCard(
        child: Column(
          children: [
            Row(
              children: [
                _buildCallIcon(call.type),
                const SizedBox(width: DRSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DRText.label(call.displayName),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          DRText.caption(
                            _getCallTypeLabel(call.type),
                            color: _getCallTypeColor(call.type),
                          ),
                          if (call.duration != null &&
                              call.duration!.inSeconds > 0) ...[
                            DRText.caption(
                              ' • ',
                              color: DRColors.neutral.shade400,
                            ),
                            DRText.caption(
                              call.formattedDuration,
                              color: DRColors.neutral.shade400,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (call.simLabel.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DRSpacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: call.simSlot == 0
                              ? DRColors.primary.withValues(alpha: 0.1)
                              : DRColors.secondary.withValues(alpha: 0.1),
                          borderRadius: DRRadius.borderSm,
                        ),
                        child: DRText.caption(
                          call.simLabel,
                          color: call.simSlot == 0
                              ? DRColors.primary
                              : DRColors.secondary,
                        ),
                      ),
                    if (call.simLabel.isNotEmpty) const SizedBox(height: 4),
                    DRText.caption(
                      call.timeAgo,
                      color: DRColors.neutral.shade400,
                    ),
                  ],
                ),
              ],
            ),
            if (call.type == CallType.incoming && !call.messageSent) ...[
              const SizedBox(height: DRSpacing.md),
              SizedBox(
                width: double.infinity,
                child: DRButton.gradient(
                  label: _kSendMessageLabel,
                  icon: Icons.send_outlined,
                  size: DRButtonSize.sm,
                  onPressed: () => _sendMessage(call),
                ),
              ),
            ],
            if (call.messageSent) ...[
              const SizedBox(height: DRSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 16, color: DRColors.success),
                  const SizedBox(width: DRSpacing.xs),
                  DRText.caption(_kMessageSentLabel, color: DRColors.success),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCallIcon(CallType type) {
    final (icon, color) = switch (type) {
      CallType.incoming => (Icons.call_received, DRColors.success),
      CallType.outgoing => (Icons.call_made, DRColors.primary),
      CallType.missed => (Icons.call_missed, DRColors.error),
    };

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: DRRadius.borderMd,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  String _getCallTypeLabel(CallType type) => switch (type) {
    CallType.incoming => _kIncomingCallLabel,
    CallType.outgoing => _kOutgoingCallLabel,
    CallType.missed => _kMissedCallLabel,
  };

  Color _getCallTypeColor(CallType type) => switch (type) {
    CallType.incoming => DRColors.success,
    CallType.outgoing => DRColors.primary,
    CallType.missed => DRColors.error,
  };
}
