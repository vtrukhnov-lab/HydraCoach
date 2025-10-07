import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/notification_service.dart' as notif;
import '../services/subscription_service.dart';
import '../screens/paywall_screen.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // Настройки уведомлений
  bool _postCoffeeReminders = true;
  bool _eveningReports = true;
  bool _heatWarnings = true;
  bool _postAlcoholReminders = true;
  bool _postWorkoutReminders = true;

  // Время уведомлений
  TimeOfDay _morningTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _eveningTime = const TimeOfDay(hour: 21, minute: 0);

  // Частота напоминаний
  int _reminderFrequency = 4; // раз в день

  // Тихие часы (PRO)
  bool _quietHoursEnabled = false;
  TimeOfDay _quietStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietEnd = const TimeOfDay(hour: 7, minute: 0);

  // Статистика
  int _todayCount = 0;

  // Debug режим
  bool _showDebugPanel = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _showPaywall() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            const PaywallScreen(showCloseButton: true, source: 'notifications'),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _postCoffeeReminders = prefs.getBool('post_coffee_reminders') ?? true;
      _eveningReports = prefs.getBool('evening_reports') ?? true;
      _heatWarnings = prefs.getBool('heat_warnings') ?? true;
      _postAlcoholReminders = prefs.getBool('post_alcohol_reminders') ?? true;
      _postWorkoutReminders = prefs.getBool('post_workout_reminders') ?? true;
      _quietHoursEnabled = prefs.getBool('quiet_hours_enabled') ?? false;
      _todayCount = prefs.getInt('notification_count_today') ?? 0;
      // Безопасная загрузка frequency - может быть строкой или int
      final freqValue = prefs.get('reminder_frequency');
      if (freqValue is int) {
        _reminderFrequency = freqValue;
      } else if (freqValue is String) {
        _reminderFrequency = int.tryParse(freqValue) ?? 4;
      } else {
        _reminderFrequency = 4;
      }

      // Загрузка времени
      final morningMinutes = prefs.getInt('morning_time') ?? 480; // 8:00
      _morningTime = TimeOfDay(
        hour: morningMinutes ~/ 60,
        minute: morningMinutes % 60,
      );

      final eveningMinutes =
          prefs.getInt('evening_report_time') ?? 1260; // 21:00
      _eveningTime = TimeOfDay(
        hour: eveningMinutes ~/ 60,
        minute: eveningMinutes % 60,
      );

      final quietStartMinutes =
          prefs.getInt('quiet_hours_start') ?? 1320; // 22:00
      _quietStart = TimeOfDay(
        hour: quietStartMinutes ~/ 60,
        minute: quietStartMinutes % 60,
      );

      final quietEndMinutes = prefs.getInt('quiet_hours_end') ?? 420; // 7:00
      _quietEnd = TimeOfDay(
        hour: quietEndMinutes ~/ 60,
        minute: quietEndMinutes % 60,
      );
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Сохраняем основные настройки
    await prefs.setBool('notificationsEnabled', true); // Всегда включены
    await prefs.setBool('water_reminders', true); // Всегда включены
    await prefs.setBool('post_coffee_reminders', _postCoffeeReminders);
    await prefs.setBool('evening_reports', _eveningReports);
    await prefs.setBool('heat_warnings', _heatWarnings);
    await prefs.setBool('post_alcohol_reminders', _postAlcoholReminders);
    await prefs.setBool('post_workout_reminders', _postWorkoutReminders);
    await prefs.setBool('quiet_hours_enabled', _quietHoursEnabled);
    await prefs.setInt('reminder_frequency', _reminderFrequency);

    // Сохраняем время в минутах
    await prefs.setInt(
      'morning_time',
      _morningTime.hour * 60 + _morningTime.minute,
    );
    await prefs.setInt(
      'evening_report_time',
      _eveningTime.hour * 60 + _eveningTime.minute,
    );
    await prefs.setInt(
      'quiet_hours_start',
      _quietStart.hour * 60 + _quietStart.minute,
    );
    await prefs.setInt(
      'quiet_hours_end',
      _quietEnd.hour * 60 + _quietEnd.minute,
    );

    // Дублируем в строковом формате для NotificationService
    await prefs.setString(
      'evening_report_time',
      '${_eveningTime.hour.toString().padLeft(2, '0')}:${_eveningTime.minute.toString().padLeft(2, '0')}',
    );
    await prefs.setString(
      'quiet_hours_start',
      '${_quietStart.hour.toString().padLeft(2, '0')}:${_quietStart.minute.toString().padLeft(2, '0')}',
    );
    await prefs.setString(
      'quiet_hours_end',
      '${_quietEnd.hour.toString().padLeft(2, '0')}:${_quietEnd.minute.toString().padLeft(2, '0')}',
    );

    // Перепланируем уведомления
    await _rescheduleNotifications();
  }

  Future<void> _rescheduleNotifications() async {
    // Планируем умные напоминания (включая базовые о воде)
    await notif.NotificationService().scheduleSmartReminders();

    // Если включен вечерний отчёт, планируем его отдельно
    if (_eveningReports) {
      await notif.NotificationService().scheduleEveningReport();
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    TimeOfDay initialTime,
    Function(TimeOfDay) onTimeSelected,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      onTimeSelected(picked);
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final subscription = context.watch<SubscriptionProvider>();
    final isPro = subscription.isPro;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(l10n.notificationsSection),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (kDebugMode)
            IconButton(
              icon: Icon(
                _showDebugPanel ? Icons.bug_report : Icons.bug_report_outlined,
              ),
              onPressed: () =>
                  setState(() => _showDebugPanel = !_showDebugPanel),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Секция: Базовые напоминания
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  l10n.waterReminders,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              _buildBasicReminders(theme, l10n),

              // Секция: Частота напоминаний
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  l10n.reminderFrequency,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              _buildReminderFrequency(theme, l10n, isPro),

              // Секция: Дополнительные напоминания
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  'Additional Reminders',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              _buildAdditionalReminders(theme, l10n),

              // PRO функции или их разблокировка
              if (isPro) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    l10n.smartReminders,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                _buildProReminders(theme, l10n),
                _buildQuietHours(theme, l10n),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    l10n.proFeaturesSection,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                _buildProPreview(theme, l10n),
              ],

              // Debug панель
              if (_showDebugPanel && kDebugMode) _buildDebugPanel(theme, isPro),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicReminders(ThemeData theme, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Утреннее напоминание
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.wb_sunny, color: Colors.amber, size: 20),
            ),
            title: Text(l10n.startOfDay),
            subtitle: const Text('First reminder of the day'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(_morningTime),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
              ],
            ),
            onTap: () => _selectTime(context, _morningTime, (time) {
              setState(() => _morningTime = time);
            }),
          ),
          const Divider(height: 1),
          // Вечерний отчёт
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.indigo.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.nightlight_round,
                color: Colors.indigo,
                size: 20,
              ),
            ),
            title: Text(l10n.dailyReportTitle),
            subtitle: Text(l10n.dailyReportBody),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_eveningReports)
                  Text(
                    _formatTime(_eveningTime),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                Switch(
                  value: _eveningReports,
                  onChanged: (value) {
                    setState(() => _eveningReports = value);
                    _saveSettings();
                  },
                ),
              ],
            ),
            onTap: _eveningReports
                ? () => _selectTime(context, _eveningTime, (time) {
                    setState(() => _eveningTime = time);
                  })
                : null,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms);
  }

  Widget _buildAdditionalReminders(ThemeData theme, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.brown.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.coffee, color: Colors.brown, size: 20),
            ),
            title: Text(l10n.postCoffeeReminders),
            subtitle: Text(l10n.postCoffeeRemindersDesc),
            value: _postCoffeeReminders,
            onChanged: (value) {
              setState(() => _postCoffeeReminders = value);
              _saveSettings();
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildProReminders(ThemeData theme, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.thermostat,
                color: Colors.orange,
                size: 20,
              ),
            ),
            title: Text(l10n.heatWarnings),
            subtitle: Text(l10n.heatWarningsDesc),
            value: _heatWarnings,
            onChanged: (value) {
              setState(() => _heatWarnings = value);
              _saveSettings();
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_bar,
                color: Colors.purple,
                size: 20,
              ),
            ),
            title: Text(l10n.postAlcoholReminders),
            subtitle: Text(l10n.postAlcoholRemindersDesc),
            value: _postAlcoholReminders,
            onChanged: (value) {
              setState(() => _postAlcoholReminders = value);
              _saveSettings();
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.fitness_center,
                color: Colors.green,
                size: 20,
              ),
            ),
            title: Text(l10n.notificationPostWorkoutTitle),
            subtitle: Text(l10n.notificationPostWorkoutBody),
            value: _postWorkoutReminders,
            onChanged: (value) {
              setState(() => _postWorkoutReminders = value);
              _saveSettings();
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildQuietHours(ThemeData theme, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (_quietHoursEnabled ? Colors.purple : Colors.grey)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.do_not_disturb,
                  color: _quietHoursEnabled ? Colors.purple : Colors.grey,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quiet Hours',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      _quietHoursEnabled
                          ? '${_formatTime(_quietStart)} - ${_formatTime(_quietEnd)}'
                          : 'No notifications during sleep',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _quietHoursEnabled,
                onChanged: (value) {
                  setState(() => _quietHoursEnabled = value);
                  _saveSettings();
                },
              ),
            ],
          ),
          if (_quietHoursEnabled) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context, _quietStart, (time) {
                      setState(() => _quietStart = time);
                    }),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'From',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            _formatTime(_quietStart),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context, _quietEnd, (time) {
                      setState(() => _quietEnd = time);
                    }),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'To',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            _formatTime(_quietEnd),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildProPreview(ThemeData theme, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFD700).withValues(alpha: 0.1),
            const Color(0xFFFFA500).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFD700).withValues(alpha: 0.3),
        ),
      ),
      child: InkWell(
        onTap: _showPaywall,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.unlockPro,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.unlockProDesc,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  _ProFeatureItem(
                    icon: Icons.all_inclusive,
                    text: l10n.noNotificationLimit,
                  ),
                  _ProFeatureItem(
                    icon: Icons.coffee,
                    text: l10n.postCoffeeReminders,
                  ),
                  _ProFeatureItem(
                    icon: Icons.wb_sunny,
                    text: l10n.heatWarnings,
                  ),
                  _ProFeatureItem(
                    icon: Icons.local_bar,
                    text: l10n.postAlcoholReminders,
                  ),
                  _ProFeatureItem(
                    icon: Icons.fitness_center,
                    text: l10n.notificationPostWorkoutTitle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 150.ms);
  }

  Widget _buildReminderFrequency(
    ThemeData theme,
    AppLocalizations l10n,
    bool isPro,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.schedule, color: Colors.blue),
        ),
        title: Text(l10n.reminderFrequency),
        subtitle: Text(l10n.timesPerDay(_reminderFrequency)),
        trailing: Icon(Icons.chevron_right),
        onTap: () => _showFrequencyDialog(l10n, isPro),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildDebugPanel(ThemeData theme, bool isPro) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.yellow.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.yellow.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bug_report, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Text(
                'Debug Panel (${isPro ? "PRO" : "FREE"})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Divider(),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  await notif.NotificationService().sendTestNotification();
                  if (mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Test sent')));
                  }
                },
                icon: const Icon(Icons.send, size: 16),
                label: const Text('Test', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await notif.NotificationService().scheduleTestIn1Minute();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Scheduled in 1 min')),
                    );
                  }
                },
                icon: const Icon(Icons.schedule, size: 16),
                label: const Text('1 min', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await notif.NotificationService().printNotificationStatus();
                },
                icon: const Icon(Icons.info, size: 16),
                label: const Text('Status', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  // Debug toggle removed - use subscription service instead
                  _loadSettings();
                },
                icon: const Icon(Icons.star, size: 16),
                label: Text(
                  isPro ? 'PRO Active' : 'FREE',
                  style: const TextStyle(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  void _showFrequencyDialog(AppLocalizations l10n, bool isPro) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.reminderFrequency),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: (isPro ? [2, 3, 4, 6, 8, 12] : [2, 3, 4])
              .map(
                (freq) => RadioListTile<int>(
                  title: Text(l10n.timesPerDay(freq)),
                  subtitle: !isPro && freq > 4
                      ? const Text(
                          'PRO',
                          style: TextStyle(color: Colors.orange),
                        )
                      : null,
                  value: freq,
                  groupValue: _reminderFrequency,
                  onChanged: (freq <= 4 || isPro)
                      ? (value) {
                          setState(() {
                            _reminderFrequency = value!;
                          });
                          _saveSettings();
                          Navigator.pop(context);
                        }
                      : null,
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}

class _ProFeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ProFeatureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFFFD700)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
