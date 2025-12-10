import 'dart:developer' as developer;
import '../models/land_model.dart';
import 'supabase_service.dart';

class LandService {
  final _supabase = SupabaseService();

  Future<List<Land>> getUserLands(String userId) async {
    try {
      final response = await _supabase.client
          .from('lands')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List).map((item) => Land.fromJson(item)).toList();
    } catch (e) {
      developer.log('Error fetching lands: $e');
      return [];
    }
  }

  Future<bool> addLand(Land land) async {
    try {
      await _supabase.client.from('lands').insert({
        'user_id': land.userId,
        'name': land.name,
        'location': land.location,
        'plant_type': land.plantType,
        'planting_date': land.plantingDate?.toIso8601String(),
        'harvest_date': land.harvestDate?.toIso8601String(),
        'area_size': land.areaSize,
      });
      return true;
    } catch (e) {
      developer.log('Error adding land: $e');
      return false;
    }
  }
  
  // Dummy data for initial display if DB is empty
  Land getDemoLand() {
    return Land(
      id: 0,
      userId: 'demo',
      name: 'Lahan Tomat #1',
      location: 'Malang, Jawa Timur',
      plantType: 'Tomat Cherry',
      plantingDate: DateTime.now().subtract(const Duration(days: 30)),
      harvestDate: DateTime.now().add(const Duration(days: 60)),
      areaSize: 12.5,
    );
  }
}