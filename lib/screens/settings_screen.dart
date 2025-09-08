import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hydracoach/providers/hydration_provider.dart';
import '../l10n/app_localizations.dart';
import '../services/notification_service.dart' as notif;
import '../services/subscription_service.dart';
import '../services/locale_service.dart';
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
  String _units = 'metric';
  String _morningTime = '07:00';
  String _eveningTime = '22:00';
  int _reminderFrequency = 4;
  
  Map<String, dynamic> _notificationStats = {};
  
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
      _units = prefs.getString('units') ?? 'metric';
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
  await prefs.setString('units', _units);
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.settingsTitle,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer3<HydrationProvider, SubscriptionProvider, LocaleService>(
        builder: (context, hydrationProvider, subscriptionProvider, localeService, child) {
          final isPro = subscriptionProvider.isPro;
          
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                
                // Profile
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
                        '${hydrationProvider.weight.toInt()} ${l10n.kg}',
                        Icons.monitor_weight_outlined,
                        () => _showWeightDialog(hydrationProvider, l10n),
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
                
                // Units
                _buildSectionTitle(l10n.unitsSection),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        title: Text(l10n.metricSystem),
                        subtitle: Text(l10n.metricUnits),
                        value: 'metric',
                        groupValue: _units,
                        onChanged: (value) {
                          setState(() {
                            _units = value!;
                          });
                          _saveSettings();
                        },
                      ),
                      _buildDivider(),
                      RadioListTile<String>(
                        title: Text(l10n.imperialSystem),
                        subtitle: Text(l10n.imperialUnits),
                        value: 'imperial',
                        groupValue: _units,
                        onChanged: (value) {
                          setState(() {
                            _units = value!;
                          });
                          _saveSettings();
                        },
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms),
                
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
  
  void _showWeightDialog(HydrationProvider provider, AppLocalizations l10n) {
    double tempWeight = provider.weight;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.changeWeight),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${tempWeight.toInt()} ${l10n.kg}',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Slider(
              value: tempWeight,
              min: 40,
              max: 150,
              divisions: 110,
              onChanged: (value) {
                (context as Element).markNeedsBuild();
                tempWeight = value;
              },
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
                weight: tempWeight,
                dietMode: provider.dietMode,
                activityLevel: provider.activityLevel,
              );
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
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