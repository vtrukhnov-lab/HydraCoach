import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Для kDebugMode
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hydracoach/providers/hydration_provider.dart';
import '../l10n/app_localizations.dart';
import '../services/notification_service.dart' as notif;
import '../services/subscription_service.dart';
import '../services/locale_service.dart';
import '../services/units_service.dart';
import '../screens/paywall_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _postCoffeeReminders = true;
  bool _heatWarnings = true;
  bool _postAlcoholReminders = false;
  String _morningTime = '07:00';
  String _eveningTime = '22:00';
  int _reminderFrequency = 4;
  
  Map<String, dynamic> _notificationStats = {};
  
  // Debug: для отслеживания статуса тестовых уведомлений
  bool _testNotificationScheduled = false;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadNotificationStats();
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _postCoffeeReminders = prefs.getBool('postCoffeeReminders') ?? true;
      _heatWarnings = prefs.getBool('heatWarnings') ?? true;
      _postAlcoholReminders = prefs.getBool('postAlcoholReminder') ?? false;
      _morningTime = prefs.getString('morningTime') ?? '07:00';
      _eveningTime = prefs.getString('eveningTime') ?? '22:00';
      _reminderFrequency = prefs.getInt('reminderFrequency') ?? 4;
    });
  }
  
  Future<void> _loadNotificationStats() async {
    // Получаем статистику напрямую из SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final isPro = prefs.getBool('is_pro') ?? false;
    final todayCount = prefs.getInt('notification_count_today') ?? 0;
    
    setState(() {
      _notificationStats = {
        'is_pro': isPro,
        'today_count': todayCount,
        'daily_limit': isPro ? -1 : 4,
        'remaining_today': isPro ? -1 : (4 - todayCount),
      };
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setBool('postCoffeeReminders', _postCoffeeReminders);
    await prefs.setBool('heatWarnings', _heatWarnings);
    await prefs.setBool('postAlcoholReminder', _postAlcoholReminders);
    await prefs.setString('morningTime', _morningTime);
    await prefs.setString('eveningTime', _eveningTime);
    await prefs.setInt('reminderFrequency', _reminderFrequency);
    
    // Сохраняем настройки для использования новым сервисом
    await prefs.setBool('remindersEnabled', _notificationsEnabled);
    await prefs.setString('quiet_hours_start', _eveningTime);
    await prefs.setString('quiet_hours_end', _morningTime);
    await prefs.setBool('quiet_hours_enabled', _notificationsEnabled);
    
    // Перепланируем уведомления если включены
    if (_notificationsEnabled) {
      await notif.NotificationService().scheduleSmartReminders();
    } else {
      await notif.NotificationService().cancelAllNotifications();
    }
    
    await _loadNotificationStats();
  }

  void _showPaywall() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(showCloseButton: true),
        fullscreenDialog: true,
      ),
    ).then((_) {
      _loadNotificationStats();
    });
  }

  // DEBUG: Методы для тестирования
  Future<void> _sendTestNotification() async {
    try {
      await notif.NotificationService().sendTestNotification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Test notification sent!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _scheduleTestNotification() async {
    try {
      await notif.NotificationService().scheduleTestIn1Minute();
      setState(() {
        _testNotificationScheduled = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⏰ Notification scheduled for 1 minute from now'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 3),
          ),
        );
      }
      // Reset flag after 2 minutes
      Future.delayed(const Duration(minutes: 2), () {
        if (mounted) {
          setState(() {
            _testNotificationScheduled = false;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showNotificationStatus() async {
    await notif.NotificationService().printNotificationStatus();
    
    final pending = await notif.NotificationService().getPendingNotifications();
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('📋 Notification Status'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pending: ${pending.length} notifications'),
                const SizedBox(height: 8),
                Text('PRO Status: ${_notificationStats['is_pro'] ? 'Yes' : 'No'}'),
                Text('Sent Today: ${_notificationStats['today_count']}'),
                if (!_notificationStats['is_pro'])
                  Text('Daily Limit: 4'),
                const Divider(),
                const Text('Scheduled:', style: TextStyle(fontWeight: FontWeight.bold)),
                if (pending.isEmpty)
                  const Text('No pending notifications')
                else
                  ...pending.take(5).map((n) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ${n.title}', style: const TextStyle(fontWeight: FontWeight.w500)),
                        Text('  ${n.body}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  )),
                if (pending.length > 5)
                  Text('\n...and ${pending.length - 5} more'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _cancelAllNotifications() async {
    await notif.NotificationService().cancelAllNotifications();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🗑️ All notifications cancelled'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _toggleProStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final currentStatus = _notificationStats['is_pro'] == true;
    final newStatus = !currentStatus;
    
    await prefs.setBool('is_pro', newStatus);
    await _loadNotificationStats();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newStatus ? '⭐ PRO status enabled' : '🆓 FREE status set'),
          backgroundColor: newStatus ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // DEBUG: Widget для тестового раздела
  Widget _buildDebugSection() {
    if (!kDebugMode) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🧪 DEBUG TESTING'),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.purple.shade200, width: 2),
          ),
          child: Column(
            children: [
              const Row(
                children: [
                  Icon(Icons.bug_report, color: Colors.purple, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Testing Features',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              const Divider(height: 16),
              
              // Test Notification Button
              ListTile(
                leading: const Icon(Icons.notifications_active, color: Colors.purple),
                title: const Text('Send Test Notification'),
                subtitle: const Text('Sends immediately'),
                trailing: const Icon(Icons.send),
                onTap: _sendTestNotification,
              ),
              
              const Divider(height: 1),
              
              // Schedule Test Button
              ListTile(
                leading: const Icon(Icons.schedule, color: Colors.purple),
                title: const Text('Schedule Test (1 min)'),
                subtitle: Text(_testNotificationScheduled 
                  ? 'Scheduled ⏰' 
                  : 'Will arrive in 1 minute'),
                trailing: Icon(
                  _testNotificationScheduled ? Icons.check_circle : Icons.timer,
                  color: _testNotificationScheduled ? Colors.green : null,
                ),
                onTap: _testNotificationScheduled ? null : _scheduleTestNotification,
              ),
              
              const Divider(height: 1),
              
              // Show Status Button
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.purple),
                title: const Text('Show Notification Status'),
                subtitle: const Text('View pending & stats'),
                trailing: const Icon(Icons.visibility),
                onTap: _showNotificationStatus,
              ),
              
              const Divider(height: 1),
              
              // Cancel All Button
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text('Cancel All Notifications'),
                subtitle: const Text('Clear all scheduled'),
                trailing: const Icon(Icons.delete_forever),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Cancel All?'),
                      content: const Text('This will cancel all scheduled notifications.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _cancelAllNotifications();
                          },
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Yes, Cancel All'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              const Divider(height: 1),
              
              // Toggle PRO Status Button
              ListTile(
                leading: Icon(
                  _notificationStats['is_pro'] == true ? Icons.star : Icons.star_outline,
                  color: Colors.purple,
                ),
                title: const Text('Toggle PRO Status'),
                subtitle: Text(
                  'Current: ${_notificationStats['is_pro'] == true ? "PRO" : "FREE"}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _notificationStats['is_pro'] == true ? Colors.green : Colors.grey,
                  ),
                ),
                trailing: const Icon(Icons.swap_horiz),
                onTap: _toggleProStatus,
              ),
              
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, size: 16, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Debug features are only visible in development builds',
                        style: TextStyle(fontSize: 11, color: Colors.brown),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1),
      ],
    );
  }
  
  void _showLanguageDialog() {
    final l10n = AppLocalizations.of(context);
    final localeService = Provider.of<LocaleService>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: LocaleService.supportedLocales.map((localeInfo) {
            return RadioListTile<String>(
              title: Row(
                children: [
                  Text(localeInfo.flag, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Text(localeInfo.name),
                ],
              ),
              value: localeInfo.code,
              groupValue: localeService.currentLocale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  localeService.setLocale(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
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
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // УБРАЛИ AppBar полностью
      body: SafeArea(
        child: Consumer4<HydrationProvider, SubscriptionProvider, LocaleService, UnitsService>(
          builder: (context, hydrationProvider, subscriptionProvider, localeService, unitsService, child) {
            final isPro = subscriptionProvider.isPro;
            
            // Используем UnitsService для форматирования веса
            final displayWeight = unitsService.formatWeight(hydrationProvider.weight);
            
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок без AppBar
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text(
                      l10n.settingsTitle,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(duration: 350.ms),
                  ),
                  
                  // DEBUG SECTION - показывается только в debug режиме
                  _buildDebugSection(),
                  
                  // Language Selector
                  _buildSectionTitle(l10n.languageSection),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.language, color: Colors.blue),
                      title: Text(l10n.languageSettings),
                      subtitle: Text(localeService.getCurrentLocaleInfo().name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            localeService.getCurrentLocaleInfo().flag,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: _showLanguageDialog,
                    ),
                  ).animate().fadeIn(),
                  
                  // Profile Section with Units Display
                  _buildSectionTitle(l10n.profileSection),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildProfileTile(
                          l10n.weight,
                          displayWeight, // Используем форматированный вес от UnitsService
                          Icons.monitor_weight_outlined,
                          () => _showWeightDialog(hydrationProvider, unitsService, l10n),
                        ),
                        _buildDivider(),
                        _buildProfileTile(
                          l10n.dietMode,
                          _getDietModeText(hydrationProvider.dietMode, l10n),
                          Icons.restaurant_menu,
                          () => _showDietDialog(hydrationProvider, l10n),
                        ),
                        _buildDivider(),
                        _buildProfileTile(
                          l10n.activityLevel,
                          _getActivityText(hydrationProvider.activityLevel, l10n),
                          Icons.fitness_center,
                          () => _showActivityDialog(hydrationProvider, l10n),
                        ),
                        _buildDivider(),
                        // Отображаем текущую систему единиц (только для информации)
                        ListTile(
                          leading: const Icon(Icons.straighten, color: Colors.blue),
                          title: Text(l10n.unitsSection),
                          subtitle: Text(
                            unitsService.isMetric ? l10n.metricSystem : l10n.imperialSystem,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              unitsService.isMetric ? l10n.metricUnits : l10n.imperialUnits,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(),
                  
                  // Notifications
                  _buildSectionTitle(l10n.notificationsSection),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        if (!isPro && _notificationStats.isNotEmpty) ...[
                          Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.notificationLimit,
                                        style: TextStyle(
                                          color: Colors.blue.shade900,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        l10n.notificationUsage(
                                          _notificationStats['today_count'] ?? 0,
                                          4,
                                        ),
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: _showPaywall,
                                  child: const Text('PRO', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          _buildDivider(),
                        ],
                        
                        _buildSwitchTile(
                          l10n.waterReminders,
                          l10n.waterRemindersDesc,
                          _notificationsEnabled,
                          (value) {
                            setState(() {
                              _notificationsEnabled = value;
                            });
                            _saveSettings();
                          },
                          isPro: false,
                        ),
                        
                        if (_notificationsEnabled) ...[
                          _buildDivider(),
                          _buildListTile(
                            l10n.reminderFrequency,
                            isPro ? l10n.unlimitedReminders : l10n.maxTimesPerDay(_reminderFrequency),
                            Icons.access_time,
                            () => isPro ? _showFrequencyDialog(l10n) : _showPaywall(),
                            isPro: !isPro,
                          ),
                          _buildDivider(),
                          _buildListTile(
                            l10n.startOfDay,
                            _morningTime,
                            Icons.wb_sunny_outlined,
                            () => _showTimePicker(true),
                            isPro: false,
                          ),
                          _buildDivider(),
                          _buildListTile(
                            l10n.endOfDay,
                            _eveningTime,
                            Icons.nightlight_outlined,
                            () => _showTimePicker(false),
                            isPro: false,
                          ),
                        ],
                        
                        _buildDivider(),
                        _buildSwitchTile(
                          l10n.postCoffeeReminders,
                          l10n.postCoffeeRemindersDesc,
                          _postCoffeeReminders && isPro,
                          isPro ? (value) {
                            setState(() {
                              _postCoffeeReminders = value;
                            });
                            _saveSettings();
                          } : (value) => _showPaywall(),
                          isPro: true,
                        ),
                        
                        _buildDivider(),
                        _buildSwitchTile(
                          l10n.heatWarnings,
                          l10n.heatWarningsDesc,
                          _heatWarnings && isPro,
                          isPro ? (value) {
                            setState(() {
                              _heatWarnings = value;
                            });
                            _saveSettings();
                          } : (value) => _showPaywall(),
                          isPro: true,
                        ),
                        
                        _buildDivider(),
                        _buildSwitchTile(
                          l10n.postAlcoholReminders,
                          l10n.postAlcoholRemindersDesc,
                          _postAlcoholReminders && isPro,
                          isPro ? (value) {
                            setState(() {
                              _postAlcoholReminders = value;
                            });
                            _saveSettings();
                          } : (value) => _showPaywall(),
                          isPro: true,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms),
                  
                  // PRO features (if user is FREE)
                  if (!isPro) ...[
                    _buildSectionTitle(l10n.proFeaturesSection),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFFD700).withOpacity(0.1),
                            const Color(0xFFFFA500).withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFFD700).withOpacity(0.3),
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
                                  _ProFeatureItem(icon: Icons.all_inclusive, text: l10n.noNotificationLimit),
                                  _ProFeatureItem(icon: Icons.coffee, text: l10n.postCoffeeReminders),
                                  _ProFeatureItem(icon: Icons.wb_sunny, text: l10n.heatWarnings),
                                  _ProFeatureItem(icon: Icons.local_bar, text: l10n.postAlcoholReminders),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 150.ms),
                  ],
                  
                  // About
                  _buildSectionTitle(l10n.aboutSection),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildListTile(
                          l10n.version,
                          '0.4.0',
                          Icons.info_outline,
                          null,
                        ),
                        _buildDivider(),
                        _buildListTile(
                          l10n.rateApp,
                          '',
                          Icons.star_outline,
                          () {
                            // TODO: Open App Store / Google Play
                          },
                        ),
                        _buildDivider(),
                        _buildListTile(
                          l10n.share,
                          '',
                          Icons.share_outlined,
                          () {
                            // TODO: Share app
                          },
                        ),
                        _buildDivider(),
                        _buildListTile(
                          l10n.privacyPolicy,
                          '',
                          Icons.privacy_tip_outlined,
                          () {
                            // TODO: Open privacy policy
                          },
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                  
                  // Reset button
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: OutlinedButton(
                      onPressed: () => _showResetDialog(l10n),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(l10n.resetAllData),
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
  
  Widget _buildProfileTile(String title, String value, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
  
  Widget _buildListTile(String title, String subtitle, IconData icon, VoidCallback? onTap, {bool isPro = false}) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, _) {
        final hasAccess = !isPro || subscriptionProvider.isPro;
        
        return ListTile(
          leading: Icon(icon, color: hasAccess ? Colors.blue : Colors.grey),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: hasAccess ? null : Colors.grey.shade600,
                  ),
                ),
              ),
              if (isPro && !subscriptionProvider.isPro) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.star,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ],
          ),
          subtitle: subtitle.isNotEmpty ? Text(
            subtitle,
            style: TextStyle(
              color: hasAccess ? null : Colors.grey.shade400,
            ),
          ) : null,
          trailing: onTap != null ? Icon(
            Icons.chevron_right,
            color: hasAccess ? null : Colors.grey.shade300,
          ) : null,
          onTap: onTap,
        );
      },
    );
  }
  
  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged, {bool isPro = false}) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, _) {
        final hasAccess = !isPro || subscriptionProvider.isPro;
        
        return SwitchListTile(
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: hasAccess ? null : Colors.grey.shade600,
                  ),
                ),
              ),
              if (isPro && !subscriptionProvider.isPro) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.star,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ],
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: hasAccess ? null : Colors.grey.shade400,
            ),
          ),
          value: value,
          onChanged: hasAccess ? onChanged : (value) => onChanged(false),
          activeThumbColor: Colors.blue,
        );
      },
    );
  }
  
  Widget _buildDivider() {
    return const Divider(height: 1, indent: 16, endIndent: 16);
  }
  
  String _getDietModeText(String mode, AppLocalizations l10n) {
    switch (mode) {
      case 'normal': return l10n.dietModeNormal;
      case 'keto': return l10n.dietModeKeto;
      case 'fasting': return l10n.dietModeFasting;
      default: return mode;
    }
  }
  
  String _getActivityText(String level, AppLocalizations l10n) {
    switch (level) {
      case 'low': return l10n.activityLow;
      case 'medium': return l10n.activityMedium;
      case 'high': return l10n.activityHigh;
      default: return level;
    }
  }
  
  void _showWeightDialog(HydrationProvider provider, UnitsService units, AppLocalizations l10n) {
    double tempWeight = provider.weight;
    double displayWeight = units.toDisplayWeight(tempWeight);
    final weightUnit = units.weightUnit;
    final minWeight = units.isImperial ? 88.0 : 40.0; // 40 kg = 88 lb
    final maxWeight = units.isImperial ? 330.0 : 150.0; // 150 kg = 330 lb
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.changeWeight),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${displayWeight.round()} $weightUnit',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Slider(
                value: displayWeight,
                min: minWeight,
                max: maxWeight,
                divisions: (maxWeight - minWeight).round(),
                onChanged: (value) {
                  setDialogState(() {
                    displayWeight = value;
                    tempWeight = units.toKilograms(value);
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${minWeight.round()} $weightUnit', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  Text('${maxWeight.round()} $weightUnit', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                provider.updateProfile(
                  weight: tempWeight, // Сохраняем всегда в кг
                  dietMode: provider.dietMode,
                  activityLevel: provider.activityLevel,
                );
                Navigator.pop(context);
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showDietDialog(HydrationProvider provider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dietMode),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.dietModeNormal),
              value: 'normal',
              groupValue: provider.dietMode,
              onChanged: (value) {
                provider.updateProfile(
                  weight: provider.weight,
                  dietMode: value!,
                  activityLevel: provider.activityLevel,
                );
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.dietModeKeto),
              value: 'keto',
              groupValue: provider.dietMode,
              onChanged: (value) {
                provider.updateProfile(
                  weight: provider.weight,
                  dietMode: value!,
                  activityLevel: provider.activityLevel,
                );
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.dietModeFasting),
              value: 'fasting',
              groupValue: provider.dietMode,
              onChanged: (value) {
                provider.updateProfile(
                  weight: provider.weight,
                  dietMode: value!,
                  activityLevel: provider.activityLevel,
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showActivityDialog(HydrationProvider provider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.activityLevel),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.activityLow),
              subtitle: Text(l10n.activityLowDesc),
              value: 'low',
              groupValue: provider.activityLevel,
              onChanged: (value) {
                provider.updateProfile(
                  weight: provider.weight,
                  dietMode: provider.dietMode,
                  activityLevel: value!,
                );
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.activityMedium),
              subtitle: Text(l10n.activityMediumDesc),
              value: 'medium',
              groupValue: provider.activityLevel,
              onChanged: (value) {
                provider.updateProfile(
                  weight: provider.weight,
                  dietMode: provider.dietMode,
                  activityLevel: value!,
                );
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.activityHigh),
              subtitle: Text(l10n.activityHighDesc),
              value: 'high',
              groupValue: provider.activityLevel,
              onChanged: (value) {
                provider.updateProfile(
                  weight: provider.weight,
                  dietMode: provider.dietMode,
                  activityLevel: value!,
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showFrequencyDialog(AppLocalizations l10n) {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    final isPro = subscriptionProvider.isPro;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.reminderFrequency),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: (isPro ? [2, 3, 4, 6, 8, 12] : [2, 3, 4]).map((freq) => 
            RadioListTile<int>(
              title: Text(l10n.timesPerDay(freq)),
              subtitle: !isPro && freq > 4 ? const Text('PRO', style: TextStyle(color: Colors.orange)) : null,
              value: freq,
              groupValue: _reminderFrequency,
              onChanged: (freq <= 4 || isPro) ? (value) {
                setState(() {
                  _reminderFrequency = value!;
                });
                _saveSettings();
                Navigator.pop(context);
              } : null,
            ),
          ).toList(),
        ),
      ),
    );
  }
  
  void _showTimePicker(bool isMorning) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(isMorning ? _morningTime.split(':')[0] : _eveningTime.split(':')[0]),
        minute: int.parse(isMorning ? _morningTime.split(':')[1] : _eveningTime.split(':')[1]),
      ),
    );
    
    if (picked != null) {
      final timeString = '${picked.hour.toString().padLeft(2, '0')}:'
                        '${picked.minute.toString().padLeft(2, '0')}';
      setState(() {
        if (isMorning) {
          _morningTime = timeString;
        } else {
          _eveningTime = timeString;
        }
      });
      _saveSettings();
    }
  }
  
  void _showResetDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetDataTitle),
        content: Text(l10n.resetDataMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (mounted) {
                Navigator.pop(context);
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.reset),
          ),
        ],
      ),
    );
  }
}

class _ProFeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;
  
  const _ProFeatureItem({
    required this.icon,
    required this.text,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFFFD700)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}