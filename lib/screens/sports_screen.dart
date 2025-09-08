// ============================================================================
// FILE: lib/screens/sports_screen.dart
// 
// PURPOSE: Sports Activity Screen for tracking workouts and calculating water needs
// Allows users to log various sports activities and calculates additional hydration.
// Uses the same UI/UX pattern as other screens for consistency.
// 
// FEATURES:
// - Grid of sport types (3 FREE, 9 PRO)
// - Duration input in minutes
// - Water calculation based on intensity and user weight
// - Automatic water and electrolyte adjustment
// - PRO gating for premium activities
// - Teal color scheme
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/subscription_service.dart';
import '../screens/paywall_screen.dart';
import '../main.dart';

class SportsScreen extends StatefulWidget {
  const SportsScreen({super.key});

  @override
  State<SportsScreen> createState() => _SportsScreenState();
}

class _SportsScreenState extends State<SportsScreen> {
  List<Map<String, dynamic>> _sportTypes = [];
  int _selectedIndex = 0;
  final TextEditingController _durationController = TextEditingController(text: '30');
  bool _isPro = false;
  double _userWeight = 70; // кг

  @override
  void initState() {
    super.initState();
    _loadUserWeight();
    _checkForPreselectedValues();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeSportTypes();
  }
  
  void _initializeSportTypes() {
    final l10n = AppLocalizations.of(context);
    
    _sportTypes = [
      // FREE типы
      {
        'type': 'walking',
        'label': l10n.walking ?? 'Walking',
        'icon': Icons.directions_walk,
        'intensity': 'low', // низкая интенсивность
        'mlPerKgPerHour': 12, // мл на кг веса в час
        'sodiumMgPerHour': 200, // мг натрия в час
        'isPro': false
      },
      {
        'type': 'running',
        'label': l10n.running ?? 'Running',
        'icon': Icons.directions_run,
        'intensity': 'medium',
        'mlPerKgPerHour': 17,
        'sodiumMgPerHour': 400,
        'isPro': false
      },
      {
        'type': 'gym',
        'label': l10n.gym ?? 'Gym',
        'icon': Icons.fitness_center,
        'intensity': 'high',
        'mlPerKgPerHour': 24,
        'sodiumMgPerHour': 600,
        'isPro': false
      },
      // PRO типы
      {
        'type': 'cycling',
        'label': l10n.cycling ?? 'Cycling',
        'icon': Icons.directions_bike,
        'intensity': 'medium',
        'mlPerKgPerHour': 16,
        'sodiumMgPerHour': 350,
        'isPro': true
      },
      {
        'type': 'swimming',
        'label': l10n.swimming ?? 'Swimming',
        'icon': Icons.pool,
        'intensity': 'high',
        'mlPerKgPerHour': 20,
        'sodiumMgPerHour': 300, // меньше натрия, т.к. нет потоотделения
        'isPro': true
      },
      {
        'type': 'yoga',
        'label': l10n.yoga ?? 'Yoga',
        'icon': Icons.self_improvement,
        'intensity': 'low',
        'mlPerKgPerHour': 10,
        'sodiumMgPerHour': 150,
        'isPro': true
      },
      {
        'type': 'hiit',
        'label': l10n.hiit ?? 'HIIT',
        'icon': Icons.flash_on,
        'intensity': 'high',
        'mlPerKgPerHour': 30,
        'sodiumMgPerHour': 800,
        'isPro': true
      },
      {
        'type': 'crossfit',
        'label': l10n.crossfit ?? 'CrossFit',
        'icon': Icons.sports_mma,
        'intensity': 'high',
        'mlPerKgPerHour': 28,
        'sodiumMgPerHour': 700,
        'isPro': true
      },
      {
        'type': 'boxing',
        'label': l10n.boxing ?? 'Boxing',
        'icon': Icons.sports_kabaddi,
        'intensity': 'high',
        'mlPerKgPerHour': 25,
        'sodiumMgPerHour': 650,
        'isPro': true
      },
      {
        'type': 'dancing',
        'label': l10n.dancing ?? 'Dancing',
        'icon': Icons.music_note,
        'intensity': 'medium',
        'mlPerKgPerHour': 15,
        'sodiumMgPerHour': 300,
        'isPro': true
      },
      {
        'type': 'tennis',
        'label': l10n.tennis ?? 'Tennis',
        'icon': Icons.sports_tennis,
        'intensity': 'medium',
        'mlPerKgPerHour': 18,
        'sodiumMgPerHour': 450,
        'isPro': true
      },
      {
        'type': 'team_sports',
        'label': l10n.teamSports ?? 'Team Sports',
        'icon': Icons.sports_soccer,
        'intensity': 'high',
        'mlPerKgPerHour': 22,
        'sodiumMgPerHour': 500,
        'isPro': true
      },
    ];
  }

  void _loadUserWeight() async {
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    setState(() {
      _userWeight = provider.weight;
    });
  }

