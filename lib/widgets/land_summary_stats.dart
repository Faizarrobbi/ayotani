import 'package:flutter/material.dart';
import '../models/iot_reading_model.dart';
import '../services/iot_service.dart';
import '../services/supabase_service.dart';
import '../theme/app_colors.dart';

class LandSummaryStats extends StatefulWidget {
  const LandSummaryStats({super.key});

  @override
  State<LandSummaryStats> createState() => _LandSummaryStatsState();
}

class _LandSummaryStatsState extends State<LandSummaryStats> {
  final _iotService = IotService();

  @override
  Widget build(BuildContext context) {
    final supabase = SupabaseService();
    return FutureBuilder<IotReading?>(
      future: _iotService.getLatestReading(supabase.userId ?? ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingStats();
        }

        if (snapshot.hasError) {
          return _buildErrorStats();
        }

        final reading = snapshot.data;

        if (reading == null) {
          return _buildNoDataStats();
        }

        return _buildStatsGrid(reading);
      },
    );
  }

  /// Build stats grid
  Widget _buildStatsGrid(IotReading reading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Ringkasan Lahan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildStatCard(
                title: 'Kelembapan Tanah',
                value: '${(reading.soilMoisture ?? 0).toStringAsFixed(0)}%',
                icon: Icons.water_drop,
                color: Colors.blue,
                percentage: (reading.soilMoisture ?? 0) / 100,
              ),
              _buildStatCard(
                title: 'Status Air',
                value: '${(reading.waterLevel ?? 0).toStringAsFixed(1)}L',
                icon: Icons.water,
                color: Colors.cyan,
                percentage: (reading.waterLevel ?? 0) / 100,
              ),
              _buildStatCard(
                title: 'Pertumbuhan Tanaman',
                value: '${(reading.plantGrowth ?? 0).toStringAsFixed(1)}cm',
                icon: Icons.eco,
                color: AppColors.green,
                percentage: (reading.plantGrowth ?? 0) / 100,
              ),
              _buildStatCard(
                title: 'Suhu Udara',
                value: '${(reading.temperature ?? 0).toStringAsFixed(1)}°C',
                icon: Icons.thermostat,
                color: Colors.orange,
                percentage: ((reading.temperature ?? 0) + 10) / 50,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build individual stat card
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required double percentage,
  }) {
    // Clamp percentage between 0 and 1
    final clampedPercentage = percentage.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          // Progress indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              minHeight: 4,
              value: clampedPercentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  /// Build loading stats
  Widget _buildLoadingStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Lahan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: List.generate(4, (_) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Build error stats
  Widget _buildErrorStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          border: Border.all(color: Colors.red[200]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Gagal memuat data ringkasan',
          style: TextStyle(color: Colors.red[700]),
        ),
      ),
    );
  }

  /// Build no data stats
  Widget _buildNoDataStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Data ringkasan belum tersedia',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
