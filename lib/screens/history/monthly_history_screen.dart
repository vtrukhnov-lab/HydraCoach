import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/hydration_provider.dart';
import '../../models/alcohol_intake.dart';
import '../../services/alcohol_service.dart';
import 'weekly_history_screen.dart';

class MonthlyHistoryScreen extends StatefulWidget {
  const MonthlyHistoryScreen({super.key});

  @override
  State<MonthlyHistoryScreen> createState() => _MonthlyHistoryScreenState();
}

class _MonthlyHistoryScreenState extends State<MonthlyHistoryScreen> {
  Map<String, DailyData> monthlyData = {};
  Map<String, double> alcoholData = {};
  bool isLoadingMonthData = false;

  int soberStreakDays = 0;
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  void initState() {
    super.initState();
    _loadMonthlyData();
  }

  Future<void> _loadMonthlyData() async {
    if (isLoadingMonthData) return;
    setState(() => isLoadingMonthData = true);

    final prefs = await SharedPreferences.getInstance();
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    final alcoholService = Provider.of<AlcoholService>(context, listen: false);

    final Map<String, DailyData> tempData = {};
    final Map<String, double> tempAlcoholData = {};

    final lastDay = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    int currentSoberStreak = 0;
    final now = DateTime.now();

    for (int d = 1; d <= lastDay.day; d++) {
      final date = DateTime(_selectedMonth.year, _selectedMonth.month, d);
      final dateKey = date.toIso8601String().split('T')[0];
      final intakesKey = 'intakes_$dateKey';

      // ----- вода/электролиты -----
      final intakesJson = prefs.getStringList(intakesKey) ?? [];
      int totalWater = 0, totalSodium = 0, totalPotassium = 0, totalMagnesium = 0, coffeeCount = 0;

      for (final raw in intakesJson) {
        final parts = raw.split('|');
        if (parts.length >= 7) {
          final type = parts[2];
          final volume = int.tryParse(parts[3]) ?? 0;
          final s = int.tryParse(parts[4]) ?? 0;
          final k = int.tryParse(parts[5]) ?? 0;
          final mg = int.tryParse(parts[6]) ?? 0;

          if (type == 'water' || type == 'electrolyte' || type == 'broth') totalWater += volume;
          if (type == 'coffee') coffeeCount++;
          totalSodium += s; totalPotassium += k; totalMagnesium += mg;
        }
      }

      final waterPercent = provider.goals.waterOpt > 0
          ? (totalWater / provider.goals.waterOpt * 100).clamp(0, 150).toDouble()
          : 0.0;

      tempData[dateKey] = DailyData(
        date: date,
        water: totalWater,
        sodium: totalSodium,
        potassium: totalPotassium,
        magnesium: totalMagnesium,
        waterPercent: waterPercent,
        coffeeCount: coffeeCount,
        intakeCount: intakesJson.length,
      );

      // ----- алкоголь -----
      final alcoholIntakes = await alcoholService.getIntakesForDate(date);
      double totalSD = 0;
      for (final a in alcoholIntakes) {
        totalSD += a.standardDrinks;
      }
      tempAlcoholData[dateKey] = totalSD;

      if (!date.isAfter(now)) {
        currentSoberStreak = (totalSD == 0) ? currentSoberStreak + 1 : 0;
      }
    }

    setState(() {
      monthlyData = tempData;
      alcoholData = tempAlcoholData;
      soberStreakDays = currentSoberStreak;
      isLoadingMonthData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final alcoholService = Provider.of<AlcoholService>(context);

    if (isLoadingMonthData) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // календарь
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _cardDeco(),
            child: _buildCalendarWithAlcohol(l10n),
          ).animate().fadeIn(),

          const SizedBox(height: 20),

          // статистика алкоголя
          if (!alcoholService.soberModeEnabled)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _cardDeco(),
              child: _buildAlcoholStats(l10n),
            ).animate().fadeIn(delay: 100.ms),

          const SizedBox(height: 20),

          // месячная статистика (вода/активность)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _cardDeco(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.monthStatistics, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                _buildMonthlyStats(l10n),
              ],
            ),
          ).animate().slideY(delay: 300.ms),
        ],
      ),
    );
  }

  // ---------- UI helpers ----------
  BoxDecoration _cardDeco() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      );

  // ---------- Календарь ----------
  Widget _buildCalendarWithAlcohol(AppLocalizations l10n) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final lastDayOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;

    // Используем локализованные дни недели (короткие версии)
    final weekDays = [
      l10n.monday.substring(0, 2),
      l10n.tuesday.substring(0, 2),
      l10n.wednesday.substring(0, 2),
      l10n.thursday.substring(0, 2),
      l10n.friday.substring(0, 2),
      l10n.saturday.substring(0, 2),
      l10n.sunday.substring(0, 2),
    ];

    return Column(
      children: [
        // шапка
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                setState(() => _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1));
                _loadMonthlyData();
              },
            ),
            Column(
              children: [
                Text('${_getMonthName(_selectedMonth.month, l10n)} ${_selectedMonth.year}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (soberStreakDays > 0)
                  Text(
                    l10n.soberDaysRow(soberStreakDays),
                    style: TextStyle(fontSize: 12, color: Colors.green[600], fontWeight: FontWeight.w600),
                  ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: (_selectedMonth.month == now.month && _selectedMonth.year == now.year)
                  ? null
                  : () {
                      setState(() => _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1));
                      _loadMonthlyData();
                    },
            ),
          ],
        ),
        const SizedBox(height: 16),

        // дни недели
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: weekDays
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[600]),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),

        // сетка календаря
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: (firstWeekday - 1) + lastDayOfMonth.day,
          itemBuilder: (context, index) {
            if (index < firstWeekday - 1) return const SizedBox.shrink();

            final day = index - (firstWeekday - 2);
            final date = DateTime(_selectedMonth.year, _selectedMonth.month, day);
            final dateKey = date.toIso8601String().split('T')[0];

            final dayData = monthlyData[dateKey];
            final alcoholSD = alcoholData[dateKey] ?? 0;
            final progress = dayData?.waterPercent ?? 0;

            final alcLevel = _alcoholLevel(alcoholSD); // 0/1/2

            if (date.isAfter(now)) {
              // Будущие даты
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Center(
                  child: Text('$day', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                ),
              );
            }

            // Цвет фона ВСЕГДА от воды
            final bgColor = _getHeatmapColor(progress); 
            final textColor = progress > 70 ? Colors.white : Colors.black87;

            return GestureDetector(
              onTap: () => _showDayDetails(date, dayData, alcoholSD, l10n),
              onLongPress: () => _quickLogAlcohol(date, l10n),
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Число дня по центру
                    Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Индикаторы алкоголя внизу (только если есть и не включен трезвый режим)
                    if (alcLevel > 0 && !Provider.of<AlcoholService>(context, listen: false).soberModeEnabled)
                      Positioned(
                        bottom: 2,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: _alcoholGlyph(alcLevel, color: textColor.withOpacity(0.8), size: 10),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // легенда
        Column(
          children: [
            // Легенда теплокарты воды
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('0%', Colors.grey[200]!),
                _buildLegendItem('1-50%', Colors.red[200]!),
                _buildLegendItem('51-80%', Colors.orange[300]!),
                _buildLegendItem('81-99%', Colors.blue[400]!),
                _buildLegendItem('100%+', Colors.green[500]!),
              ],
            ),
            // Легенда алкоголя (только если не включен трезвый режим)
            if (!Provider.of<AlcoholService>(context, listen: false).soberModeEnabled) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_bar, size: 14, color: Colors.grey[700]),
                  const SizedBox(width: 4),
                  const Text('1–2 SD', style: TextStyle(fontSize: 10)),
                  const SizedBox(width: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_bar, size: 14, color: Colors.grey[700]),
                      const SizedBox(width: 1),
                      Icon(Icons.local_bar, size: 14, color: Colors.grey[700]),
                    ],
                  ),
                  const SizedBox(width: 4),
                  const Text('>2 SD', style: TextStyle(fontSize: 10)),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }

  // ---------- Статистика алкоголя ----------
  Widget _buildAlcoholStats(AppLocalizations l10n) {
    double totalSD = 0;
    int daysWithAlcohol = 0;
    int soberDays = 0;

    for (final sd in alcoholData.values) {
      totalSD += sd;
      if (sd > 0) {
        daysWithAlcohol++;
      } else {
        soberDays++;
      }
    }
    final avgSD = daysWithAlcohol > 0 ? totalSD / daysWithAlcohol : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.alcoholStatistics, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildStatCard(l10n.totalSD, totalSD.toStringAsFixed(1), Colors.orange, l10n.forMonth)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard(l10n.daysWithAlcohol, '$daysWithAlcohol', Colors.red, l10n.fromDays(alcoholData.length))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatCard(l10n.soberDays, '$soberDays', Colors.green, l10n.excellent)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard(l10n.averageSD, avgSD.toStringAsFixed(1), Colors.purple, l10n.inDrinkingDays)),
          ],
        ),
        if (soberStreakDays > 0) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.local_fire_department, color: Colors.green[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.currentStreak(soberStreakDays),
                          style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold)),
                      Text(l10n.keepItUp,
                          style: TextStyle(color: Colors.green[600], fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ---------- Прочее ----------
  Widget _buildStatCard(String title, String value, MaterialColor color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color[700], fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color[800], fontSize: 24, fontWeight: FontWeight.bold)),
          Text(subtitle, style: TextStyle(color: color[600], fontSize: 11)),
        ],
      ),
    );
  }

  void _showDayDetails(DateTime date, DailyData? data, double alcoholSD, AppLocalizations l10n) {
    final alcoholService = Provider.of<AlcoholService>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return FutureBuilder<List<AlcoholIntake>>(
          future: alcoholService.getIntakesForDate(date),
          builder: (context, snapshot) {
            final alcoholIntakes = snapshot.data ?? [];

            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('${date.day} ${_getMonthName(date.month, l10n)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  if (data != null) ...[
                    Row(
                      children: [
                        Icon(Icons.water_drop, color: Colors.blue[600]),
                        const SizedBox(width: 8),
                        Text(l10n.waterAmount(data.water, data.waterPercent.toInt())),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.bolt, color: Colors.orange[600]),
                        const SizedBox(width: 8),
                        Text('Na: ${data.sodium} ${l10n.mg}, K: ${data.potassium} ${l10n.mg}'),
                      ],
                    ),
                  ],
                  if (alcoholSD > 0 && !alcoholService.soberModeEnabled) ...[
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.local_bar, color: Colors.orange[600]),
                        const SizedBox(width: 8),
                        Text(l10n.alcoholAmount(alcoholSD.toStringAsFixed(1)),
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...alcoholIntakes.map(
                      (intake) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Text(intake.formattedTime, style: TextStyle(color: Colors.grey[600])),
                            const SizedBox(width: 8),
                            Icon(intake.type.icon, size: 16, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text('${intake.type.getLabel(context)}: '),  // ИСПРАВЛЕНО: используем getLabel(context)
                            Text('${intake.volumeMl.toInt()} ${l10n.ml}, ${intake.abv}%',
                                style: const TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _quickLogAlcohol(DateTime date, AppLocalizations l10n) {
    // Заменить на локализованный текст
    // Это может быть в отдельном ключе локализации или использовать существующий
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quick alcohol add will be available in PRO'), duration: Duration(seconds: 2)),
    );
  }

  bool _hasAlcoholData() => alcoholData.values.any((sd) => sd > 0);

  Widget _buildMonthlyStats(AppLocalizations l10n) {
    int totalWater = 0;
    int totalSodium = 0;
    int activeDays = 0;
    int perfectDays = 0;

    for (final d in monthlyData.values) {
      if (d.water > 0) activeDays++;
      if (d.waterPercent >= 100) perfectDays++;
      totalWater += d.water;
      totalSodium += d.sodium;
    }

    final avgWater = activeDays > 0 ? totalWater ~/ activeDays : 0;

    return Column(
      children: [
        _buildMonthStatRow(
          icon: '💧',
          label: l10n.totalVolume,
          value: '${(totalWater / 1000).toStringAsFixed(1)} L',
          subValue: l10n.averagePerDay(avgWater),
          color: Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildMonthStatRow(
          icon: '📅',
          label: l10n.activeDays,
          value: '$activeDays ${l10n.fromDays(monthlyData.length)}',
          subValue: l10n.perfectDays(perfectDays),
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildMonthStatRow({
    required String icon,
    required String label,
    required String value,
    required String subValue,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(icon, style: const TextStyle(fontSize: 24))),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text(subValue, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  String _getMonthName(int month, AppLocalizations l10n) {
    switch (month) {
      case 1: return l10n.january;
      case 2: return l10n.february;
      case 3: return l10n.march;
      case 4: return l10n.april;
      case 5: return l10n.may;
      case 6: return l10n.june;
      case 7: return l10n.july;
      case 8: return l10n.august;
      case 9: return l10n.september;
      case 10: return l10n.october;
      case 11: return l10n.november;
      case 12: return l10n.december;
      default: return '';
    }
  }

  Color _getHeatmapColor(double progress) {
    if (progress == 0) return Colors.grey[200]!;
    if (progress < 50) return Colors.red[200]!;
    if (progress < 80) return Colors.orange[300]!;
    if (progress < 100) return Colors.blue[400]!;
    return Colors.green[500]!;
  }

  /// 0 — нет, 1 — 1–2 SD, 2 — >2 SD
  int _alcoholLevel(double sd) {
    if (sd <= 0) return 0;
    return sd > 2 ? 2 : 1;
  }

  /// Иконка(и) бокала — один или два
  Widget _alcoholGlyph(int count, {required Color color, double size = 14}) {
    final icon = Icons.local_bar;
    if (count <= 1) {
      return Icon(icon, size: size, color: color);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: size, color: color),
        const SizedBox(width: 1),
        Icon(icon, size: size, color: color),
      ],
    );
  }
}