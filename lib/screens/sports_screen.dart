// ============================================================================
// FILE: lib/screens/sports_screen.dart
// 
// PURPOSE: Sports Activity Screen with HRI integration
// Tracks workouts and automatically calculates hydration needs.
// Integrates with HRI Service for dynamic risk calculation.
// 
// FEATURES:
// - Grid of sport types (3 FREE, 9 PRO)
// - Duration and intensity tracking
// - Automatic water/electrolyte calculation based on weight
// - Full HRI workout integration
// - Smart hydration recommendations
// - PRO gating for premium activities
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/subscription_service.dart';
import '../services/hri_service.dart';
import '../screens/paywall_screen.dart';
import 'package:hydracoach/providers/hydration_provider.dart';

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
  double _userWeight = 70; // kg

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
      // FREE types
      {
        'type': 'walking',
        'label': l10n.walking ?? 'Walking',
        'icon': Icons.directions_walk,
        'intensity': 'low',
        'intensityValue': 2, // For HRI: 1-5 scale
        'mlPerKgPerHour': 12,
        'sodiumMgPerHour': 200,
        'potassiumMgPerHour': 50,
        'magnesiumMgPerHour': 10,
        'isPro': false,
        'color': Colors.green,
      },
      {
        'type': 'running',
        'label': l10n.running ?? 'Running',
        'icon': Icons.directions_run,
        'intensity': 'medium',
        'intensityValue': 3,
        'mlPerKgPerHour': 17,
        'sodiumMgPerHour': 400,
        'potassiumMgPerHour': 100,
        'magnesiumMgPerHour': 20,
        'isPro': false,
        'color': Colors.orange,
      },
      {
        'type': 'gym',
        'label': l10n.gym ?? 'Gym',
        'icon': Icons.fitness_center,
        'intensity': 'high',
        'intensityValue': 4,
        'mlPerKgPerHour': 24,
        'sodiumMgPerHour': 600,
        'potassiumMgPerHour': 150,
        'magnesiumMgPerHour': 30,
        'isPro': false,
        'color': Colors.red,
      },
      // PRO types
      {
        'type': 'cycling',
        'label': l10n.cycling ?? 'Cycling',
        'icon': Icons.directions_bike,
        'intensity': 'medium',
        'intensityValue': 3,
        'mlPerKgPerHour': 16,
        'sodiumMgPerHour': 350,
        'potassiumMgPerHour': 90,
        'magnesiumMgPerHour': 18,
        'isPro': true,
        'color': Colors.orange,
      },
      {
        'type': 'swimming',
        'label': l10n.swimming ?? 'Swimming',
        'icon': Icons.pool,
        'intensity': 'high',
        'intensityValue': 4,
        'mlPerKgPerHour': 20,
        'sodiumMgPerHour': 300, // Less due to no sweating
        'potassiumMgPerHour': 80,
        'magnesiumMgPerHour': 15,
        'isPro': true,
        'color': Colors.blue,
      },
      {
        'type': 'yoga',
        'label': l10n.yoga ?? 'Yoga',
        'icon': Icons.self_improvement,
        'intensity': 'low',
        'intensityValue': 1,
        'mlPerKgPerHour': 10,
        'sodiumMgPerHour': 150,
        'potassiumMgPerHour': 40,
        'magnesiumMgPerHour': 8,
        'isPro': true,
        'color': Colors.purple,
      },
      {
        'type': 'hiit',
        'label': l10n.hiit ?? 'HIIT',
        'icon': Icons.flash_on,
        'intensity': 'very_high',
        'intensityValue': 5,
        'mlPerKgPerHour': 30,
        'sodiumMgPerHour': 800,
        'potassiumMgPerHour': 200,
        'magnesiumMgPerHour': 40,
        'isPro': true,
        'color': Colors.deepOrange,
      },
      {
        'type': 'crossfit',
        'label': l10n.crossfit ?? 'CrossFit',
        'icon': Icons.sports_mma,
        'intensity': 'very_high',
        'intensityValue': 5,
        'mlPerKgPerHour': 28,
        'sodiumMgPerHour': 700,
        'potassiumMgPerHour': 180,
        'magnesiumMgPerHour': 35,
        'isPro': true,
        'color': Colors.deepOrange,
      },
      {
        'type': 'boxing',
        'label': l10n.boxing ?? 'Boxing',
        'icon': Icons.sports_kabaddi,
        'intensity': 'high',
        'intensityValue': 4,
        'mlPerKgPerHour': 25,
        'sodiumMgPerHour': 650,
        'potassiumMgPerHour': 160,
        'magnesiumMgPerHour': 32,
        'isPro': true,
        'color': Colors.red,
      },
      {
        'type': 'dancing',
        'label': l10n.dancing ?? 'Dancing',
        'icon': Icons.music_note,
        'intensity': 'medium',
        'intensityValue': 3,
        'mlPerKgPerHour': 15,
        'sodiumMgPerHour': 300,
        'potassiumMgPerHour': 75,
        'magnesiumMgPerHour': 15,
        'isPro': true,
        'color': Colors.pink,
      },
      {
        'type': 'tennis',
        'label': l10n.tennis ?? 'Tennis',
        'icon': Icons.sports_tennis,
        'intensity': 'medium',
        'intensityValue': 3,
        'mlPerKgPerHour': 18,
        'sodiumMgPerHour': 450,
        'potassiumMgPerHour': 110,
        'magnesiumMgPerHour': 22,
        'isPro': true,
        'color': Colors.lime,
      },
      {
        'type': 'team_sports',
        'label': l10n.teamSports ?? 'Team Sports',
        'icon': Icons.sports_soccer,
        'intensity': 'high',
        'intensityValue': 4,
        'mlPerKgPerHour': 22,
        'sodiumMgPerHour': 500,
        'potassiumMgPerHour': 130,
        'magnesiumMgPerHour': 25,
        'isPro': true,
        'color': Colors.green,
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
      return {'water': 0, 'sodium': 0, 'potassium': 0, 'magnesium': 0};
    }
    
    final sport = _sportTypes[_selectedIndex];
    final duration = double.tryParse(_durationController.text) ?? 0;
    final hours = duration / 60;
    
    // Calculate needs based on weight and duration
    final waterMl = (sport['mlPerKgPerHour'] as int) * _userWeight * hours;
    final sodiumMg = (sport['sodiumMgPerHour'] as int) * hours;
    final potassiumMg = (sport['potassiumMgPerHour'] as int) * hours;
    final magnesiumMg = (sport['magnesiumMgPerHour'] as int) * hours;
    
    return {
      'water': waterMl.round(),
      'sodium': sodiumMg.round(),
      'potassium': potassiumMg.round(),
      'magnesium': magnesiumMg.round(),
    };
  }

  Future<void> _logActivity() async {
    final l10n = AppLocalizations.of(context);
    final duration = int.tryParse(_durationController.text);
    
    if (duration == null || duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.enterValidDuration ?? 'Please enter valid duration'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final needs = _calculateHydrationNeeds();
    final provider = Provider.of<HydrationProvider>(context, listen: false);
    final hriService = Provider.of<HRIService>(context, listen: false);
    final sport = _sportTypes[_selectedIndex];
    
    // Add water and electrolytes to hydration tracking
    provider.addIntake(
      'water', 
      needs['water']!,
      sodium: needs['sodium']!,
      potassium: needs['potassium']!,
      magnesium: needs['magnesium']!,
    );
    
    // IMPORTANT: Add workout to HRI Service
    await hriService.addWorkout(
      type: sport['type'],
      intensity: sport['intensityValue'],
      durationMinutes: duration,
    );
    
    // Calculate HRI impact
    final workoutImpact = sport['intensityValue'] * (duration / 30.0);
    
    if (mounted) {
      // Show detailed success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${sport['label']} logged successfully!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text('Hydration: +${needs['water']} ml'),
              Text('Electrolytes: Na +${needs['sodium']}mg, K +${needs['potassium']}mg'),
              Text('HRI Impact: +${workoutImpact.toStringAsFixed(1)} points'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
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
      case 'very_high':
        return l10n.veryHighIntensity ?? 'Very high intensity';
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
      case 'very_high':
        return Colors.deepOrange;
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
    final selectedSport = _sportTypes.isNotEmpty ? _sportTypes[_selectedIndex] : null;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(l10n.sports ?? 'Sports & Activities'),
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
              l10n.selectActivityType ?? 'Select activity type',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Sports grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: _sportTypes.length,
              itemBuilder: (context, index) {
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
                                  size: 50,
                                  color: isLocked 
                                      ? Colors.grey[400]
                                      : (isSelected 
                                          ? sport['color'] as Color
                                          : Colors.grey[700]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  sport['label'],
                                  style: TextStyle(
                                    fontSize: 12,
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
                                color: Colors.purple.shade600,
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
            
            // Duration input
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
                // Quick duration buttons
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
            
            // Information card
            if (selectedSport != null)
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
                      selectedSport['icon'] as IconData,
                      size: 48,
                      color: selectedSport['color'] as Color,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      selectedSport['label'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getIntensityColor(selectedSport['intensity']).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getIntensityLabel(selectedSport['intensity']),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getIntensityColor(selectedSport['intensity']),
                        ),
                      ),
                    ),
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
                    
                    // Hydration needs
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            l10n.recommendedIntake ?? 'Recommended intake',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Water
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.water_drop, color: Colors.blue[600], size: 20),
                              const SizedBox(width: 8),
                              Text(
                                '${hydrationNeeds['water']} ml',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Electrolytes
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildElectrolyteChip(
                                'Na',
                                hydrationNeeds['sodium']!,
                                Colors.orange,
                              ),
                              _buildElectrolyteChip(
                                'K',
                                hydrationNeeds['potassium']!,
                                Colors.purple,
                              ),
                              _buildElectrolyteChip(
                                'Mg',
                                hydrationNeeds['magnesium']!,
                                Colors.pink,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // HRI Impact
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.trending_up, size: 16, color: Colors.teal[600]),
                          const SizedBox(width: 6),
                          Text(
                            'HRI Impact: +${(selectedSport['intensityValue'] * (int.tryParse(_durationController.text) ?? 0) / 30.0).toStringAsFixed(1)} points',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.basedOnWeight ?? 'Based on'}: ${_userWeight.round()} ${l10n.kg ?? 'kg'}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.teal[600],
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Action buttons
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
  
  Widget _buildElectrolyteChip(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${value}mg',
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}