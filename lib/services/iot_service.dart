import 'dart:developer' as developer;
import '../models/iot_reading_model.dart';
import 'supabase_service.dart';

class IotService {
  final _supabase = SupabaseService();

  Future<IotReading?> getLatestReading(String userId) async {
    try {
      final response = await _supabase.client
          .from('iot_readings')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return IotReading.fromJson(response);
    } catch (e) {
      developer.log('Error fetching latest IoT reading: $e');
      return null;
    }
  }

  // NEW: Fetch history for charts (Last 7 readings)
  Future<List<IotReading>> getReadingHistory(String userId) async {
    try {
      final response = await _supabase.client
          .from('iot_readings')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(7);

      final list = (response as List).map((e) => IotReading.fromJson(e)).toList();
      return list.reversed.toList(); // Reverse so graph goes left-to-right (oldest to newest)
    } catch (e) {
      developer.log('Error fetching IoT history: $e');
      return [];
    }
  }

  Future<IotReading> getDemoReading(String userId) async {
    return IotReading(
      id: 0,
      deviceId: 'DEMO-001',
      userId: userId,
      soilMoisture: 65.0,
      waterLevel: 80.0,
      plantGrowth: 15.5,
      temperature: 28.5,
      humidity: 70.0,
      createdAt: DateTime.now(),
    );
  }
}