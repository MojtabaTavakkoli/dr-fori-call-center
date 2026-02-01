import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

const _kAppTitle = 'دستیار تماس';
const _kShowcaseTitle = 'نمایشگاه UI Kit';
const _kLocaleLanguage = 'fa';
const _kLocaleCountry = 'IR';
const _kLoadingDuration = Duration(seconds: 2);

const _kSectionCards = 'کارت‌ها';
const _kSectionTypography = 'تایپوگرافی';
const _kSectionButtons = 'دکمه‌ها';
const _kSectionInputs = 'فیلدهای ورودی';
const _kSectionLists = 'لیست و آیتم‌ها';
const _kSectionColors = 'رنگ‌ها';

const _kTodayCalls = 'تماس‌های امروز';
const _kCallsCount = '۱۲ تماس';
const _kSentMessages = 'پیام‌های ارسال شده';
const _kThankMessages = '۸ پیام تشکر';

const _kHeadlineLarge = 'عنوان بزرگ';
const _kHeadlineMedium = 'عنوان متوسط';
const _kHeadlineSmall = 'عنوان کوچک';
const _kBodyLarge = 'متن بدنه - برای محتوای اصلی';
const _kBodyMedium = 'متن معمولی - استایل پیش‌فرض';
const _kLabelText = 'برچسب - برای فرم‌ها';
const _kCaptionText = 'توضیحات - اطلاعات ثانویه';

const _kBtnGradient = 'دکمه گرادیانت';
const _kBtnPrimary = 'دکمه اصلی';
const _kBtnOutlined = 'خطی';
const _kBtnGhost = 'شفاف';
const _kBtnWithIcon = 'با آیکون';
const _kBtnLoading = 'در حال بارگذاری';
const _kBtnSmall = 'کوچک';
const _kBtnLarge = 'بزرگ';
const _kBtnDisabled = 'غیرفعال';

const _kPhoneLabel = 'شماره تماس';
const _kPhoneHint = 'شماره تلفن تماس‌گیرنده را وارد کنید';
const _kErrorLabel = 'با خطا';
const _kErrorHint = 'مثال ورودی نامعتبر';
const _kErrorMessage = 'لطفاً یک شماره تلفن معتبر وارد کنید';

const _kRecentCalls = 'تماس‌های اخیر';
const _kNoCalls = 'تماسی وجود ندارد';
const _kCaller1Name = 'علی محمدی';
const _kCaller1Phone = '۰۹۱۲ ۳۴۵ ۶۷۸۹';
const _kCaller1Time = '۲ دقیقه پیش';
const _kCaller2Name = 'زهرا احمدی';
const _kCaller2Phone = '۰۹۳۵ ۱۲۳ ۴۵۶۷';
const _kCaller2Time = '۱۵ دقیقه پیش';

const _kColorPrimary = 'اصلی';
const _kColorSecondary = 'ثانویه';
const _kColorSuccess = 'موفقیت';
const _kColorError = 'خطا';
const _kColorWarning = 'هشدار';

const _kCardIconSize = 56.0;
const _kCardSmallIconSize = 48.0;
const _kCardIconInnerSize = 28.0;
const _kCardSmallIconInnerSize = 24.0;

void main() {
  runApp(const CallerAssistantApp());
}

class CallerAssistantApp extends StatefulWidget {
  const CallerAssistantApp({super.key});

  @override
  State<CallerAssistantApp> createState() => _CallerAssistantAppState();
}

class _CallerAssistantAppState extends State<CallerAssistantApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _kAppTitle,
      debugShowCheckedModeBanner: false,
      theme: DRTheme.light,
      darkTheme: DRTheme.dark,
      themeMode: _themeMode,
      locale: const Locale(_kLocaleLanguage, _kLocaleCountry),
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: UIKitShowcase(onToggleTheme: _toggleTheme),
    );
  }
}

