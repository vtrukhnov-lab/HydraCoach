import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../main.dart';
import '../services/notification_service.dart' as notif;
import '../services/subscription_service.dart';
import '../widgets/pro_badge.dart';
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
  bool _postAlcoholReminders = false; // Новое
  String _units = 'metric';
  String _morningTime = '07:00';
  String _eveningTime = '22:00';
  int _reminderFrequency = 4;
  
  // Статистика уведомлений
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
    final stats = await notif.NotificationService().getNotificationStats();
    setState(() {
      _notificationStats = stats;
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
    
    // Обновляем настройки уведомлений
    await notif.NotificationService().saveSettings(
      notif.ReminderSettings(
        enabled: _notificationsEnabled,
        frequency: _reminderFrequency,
        morningTime: _morningTime,
        eveningTime: _eveningTime,
        postCoffee: _postCoffeeReminders,
        heatWarnings: _heatWarnings,
        postAlcohol: _postAlcoholReminders,
      ),
    );
    
    // Обновляем статистику
    await _loadNotificationStats();
  }
  
  void _showPaywall() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(showCloseButton: true),
        fullscreenDialog: true,
      ),
    ).then((_) {
      // После закрытия пейвола обновляем статистику
      _loadNotificationStats();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Настройки',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer2<HydrationProvider, SubscriptionProvider>(
        builder: (context, hydrationProvider, subscriptionProvider, child) {
          final isPro = subscriptionProvider.isPro;
          
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Профиль
                _buildSectionTitle('Профиль'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildProfileTile(
                        'Вес',
                        '${hydrationProvider.weight.toInt()} кг',
                        Icons.monitor_weight_outlined,
                        () => _showWeightDialog(hydrationProvider),
                      ),
                      _buildDivider(),
                      _buildProfileTile(
                        'Режим питания',
                        _getDietModeText(hydrationProvider.dietMode),
                        Icons.restaurant_menu,
                        () => _showDietDialog(hydrationProvider),
                      ),
                      _buildDivider(),
                      _buildProfileTile(
                        'Активность',
                        _getActivityText(hydrationProvider.activityLevel),
                        Icons.fitness_center,
                        () => _showActivityDialog(hydrationProvider),
                      ),
                    ],
                  ),
                ).animate().fadeIn(),
                
                // Уведомления
                _buildSectionTitle('Уведомления'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Счетчик уведомлений для FREE
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
                                      'Лимит уведомлений (FREE)',
                                      style: TextStyle(
                                        color: Colors.blue.shade900,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Использовано: ${_notificationStats['today_count'] ?? 0} из 4',
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
                        'Напоминания о воде',
                        'Регулярные напоминания в течение дня',
                        _notificationsEnabled,
                        (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                          _saveSettings();
                        },
                        isPro: false, // Доступно всем
                      ),
                      
                      if (_notificationsEnabled) ...[
                        _buildDivider(),
                        _buildListTile(
                          'Частота напоминаний',
                          isPro ? 'Без ограничений' : '$_reminderFrequency раз в день (макс 4)',
                          Icons.access_time,
                          () => isPro ? _showFrequencyDialog() : _showPaywall(),
                          isPro: !isPro, // Показываем звездочку для FREE
                        ),
                        _buildDivider(),
                        _buildListTile(
                          'Начало дня',
                          _morningTime,
                          Icons.wb_sunny_outlined,
                          () => _showTimePicker(true),
                          isPro: false,
                        ),
                        _buildDivider(),
                        _buildListTile(
                          'Конец дня',
                          _eveningTime,
                          Icons.nightlight_outlined,
                          () => _showTimePicker(false),
                          isPro: false,
                        ),
                      ],
                      
                      _buildDivider(),
                      _buildSwitchTile(
                        'Напоминания после кофе',
                        'Напомнить выпить воду через 20 минут',
                        _postCoffeeReminders && isPro,
                        isPro ? (value) {
                          setState(() {
                            _postCoffeeReminders = value;
                          });
                          _saveSettings();
                        } : (value) => _showPaywall(),
                        isPro: true, // PRO функция
                      ),
                      
                      _buildDivider(),
                      _buildSwitchTile(
                        'Предупреждения о жаре',
                        'Уведомления при высокой температуре',
                        _heatWarnings && isPro,
                        isPro ? (value) {
                          setState(() {
                            _heatWarnings = value;
                          });
                          _saveSettings();
                        } : (value) => _showPaywall(),
                        isPro: true, // PRO функция
                      ),
                      
                      _buildDivider(),
                      _buildSwitchTile(
                        'Напоминания после алкоголя',
                        'План восстановления на 6-12 часов',
                        _postAlcoholReminders && isPro,
                        isPro ? (value) {
                          setState(() {
                            _postAlcoholReminders = value;
                          });
                          _saveSettings();
                        } : (value) => _showPaywall(),
                        isPro: true, // PRO функция
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 100.ms),
                
                // PRO функции (если пользователь FREE)
                if (!isPro) ...[
                  _buildSectionTitle('PRO возможности'),
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
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Разблокировать PRO',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Безлимитные уведомления и умные напоминания',
                                        style: TextStyle(
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
                            const Column(
                              children: [
                                _ProFeatureItem(icon: Icons.all_inclusive, text: 'Без лимита уведомлений'),
                                _ProFeatureItem(icon: Icons.coffee, text: 'Напоминания после кофе'),
                                _ProFeatureItem(icon: Icons.wb_sunny, text: 'Предупреждения о жаре'),
                                _ProFeatureItem(icon: Icons.local_bar, text: 'Восстановление после алкоголя'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 150.ms),
                ],
                
                // Единицы измерения
                _buildSectionTitle('Единицы измерения'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('Метрическая система'),
                        subtitle: const Text('мл, кг, °C'),
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
                        title: const Text('Имперская система'),
                        subtitle: const Text('oz, lb, °F'),
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
                
                // О приложении
                _buildSectionTitle('О приложении'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildListTile(
                        'Версия',
                        '0.3.0',
                        Icons.info_outline,
                        null,
                      ),
                      _buildDivider(),
                      _buildListTile(
                        'Оценить приложение',
                        '',
                        Icons.star_outline,
                        () {
                          // TODO: Открыть страницу в App Store / Google Play
                        },
                      ),
                      _buildDivider(),
                      _buildListTile(
                        'Поделиться',
                        '',
                        Icons.share_outlined,
                        () {
                          // TODO: Поделиться приложением
                        },
                      ),
                      _buildDivider(),
                      _buildListTile(
                        'Политика конфиденциальности',
                        '',
                        Icons.privacy_tip_outlined,
                        () {
                          // TODO: Открыть политику
                        },
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms),
                
                // Кнопка сброса
                Container(
                  margin: const EdgeInsets.all(20),
                  child: OutlinedButton(
                    onPressed: () => _showResetDialog(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Сбросить все данные'),
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
  
  String _getDietModeText(String mode) {
    switch (mode) {
      case 'normal': return 'Обычное питание';
      case 'keto': return 'Кето / Низкоуглеводное';
      case 'fasting': return 'Интервальное голодание';
      default: return mode;
    }
  }
  
  String _getActivityText(String level) {
    switch (level) {
      case 'low': return 'Низкая активность';
      case 'medium': return 'Средняя активность';
      case 'high': return 'Высокая активность';
      default: return level;
    }
  }
  
  void _showWeightDialog(HydrationProvider provider) {
    double tempWeight = provider.weight;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменить вес'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${tempWeight.toInt()} кг',
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
            child: const Text('Отмена'),
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
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
  
  void _showDietDialog(HydrationProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Режим питания'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Обычное питание'),
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
              title: const Text('Кето / Низкоуглеводное'),
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
              title: const Text('Интервальное голодание'),
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
  
  void _showActivityDialog(HydrationProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Уровень активности'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Низкая'),
              subtitle: const Text('Офисная работа, мало движения'),
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
              title: const Text('Средняя'),
              subtitle: const Text('30-60 минут упражнений в день'),
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
              title: const Text('Высокая'),
              subtitle: const Text('Тренировки >1 часа'),
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
  
  void _showFrequencyDialog() {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    final isPro = subscriptionProvider.isPro;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Частота напоминаний'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: (isPro ? [2, 3, 4, 6, 8, 12] : [2, 3, 4]).map((freq) => 
            RadioListTile<int>(
              title: Text('$freq раз в день'),
              subtitle: !isPro && freq > 4 ? const Text('PRO', style: TextStyle(color: Colors.orange)) : null,
              value: freq,
              groupValue: _reminderFrequency,
              onChanged: (freq! <= 4 || isPro) ? (value) {
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
  
  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сбросить все данные?'),
        content: const Text(
          'Это действие удалит всю историю и вернет настройки к значениям по умолчанию.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
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
            child: const Text('Сбросить'),
          ),
        ],
      ),
    );
  }
}

// Вспомогательный виджет для PRO функций
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