  void _checkForPreselectedValues() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        setState(() {
          if (args['preselected'] != null) {
            final typeKey = args['preselected'];
            final index = _sportTypes.indexWhere((s) => s['type'] == typeKey);
            if (index != -1) {
              _selectedIndex = index;
            }
          }
          if (args['duration'] != null) {
            _durationController.text = args['duration'].toString();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  void _selectSport(int index) {
    final sport = _sportTypes[index];
    if (sport['isPro'] && !_isPro) {
      _showProPaywall();
      return;
    }
    
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showProPaywall() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  Map<String, int> _calculateHydrationNeeds() {
    if (_sportTypes.isEmpty) {
      return {'water': 0, 'sodium': 0};
    }
    
    final sport = _sportTypes[_selectedIndex];
    final duration = double.tryParse(_durationController.text) ?? 0;
    final hours = duration / 60; // конвертируем минуты в часы
    
    // Расчет воды: мл/кг/час * вес * часы
    final waterMl = (sport['mlPerKgPerHour'] as int) * _userWeight * hours;
    
    // Расчет натрия: мг/час * часы
    final sodiumMg = (sport['sodiumMgPerHour'] as int) * hours;
    
    return {
      'water': waterMl.round(),
      'sodium': sodiumMg.round(),
    };
  }

  Future<void> _logActivity() async {
    final l10n = AppLocalizations.of(context);
    final duration = int.tryParse(_durationController.text);
    
    if (duration == null || duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterValidDuration ?? 'Please enter valid duration')),
      );
      return;
    }

    final needs = _calculateHydrationNeeds();
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    
    // Добавляем воду с пометкой о спорте
    provider.addIntake('water', needs['water']!, sodium: needs['sodium']!);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.activityLogged ?? 'Activity logged'}: +${needs['water']} ml, +${needs['sodium']} mg Na'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(true);
    }
  }

  String _getIntensityLabel(String intensity) {
    final l10n = AppLocalizations.of(context);
    switch (intensity) {
      case 'low':
        return l10n.lowIntensity ?? 'Low intensity';
      case 'medium':
        return l10n.mediumIntensity ?? 'Medium intensity';
      case 'high':
        return l10n.highIntensity ?? 'High intensity';
      default:
        return intensity;
    }
  }

  Color _getIntensityColor(String intensity) {
    switch (intensity) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final subscription = Provider.of<SubscriptionProvider>(context);
    _isPro = subscription.isPro;
    
    final hydrationNeeds = _calculateHydrationNeeds();
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(l10n.sports ?? 'Sports'),
        elevation: 0,
        backgroundColor: Colors.teal[500],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.selectActivityType ?? 'Select activity type:',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Grid для видов спорта
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: _sportTypes.isEmpty ? 12 : _sportTypes.length,
              itemBuilder: (context, index) {
                if (_sportTypes.isEmpty) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                  );
                }
                
                final sport = _sportTypes[index];
                final isSelected = _selectedIndex == index;
                final isLocked = sport['isPro'] && !_isPro;
                
                return GestureDetector(
                  onTap: () => _selectSport(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isLocked 
                          ? Colors.grey[50] 
                          : (isSelected ? Colors.teal[50] : Colors.white),
                      border: Border.all(
                        color: isLocked 
                            ? Colors.grey[200]! 
                            : (isSelected ? Colors.teal[400]! : Colors.grey[200]!),
                        width: isSelected ? 2.5 : 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ] : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  sport['icon'] as IconData,
                                  size: 60,
                                  color: isLocked 
                                      ? Colors.grey[400]
                                      : (isSelected ? Colors.teal[600] : Colors.grey[700]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  sport['label'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isLocked 
                                        ? Colors.grey[400]
                                        : (isSelected ? Colors.teal[700] : Colors.grey[800]),
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: isLocked 
                                        ? Colors.grey[400]
                                        : _getIntensityColor(sport['intensity']),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isLocked)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.teal.shade600,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.star,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            Text(
              l10n.duration ?? 'Duration',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: l10n.enterDuration ?? 'Enter duration',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.teal[500]!, width: 2),
                      ),
                      suffixText: l10n.minutes ?? 'minutes',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Быстрые кнопки времени
                Wrap(
                  spacing: 8,
                  children: [
                    _buildDurationChip('15'),
                    _buildDurationChip('30'),
                    _buildDurationChip('60'),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Информационная карточка
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[50]!, Colors.teal[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 48,
                    color: Colors.teal[600],
                  ),
                  const SizedBox(height: 12),
                  if (_sportTypes.isNotEmpty) ...[
                    Text(
                      _sportTypes[_selectedIndex]['label'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getIntensityColor(_sportTypes[_selectedIndex]['intensity']).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getIntensityLabel(_sportTypes[_selectedIndex]['intensity']),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getIntensityColor(_sportTypes[_selectedIndex]['intensity']),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    '${_durationController.text} ${l10n.minutes ?? 'minutes'}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.teal[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          l10n.recommendedIntake ?? 'Recommended intake:',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.water_drop,
                                  color: Colors.blue[600],
                                  size: 24,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${hydrationNeeds['water']} ml',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                                Text(
                                  l10n.water,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey[300],
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.grain,
                                  color: Colors.orange[600],
                                  size: 24,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${hydrationNeeds['sodium']} mg',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[700],
                                  ),
                                ),
                                Text(
                                  l10n.sodium,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${l10n.basedOnWeight ?? 'Based on'}: ${_userWeight.round()} ${l10n.kg}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.teal[600],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _logActivity,
                    icon: const Icon(Icons.add_circle_outline),
                    label: Text(
                      l10n.logActivity ?? 'Log Activity',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[500],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationChip(String duration) {
    final isSelected = _durationController.text == duration;
    return ActionChip(
      label: Text('$duration min'),
      onPressed: () {
        setState(() {
          _durationController.text = duration;
        });
      },
      backgroundColor: isSelected ? Colors.teal[100] : Colors.grey[100],
      labelStyle: TextStyle(
        color: isSelected ? Colors.teal[700] : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}