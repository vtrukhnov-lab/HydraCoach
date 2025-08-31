import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../main.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _postCoffeeReminders = true;
  bool _heatWarnings = true;
  String _units = 'metric'; // metric или imperial
  String _morningTime = '07:00';
  String _eveningTime = '22:00';
  int _reminderFrequency = 4;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _postCoffeeReminders = prefs.getBool('postCoffeeReminders') ?? true;
      _heatWarnings = prefs.getBool('heatWarnings') ?? true;
      _units = prefs.getString('units') ?? 'metric';
      _morningTime = prefs.getString('morningTime') ?? '07:00';
      _eveningTime = prefs.getString('eveningTime') ?? '22:00';
      _reminderFrequency = prefs.getInt('reminderFrequency') ?? 4;
    });
  }
  
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setBool('postCoffeeReminders', _postCoffeeReminders);
    await prefs.setBool('heatWarnings', _heatWarnings);
    await prefs.setString('units', _units);
    await prefs.setString('morningTime', _morningTime);
    await prefs.setString('eveningTime', _eveningTime);
    await prefs.setInt('reminderFrequency', _reminderFrequency);
    
    // Обновляем настройки уведомлений
    await NotificationService.saveSettings(
      ReminderSettings(
        enabled: _notificationsEnabled,
        frequency: _reminderFrequency,
        morningTime: _morningTime,
        eveningTime: _eveningTime,
        postCoffee: _postCoffeeReminders,
        heatWarnings: _heatWarnings,
      ),
    );
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
      body: Consumer<HydrationProvider>(
        builder: (context, provider, child) {
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
                        '${provider.weight.toInt()} кг',
                        Icons.monitor_weight_outlined,
                        () => _showWeightDialog(provider),
                      ),
                      _buildDivider(),
                      _buildProfileTile(
                        'Режим питания',
                        _getDietModeText(provider.dietMode),
                        Icons.restaurant_menu,
                        () => _showDietDialog(provider),
                      ),
                      _buildDivider(),
                      _buildProfileTile(
                        'Активность',
                        _getActivityText(provider.activityLevel),
                        Icons.fitness_center,
                        () => _showActivityDialog(provider),
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
                      ),
                      if (_notificationsEnabled) ...[
                        _buildDivider(),
                        _buildListTile(
                          'Частота напоминаний',
                          '$_reminderFrequency раз в день',
                          Icons.access_time,
                          () => _showFrequencyDialog(),
                        ),
                        _buildDivider(),
                        _buildListTile(
                          'Начало дня',
                          _morningTime,
                          Icons.wb_sunny_outlined,
                          () => _showTimePicker(true),
                        ),
                        _buildDivider(),
                        _buildListTile(
                          'Конец дня',
                          _eveningTime,
                          Icons.nightlight_outlined,
                          () => _showTimePicker(false),
                        ),
                      ],
                      _buildDivider(),
                      _buildSwitchTile(
                        'Напоминания после кофе',
                        'Напомнить выпить воду через 20 минут',
                        _postCoffeeReminders,
                        (value) {
                          setState(() {
                            _postCoffeeReminders = value;
                          });
                          _saveSettings();
                        },
                      ),
                      _buildDivider(),
                      _buildSwitchTile(
                        'Предупреждения о жаре',
                        'Уведомления при высокой температуре',
                        _heatWarnings,
                        (value) {
                          setState(() {
                            _heatWarnings = value;
                          });
                          _saveSettings();
                        },
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 100.ms),
                
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
                        '1.0.0',
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
  
  Widget _buildListTile(String title, String subtitle, IconData icon, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }
  
  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue,
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Частота напоминаний'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [2, 3, 4, 6, 8].map((freq) => 
            RadioListTile<int>(
              title: Text('$freq раз в день'),
              value: freq,
              groupValue: _reminderFrequency,
              onChanged: (value) {
                setState(() {
                  _reminderFrequency = value!;
                });
                _saveSettings();
                Navigator.pop(context);
              },
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