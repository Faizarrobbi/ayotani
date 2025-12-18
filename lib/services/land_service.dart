import 'dart:developer' as developer;
import '../models/land_model.dart';
import '../models/land_task_model.dart';
import 'supabase_service.dart';

class LandService {
  final _supabase = SupabaseService();

  // --- LANDS ---

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
      await _supabase.client.from('lands').insert(land.toJson());
      return true;
    } catch (e) {
      developer.log('Error adding land: $e');
      return false;
    }
  }

  Future<bool> updateLand(Land land) async {
    try {
      await _supabase.client.from('lands').update(land.toJson()).eq('id', land.id);
      return true;
    } catch (e) {
      developer.log('Error updating land: $e');
      return false;
    }
  }

  // --- PROGRESS LOGS (Manual Charts) ---

  Future<bool> addProgressLog(int landId, double water, double height, String notes) async {
    try {
      await _supabase.client.from('land_progress_logs').insert({
        'land_id': landId,
        'water_amount_liters': water,
        'plant_height_cm': height,
        'notes': notes,
        'log_date': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      developer.log('Error logging progress: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getProgressLogs(int landId) async {
    try {
      final response = await _supabase.client
          .from('land_progress_logs')
          .select()
          .eq('land_id', landId)
          .order('log_date', ascending: true) 
          .limit(10); // Last 10 entries for better charts
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      developer.log('Error fetching logs: $e');
      return [];
    }
  }

  // --- CUSTOM TASKS ---

  Future<List<LandTask>> getLandTasks(int landId, DateTime date) async {
    try {
      // Simple fetch. For advanced repeating logic, you might filter in Dart.
      // Here we fetch all for the land to simplify filtering.
      final response = await _supabase.client
          .from('land_tasks')
          .select()
          .eq('land_id', landId);

      final allTasks = (response as List).map((e) => LandTask.fromJson(e)).toList();
      
      // Filter in memory for specific date match (simplified)
      return allTasks.where((task) {
        return isSameDay(task.dueDate, date) || task.repeatType == 'daily';
      }).toList();
    } catch (e) {
      developer.log('Error fetching tasks: $e');
      return [];
    }
  }

  Future<bool> addLandTask(LandTask task) async {
    try {
      await _supabase.client.from('land_tasks').insert(task.toJson());
      return true;
    } catch (e) {
      developer.log('Error adding task: $e');
      return false;
    }
  }

  Future<bool> toggleTaskComplete(int taskId, bool currentValue) async {
    try {
      await _supabase.client.from('land_tasks').update({'is_completed': !currentValue}).eq('id', taskId);
      return true;
    } catch (e) {
      developer.log('Error toggling task: $e');
      return false;
    }
  }
  
  Future<bool> deleteTask(int taskId) async {
    try {
      await _supabase.client.from('land_tasks').delete().eq('id', taskId);
      return true;
    } catch (e) {
      developer.log('Error deleting task: $e');
      return false;
    }
  }

  // Helper
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Demo Land
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
      modalPerKg: 5000,
      targetProfitPercentage: 20,
      targetHarvestKg: 1000,
    );
  }
}