class UIKitShowcase extends StatefulWidget {
  const UIKitShowcase({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  State<UIKitShowcase> createState() => _UIKitShowcaseState();
}

class _UIKitShowcaseState extends State<UIKitShowcase> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  int _selectedIndex = -1;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _simulateLoading() {
    setState(() => _isLoading = true);
    Future.delayed(_kLoadingDuration, () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(_kShowcaseTitle),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DRSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: _kSectionCards,
              children: [
                DRCard.gradient(
                  child: Row(
                    children: [
                      Container(
                        width: _kCardIconSize,
                        height: _kCardIconSize,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: DRRadius.borderMd,
                        ),
                        child: const Icon(
                          Icons.phone_in_talk,
                          color: Colors.white,
                          size: _kCardIconInnerSize,
                        ),
                      ),
                      const SizedBox(width: DRSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _kTodayCalls,
                              style: DRTypography.label.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _kCallsCount,
                              style: DRTypography.headlineMd.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DRSpacing.md),
                DRCard(
                  child: Row(
                    children: [
                      Container(
                        width: _kCardSmallIconSize,
                        height: _kCardSmallIconSize,
                        decoration: BoxDecoration(
                          color: DRColors.success.withValues(alpha: 0.1),
                          borderRadius: DRRadius.borderMd,
                        ),
                        child: Icon(
                          Icons.check_circle_outline,
                          color: DRColors.success,
                          size: _kCardSmallIconInnerSize,
                        ),
                      ),
                      const SizedBox(width: DRSpacing.md),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DRText.label(_kSentMessages),
                            SizedBox(height: 2),
                            DRText.caption(_kThankMessages),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: DRSpacing.xl),

            _buildSection(
              title: _kSectionTypography,
              children: const [
                DRText.headlineLg(_kHeadlineLarge),
                SizedBox(height: DRSpacing.sm),
                DRText.headlineMd(_kHeadlineMedium),
                SizedBox(height: DRSpacing.sm),
                DRText.headlineSm(_kHeadlineSmall),
                SizedBox(height: DRSpacing.sm),
                DRText.bodyLg(_kBodyLarge),
                SizedBox(height: DRSpacing.sm),
                DRText(_kBodyMedium),
                SizedBox(height: DRSpacing.sm),
                DRText.label(_kLabelText),
                SizedBox(height: DRSpacing.sm),
                DRText.caption(_kCaptionText),
              ],
            ),

            const SizedBox(height: DRSpacing.xl),

            _buildSection(
              title: _kSectionButtons,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DRButton.gradient(
                        label: _kBtnGradient,
                        onPressed: _simulateLoading,
                      ),
                    ),
                    const SizedBox(width: DRSpacing.md),
                    Expanded(
                      child: DRButton(label: _kBtnPrimary, onPressed: () {}),
                    ),
                  ],
                ),
                const SizedBox(height: DRSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: DRButton.outlined(
                        label: _kBtnOutlined,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: DRSpacing.md),
                    Expanded(
                      child: DRButton.ghost(
                        label: _kBtnGhost,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DRSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: DRButton.gradient(
                        label: _kBtnWithIcon,
                        onPressed: () {},
                        icon: Icons.phone,
                      ),
                    ),
                    const SizedBox(width: DRSpacing.md),
                    Expanded(
                      child: DRButton(
                        label: _kBtnLoading,
                        onPressed: () {},
                        isLoading: _isLoading,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DRSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: DRButton(
                        label: _kBtnSmall,
                        onPressed: () {},
                        size: DRButtonSize.sm,
                      ),
                    ),
                    const SizedBox(width: DRSpacing.md),
                    Expanded(
                      child: DRButton.gradient(
                        label: _kBtnLarge,
                        onPressed: () {},
                        size: DRButtonSize.lg,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DRSpacing.md),
                const DRButton(label: _kBtnDisabled, width: double.infinity),
              ],
            ),

            const SizedBox(height: DRSpacing.xl),

            _buildSection(
              title: _kSectionInputs,
              children: [
                DRTextField(
                  label: _kPhoneLabel,
                  hint: _kPhoneHint,
                  prefixIcon: Icons.phone_outlined,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: DRSpacing.md),
                const DRTextField(
                  label: _kErrorLabel,
                  hint: _kErrorHint,
                  errorText: _kErrorMessage,
                  prefixIcon: Icons.error_outline,
                ),
              ],
            ),

            const SizedBox(height: DRSpacing.xl),

            _buildSection(
              title: _kSectionLists,
              children: [
                DRList(
                  header: _kRecentCalls,
                  emptyMessage: _kNoCalls,
                  children: [
                    DRListItem(
                      title: _kCaller1Name,
                      subtitle: _kCaller1Phone,
                      leading: const Icon(Icons.person_outline),
                      trailing: DRText.caption(
                        _kCaller1Time,
                        color: DRColors.neutral.shade400,
                      ),
                      isSelected: _selectedIndex == 0,
                      onTap: () => setState(() => _selectedIndex = 0),
                    ),
                    DRListItem(
                      title: _kCaller2Name,
                      subtitle: _kCaller2Phone,
                      leading: const Icon(Icons.person_outline),
                      trailing: DRText.caption(
                        _kCaller2Time,
                        color: DRColors.neutral.shade400,
                      ),
                      isSelected: _selectedIndex == 1,
                      onTap: () => setState(() => _selectedIndex = 1),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: DRSpacing.xl),

            _buildSection(
              title: _kSectionColors,
              children: [
                Wrap(
                  spacing: DRSpacing.sm,
                  runSpacing: DRSpacing.sm,
                  children: [
                    _buildColorChip(_kColorPrimary, DRColors.primary),
                    _buildColorChip(_kColorSecondary, DRColors.secondary),
                    _buildColorChip(_kColorSuccess, DRColors.success),
                    _buildColorChip(_kColorError, DRColors.error),
                    _buildColorChip(_kColorWarning, DRColors.warning),
                  ],
                ),
              ],
            ),

            const SizedBox(height: DRSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DRText.headlineMd(title, color: DRColors.primary),
        const SizedBox(height: DRSpacing.md),
        ...children,
      ],
    );
  }

  Widget _buildColorChip(String name, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DRSpacing.md,
        vertical: DRSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: DRRadius.borderMd,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        name,
        style: DRTypography.label.copyWith(color: Colors.white),
      ),
    );
  }
}
