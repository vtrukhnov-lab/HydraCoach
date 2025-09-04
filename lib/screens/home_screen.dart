import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

// App imports
import '../main.dart';
import '../services/subscription_service.dart';
import '../services/remote_config_service.dart';
import '../services/alcohol_service.dart';
import '../services/notification_service.dart' as notif;
import '../widgets/weather_card.dart';
import '../widgets/daily_report.dart';
import '../widgets/alcohol_card.dart';
import '../widgets/alcohol_checkin_dialog.dart';
import 'paywall_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showDailyReport = false;
  
  @override
  void initState() {
    super.initState();
    _checkDailyReport();
    _checkMorningCheckin();
  }
  
  void _checkDailyReport() {
    final now = DateTime.now();
    if (now.hour >= 21) {
      setState(() {
        _showDailyReport = true;
      });
    }
  }
  
  void _checkMorningCheckin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      AlcoholCheckinDialog.show(context);
    }
  }
    
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HydrationProvider>(context);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final alcoholService = Provider.of<AlcoholService>(context);
    
    provider.updateAlcoholAdjustments(
      alcoholService.totalWaterCorrection,
      alcoholService.totalSodiumCorrection.round(),
    );
    
    final progress = provider.getProgress();
    final status = provider.getHydrationStatus();
    final hri = provider.getHRI(alcoholService);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Заголовок с PRO индикатором
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'HydraCoach',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ).animate().fadeIn(duration: 500.ms),
                                if (subscriptionProvider.isPro) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.amber.shade400, Colors.amber.shade600],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'PRO',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getFormattedDate(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if (!subscriptionProvider.isPro)
                              IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.purple.shade400, Colors.purple.shade600],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.star, color: Colors.white, size: 20),
                                ),
                                onPressed: () {
                                  _showPaywall(context);
                                },
                                tooltip: 'Получить PRO',
                              ),
                            IconButton(
                              icon: const Icon(Icons.history),
                              onPressed: () {
                                Navigator.pushNamed(context, '/history');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings),
                              onPressed: () {
                                Navigator.pushNamed(context, '/settings');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Карточка погоды
                SliverToBoxAdapter(
                  child: WeatherCard(
                    onWeatherUpdate: (waterAdjustment, sodiumAdjustment) {
                      provider.updateWeatherAdjustments(
                        waterAdjustment, 
                        sodiumAdjustment
                      );
                    },
                  ),
                ),
                
                // Индикатор алкоголя
                const SliverToBoxAdapter(
                  child: AlcoholIndicator(),
                ),
                
                // Кольца прогресса
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildProgressRing(
                              'Вода',
                              progress['waterPercent']!,
                              Colors.blue,
                              '${progress['water']!.toInt()}',
                              '${provider.goals.waterOpt} мл',
                            ).animate().scale(delay: 100.ms),
                            _buildProgressRing(
                              'Na',
                              progress['sodiumPercent']!,
                              Colors.orange,
                              '${progress['sodium']!.toInt()}',
                              '${provider.goals.sodium} мг',
                            ).animate().scale(delay: 200.ms),
                            _buildProgressRing(
                              'K',
                              progress['potassiumPercent']!,
                              Colors.purple,
                              '${progress['potassium']!.toInt()}',
                              '${provider.goals.potassium} мг',
                            ).animate().scale(delay: 300.ms),
                          ],
                        ),
                        // Показываем корректировки
                        if (provider.weatherWaterAdjustment > 0 || alcoholService.totalStandardDrinks > 0) ...[
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            children: [
                              if (provider.weatherWaterAdjustment > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.wb_sunny,
                                        size: 16,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Жара +${(provider.weatherWaterAdjustment * 100).toInt()}%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.orange.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (alcoholService.totalStandardDrinks > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.local_bar,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Алкоголь +${alcoholService.totalWaterCorrection.toInt()} мл',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.red.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                // Магний индикатор
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Text('Магний (Mg):'),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress['magnesiumPercent']! / 100,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation(Colors.pink),
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${progress['magnesium']!.toInt()}/${provider.goals.magnesium} мг',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                ),
                
                // Карточка минимум вреда (если пил алкоголь)
                const SliverToBoxAdapter(
                  child: AlcoholCard(),
                ),
                
                // Статус карточка
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Статус гидратации',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(status),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                status,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('Hydration Risk Index'),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: hri / 100,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation(_getHRIColor(hri)),
                            minHeight: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '$hri',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _getHRIColor(hri),
                              ),
                            ),
                            // Показываем влияние алкоголя на HRI
                            if (alcoholService.totalStandardDrinks > 0) ...[
                              const SizedBox(width: 8),
                              Text(
                                '(+${alcoholService.totalHRIModifier.round()} от алкоголя)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red.shade600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                ),
                
                // Быстрые кнопки с алкоголем
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Быстрое добавление',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.1,
                          children: [
                            _buildQuickButton(
                              context,
                              '💧',
                              'Вода',
                              '200 мл',
                              Colors.blue,
                              () => provider.addIntake('water', 200),
                            ),
                            _buildQuickButton(
                              context,
                              '💧',
                              'Вода',
                              '300 мл',
                              Colors.blue,
                              () => provider.addIntake('water', 300),
                            ),
                            _buildQuickButton(
                              context,
                              '💧',
                              'Вода',
                              '500 мл',
                              Colors.blue,
                              () => provider.addIntake('water', 500),
                            ),
                            _buildQuickButton(
                              context,
                              '⚡',
                              'Электролит',
                              '300 мл',
                              Colors.orange,
                              () => provider.addIntake('electrolyte', 300,
                                sodium: 500, potassium: 200, magnesium: 50),
                            ),
                            _buildQuickButton(
                              context,
                              '🍲',
                              'Бульон',
                              '250 мл',
                              Colors.amber,
                              () => provider.addIntake('broth', 250,
                                sodium: 800, potassium: 100),
                            ),
                            _buildQuickButton(
                              context,
                              '☕',
                              'Кофе',
                              '200 мл',
                              Colors.brown,
                              () => provider.addIntake('coffee', 200),
                            ),
                            // Кнопка алкоголя
                            if (!alcoholService.soberModeEnabled)
                              _buildQuickButton(
                                context,
                                '🍺',
                                'Алкоголь',
                                'Добавить',
                                Colors.orange.shade600,
                                () async {
                                  final result = await Navigator.pushNamed(context, '/alcohol');
                                  if (result == true) {
                                    setState(() {});
                                  }
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // История приемов
                if (provider.todayIntakes.isNotEmpty || alcoholService.todayIntakes.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Сегодня выпито',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/history');
                                },
                                child: const Text('Все записи →'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                ...provider.todayIntakes
                                    .take(5)
                                    .toList()
                                    .reversed
                                    .map((intake) => _buildIntakeItem(intake, provider)),
                                // Показываем алкогольные приемы
                                ...alcoholService.todayIntakes
                                    .map((intake) => _buildAlcoholItem(intake, alcoholService)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
            
            // Плавающий отчет (показывается вечером)
            if (_showDailyReport)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => DraggableScrollableSheet(
                        initialChildSize: 0.9,
                        minChildSize: 0.5,
                        maxChildSize: 0.95,
                        builder: (context, scrollController) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: const DailyReportCard(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade800],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.analytics,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Дневной отчет готов!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Посмотрите результаты дня',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ).animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 1, end: 0),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAlcoholItem(intake, AlcoholService alcoholService) {
    return Dismissible(
      key: Key(intake.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: const BoxDecoration(
          color: Colors.red,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        alcoholService.removeIntake(intake.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${intake.type.label} удален'),
            action: SnackBarAction(
              label: 'Отменить',
              onPressed: () {
                alcoholService.addIntake(intake);
              },
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          border: Border(
            bottom: BorderSide(color: Colors.orange.shade200),
          ),
        ),
        child: Row(
          children: [
            Text(
              intake.formattedTime,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Icon(intake.type.icon, color: Colors.orange.shade600, size: 20),
            const SizedBox(width: 8),
            Text(intake.type.label),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${intake.volumeMl.toInt()} мл, ${intake.abv}%',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  intake.formattedSD,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showPaywall(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(),
        fullscreenDialog: true,
      ),
    );
  }
  
  Widget _buildProgressRing(String label, double percent, Color color, String current, String goal) {
    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: percent / 100,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${percent.toInt()}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          current,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        Text(
          goal,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
  
Widget _buildQuickButton(BuildContext context, String icon, String label, 
      String volume, Color color, VoidCallback onPress) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPress,
        borderRadius: BorderRadius.circular(16),
        splashColor: color.withOpacity(0.2),
        highlightColor: color.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color, width: 2),
          ),
          child: Stack(
            children: [
              // Контент кнопки
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(icon, style: const TextStyle(fontSize: 28)),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      volume,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate()
      .scale(
        begin: const Offset(0.95, 0.95),
        end: const Offset(1, 1),
        duration: 200.ms,
        curve: Curves.easeOutBack,
      )
      .fadeIn(duration: 300.ms, delay: 100.ms);
  }
  
  Widget _buildIntakeItem(Intake intake, HydrationProvider provider) {
    String typeIcon = '';
    String typeName = '';
    
    switch (intake.type) {
      case 'water':
        typeIcon = '💧';
        typeName = 'Вода';
        break;
      case 'electrolyte':
        typeIcon = '⚡';
        typeName = 'Электролит';
        break;
      case 'broth':
        typeIcon = '🍲';
        typeName = 'Бульон';
        break;
      case 'coffee':
        typeIcon = '☕';
        typeName = 'Кофе';
        break;
    }
    
    return Dismissible(
      key: Key(intake.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: const BoxDecoration(
          color: Colors.red,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        provider.removeIntake(intake.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$typeName удален'),
            action: SnackBarAction(
              label: 'Отменить',
              onPressed: () {
                provider.addIntake(
                  intake.type,
                  intake.volume,
                  sodium: intake.sodium,
                  potassium: intake.potassium,
                  magnesium: intake.magnesium,
                );
              },
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            Text(
              '${intake.timestamp.hour.toString().padLeft(2, '0')}:${intake.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Text('$typeIcon $typeName'),
            const Spacer(),
            Text(
              '${intake.volume} мл',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Норма':
        return Colors.green;
      case 'Мало соли':
      case 'Разбавляешь':
        return Colors.orange;
      case 'Недобор воды':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  Color _getHRIColor(int hri) {
    if (hri < 30) return Colors.green;
    if (hri < 60) return Colors.orange;
    return Colors.red;
  }
  
  String _getFormattedDate() {
    final now = DateTime.now();
    const months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
                   'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
    const weekDays = ['Воскресенье', 'Понедельник', 'Вторник', 'Среда',
                     'Четверг', 'Пятница', 'Суббота'];
    
    return '${weekDays[now.weekday % 7]}, ${now.day} ${months[now.month - 1]}';
  }
}