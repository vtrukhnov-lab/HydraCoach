import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../l10n/app_localizations.dart';
import '../services/notification_service.dart' as notif;

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  Map<String, dynamic> _notificationStats = {};
  bool _testNotificationScheduled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationStats();
  }

  Future<void> _loadNotificationStats() async {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Настройки уведомлений',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(duration: 350.ms),
                    const SizedBox(height: 4),
                    Text(
                      kDebugMode ? 'Debug режим' : 'Настройте под себя',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Основной контент
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Заголовок секции
                    Row(
                      children: [
                        Icon(
                          kDebugMode ? Icons.bug_report : Icons.notifications,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          kDebugMode ? 'Тестирование уведомлений' : 'Управление уведомлениями',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Статистика
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Статус: ${_notificationStats['is_pro'] == true ? "PRO" : "FREE"}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  'Отправлено сегодня: ${_notificationStats['today_count'] ?? 0}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: theme.colorScheme.primary.withOpacity(0.8),
                                  ),
                                ),
                                if (_notificationStats['is_pro'] != true)
                                  Text(
                                    'Лимит: 4 в день',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: theme.colorScheme.primary.withOpacity(0.8),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    const Divider(),
                    
                    // Кнопки управления
                    _buildActionTile(
                      icon: Icons.send,
                      iconColor: Colors.green,
                      title: 'Отправить тестовое',
                      subtitle: 'Мгновенное уведомление',
                      onTap: _sendTestNotification,
                    ),
                    
                    const Divider(height: 1),
                    
                    _buildActionTile(
                      icon: Icons.schedule,
                      iconColor: Colors.blue,
                      title: 'Запланировать тест',
                      subtitle: _testNotificationScheduled 
                        ? 'Запланировано ⏰' 
                        : 'Придёт через 1 минуту',
                      onTap: _testNotificationScheduled ? null : _scheduleTestNotification,
                    ),
                    
                    const Divider(height: 1),
                    
                    _buildActionTile(
                      icon: Icons.list_alt,
                      iconColor: Colors.purple,
                      title: 'Показать статус',
                      subtitle: 'Запланированные уведомления',
                      onTap: _showNotificationStatus,
                    ),
                    
                    const Divider(height: 1),
                    
                    _buildActionTile(
                      icon: Icons.cancel_outlined,
                      iconColor: Colors.orange,
                      title: 'Отменить все',
                      subtitle: 'Очистить запланированные',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Отменить все?'),
                            content: const Text('Это отменит все запланированные уведомления.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Нет'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _cancelAllNotifications();
                                },
                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                child: const Text('Да, отменить'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    
                    if (kDebugMode) ...[
                      const Divider(height: 1),
                      _buildActionTile(
                        icon: _notificationStats['is_pro'] == true ? Icons.star : Icons.star_outline,
                        iconColor: Colors.amber,
                        title: 'Переключить PRO статус',
                        subtitle: 'Текущий: ${_notificationStats['is_pro'] == true ? "PRO" : "FREE"}',
                        onTap: _toggleProStatus,
                      ),
                    ],
                  ],
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
              
              // Информационная панель
              if (kDebugMode)
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.yellow.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 20),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Debug функции видны только в режиме разработки',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms),
              
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildActionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}