import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/alcohol_service.dart';
import '../models/alcohol_intake.dart';

class AlcoholCard extends StatelessWidget {
  const AlcoholCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AlcoholService>(
      builder: (context, alcoholService, child) {
        if (alcoholService.soberModeEnabled) {
          return const SizedBox.shrink();
        }
        
        final totalSD = alcoholService.totalStandardDrinks;
        
        if (totalSD == 0) {
          return const SizedBox.shrink();
        }
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange[50]!, Colors.orange[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange[700],
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Минимум вреда',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[800],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red[500],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${totalSD.toStringAsFixed(1)} SD',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildAdviceItem(
                Icons.water_drop,
                '+${alcoholService.totalWaterCorrection.toStringAsFixed(0)} мл воды нужно выпить',
                Colors.blue,
              ),
              const SizedBox(height: 8),
              _buildAdviceItem(
                Icons.grain,
                '+${alcoholService.totalSodiumCorrection.toStringAsFixed(0)} мг натрия добавить',
                Colors.purple,
              ),
              const SizedBox(height: 8),
              _buildAdviceItem(
                Icons.bedtime,
                'Ложитесь спать раньше',
                Colors.indigo,
              ),
              
              // Список выпитого
              if (alcoholService.todayIntakes.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Сегодня выпито:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                ...alcoholService.todayIntakes.map((intake) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(intake.type.icon, size: 16, color: Colors.orange[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${intake.formattedTime} - ${intake.volumeMl.toInt()} мл, ${intake.abv}% (${intake.formattedSD})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildAdviceItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}

class AlcoholIndicator extends StatelessWidget {
  const AlcoholIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AlcoholService>(
      builder: (context, alcoholService, child) {
        if (alcoholService.soberModeEnabled) {
          return const SizedBox.shrink();
        }
        
        final totalSD = alcoholService.totalStandardDrinks;
        
        if (totalSD == 0) {
          return const SizedBox.shrink();
        }
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange[200]!),
          ),
          child: Row(
            children: [
              Icon(
                Icons.local_bar,
                color: Colors.orange[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Алкоголь сегодня',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red[500],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${totalSD.toStringAsFixed(1)} SD',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}