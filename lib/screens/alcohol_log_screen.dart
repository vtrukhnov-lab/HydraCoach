import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/alcohol_intake.dart';
import '../services/alcohol_service.dart';

class AlcoholLogScreen extends StatefulWidget {
  const AlcoholLogScreen({Key? key}) : super(key: key);

  @override
  State<AlcoholLogScreen> createState() => _AlcoholLogScreenState();
}

class _AlcoholLogScreenState extends State<AlcoholLogScreen> {
  AlcoholType _selectedType = AlcoholType.beer;
  final TextEditingController _volumeController = TextEditingController(text: '500');
  double _abvValue = AlcoholType.beer.defaultAbv;
  
  double get _standardDrinks {
    final volume = double.tryParse(_volumeController.text) ?? 0;
    return AlcoholIntake(
      timestamp: DateTime.now(),
      type: _selectedType,
      volumeMl: volume,
      abv: _abvValue,
    ).standardDrinks;
  }
  
  double get _waterCorrection {
    return _standardDrinks * 150; // 150 мл на SD
  }
  
  double get _sodiumCorrection {
    return _standardDrinks * 200; // 200 мг на SD
  }
  
  double get _hriModifier {
    const double hriPerSD = 3.0;
    const double hriCap = 15.0;
    return (_standardDrinks * hriPerSD).clamp(0, hriCap);
  }

  @override
  void dispose() {
    _volumeController.dispose();
    super.dispose();
  }

  void _selectType(AlcoholType type) {
    setState(() {
      _selectedType = type;
      _abvValue = type.defaultAbv;
    });
  }

  Future<void> _saveIntake() async {
    final volume = double.tryParse(_volumeController.text);
    if (volume == null || volume <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите корректный объем')),
      );
      return;
    }

    final intake = AlcoholIntake(
      timestamp: DateTime.now(),
      type: _selectedType,
      volumeMl: volume,
      abv: _abvValue,
    );

    final alcoholService = Provider.of<AlcoholService>(context, listen: false);
    await alcoholService.addIntake(intake);

    if (mounted) {
      Navigator.of(context).pop(true); // Возвращаем true, что добавили запись
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Добавить алкоголь'),
        elevation: 0,
        backgroundColor: Colors.orange[400],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Выбор типа напитка
            const Text(
              'Выберите тип напитка:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: AlcoholType.values.map((type) {
                final isSelected = _selectedType == type;
                return GestureDetector(
                  onTap: () => _selectType(type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.orange[50] : Colors.white,
                      border: Border.all(
                        color: isSelected ? Colors.orange[400]! : Colors.grey[300]!,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          type.icon,
                          size: 36,
                          color: isSelected ? Colors.orange[600] : Colors.grey[600],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          type.label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.orange[800] : Colors.grey[700],
                          ),
                        ),
                        Text(
                          '~${type.defaultAbv.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 24),
            
            // Ввод объема
            const Text(
              'Объем (мл):',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _volumeController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Введите объем в мл',
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
                  borderSide: BorderSide(color: Colors.orange[400]!, width: 2),
                ),
                suffixText: 'мл',
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Слайдер крепости
            const Text(
              'Крепость (%):',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  Text(
                    '${_abvValue.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[600],
                    ),
                  ),
                  Slider(
                    value: _abvValue,
                    min: 0,
                    max: 50,
                    divisions: 100,
                    activeColor: Colors.orange[400],
                    inactiveColor: Colors.orange[100],
                    onChanged: (value) {
                      setState(() {
                        _abvValue = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Расчет SD и корректировок
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[50]!, Colors.orange[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Стандартные дринки:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_standardDrinks.toStringAsFixed(1)} SD',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCorrectionItem(
                        '+${_waterCorrection.toStringAsFixed(0)} мл',
                        'Доп. вода',
                        Icons.water_drop,
                        Colors.blue,
                      ),
                      _buildCorrectionItem(
                        '+${_sodiumCorrection.toStringAsFixed(0)} мг',
                        'Доп. натрий',
                        Icons.grain,
                        Colors.purple,
                      ),
                      _buildCorrectionItem(
                        '+${_hriModifier.toStringAsFixed(1)}',
                        'HRI риск',
                        Icons.warning,
                        Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Кнопки действий
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey[400]!, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Отмена',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveIntake,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Добавить',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
  
  Widget _buildCorrectionItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}