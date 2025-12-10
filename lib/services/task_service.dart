import 'dart:developer' as developer;
import '../models/daily_task_model.dart';
import '../models/user_task_model.dart';
import 'supabase_service.dart';
import 'auth_service.dart';

/// Service for handling task management and completion with gems reward logic
class TaskService {
  final _supabase = SupabaseService();
  final _auth = AuthService();

  /// Get all daily tasks
  Future<List<DailyTask>> getAllDailyTasks() async {
    try {
      final response = await _supabase.client
          .from('daily_tasks')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => DailyTask.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      developer.log('Error fetching daily tasks: $e');
      return [];
    }
  }

  /// Get user tasks for a specific user
  Future<List<UserTask>> getUserTasks(String userId) async {
    try {
      final response = await _supabase.client
          .from('user_tasks')
          .select()
          .eq('profile_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => UserTask.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      developer.log('Error fetching user tasks: $e');
      return [];
    }
  }

  /// Get pending tasks for a user (with task details)
  Future<List<Map<String, dynamic>>> getPendingTasksWithDetails(String userId) async {
    try {
      final response = await _supabase.client.from('user_tasks').select(
          '''
          id,
          profile_id,
          daily_task_id,
          status,
          completed_at,
          daily_tasks:daily_task_id (
            id,
            title,
            description,
            reward_gems,
            category,
            created_at
          )
          ''').eq('profile_id', userId).eq('status', 'pending').order('created_at', ascending: false);

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      developer.log('Error fetching pending tasks: $e');
      return [];
    }
  }

  /// Get the top pending task (most recently created)
  Future<Map<String, dynamic>?> getTopPendingTask(String userId) async {
    try {
      final tasks = await getPendingTasksWithDetails(userId);
      return tasks.isNotEmpty ? tasks.first : null;
    } catch (e) {
      developer.log('Error fetching top pending task: $e');
      return null;
    }
  }

  /// Create a user task
  Future<UserTask?> createUserTask({
    required String profileId,
    required int dailyTaskId,
  }) async {
    try {
      final response = await _supabase.client
          .from('user_tasks')
          .insert({
            'profile_id': profileId,
            'daily_task_id': dailyTaskId,
            'status': 'pending',
          })
          .select()
          .single();

      return UserTask.fromJson(response);
    } catch (e) {
      developer.log('Error creating user task: $e');
      return null;
    }
  }

  /// Mark a task as completed and award gems
  /// CRITICAL: This updates both user_tasks and adds gems to profiles
  Future<bool> completeTask({
    required int userTaskId,
    required String userId,
    required int rewardGems,
  }) async {
    try {
      // Start a transaction-like operation
      final now = DateTime.now().toIso8601String();

      // 1. Update user_tasks status to completed
      await _supabase.client
          .from('user_tasks')
          .update({
            'status': 'completed',
            'completed_at': now,
          })
          .eq('id', userTaskId);

      // 2. Add gems to user profile
      await _auth.addGems(userId, rewardGems);

      developer.log('Task completed! +$rewardGems gems awarded');
      return true;
    } catch (e) {
      developer.log('Error completing task: $e');
      return false;
    }
  }

  /// Stream user tasks for real-time updates
  Stream<List<UserTask>> streamUserTasks(String userId) {
    return _supabase.client
        .from('user_tasks')
        .stream(primaryKey: ['id'])
        .eq('profile_id', userId)
        .map((data) {
          return (data as List)
              .map((item) => UserTask.fromJson(item as Map<String, dynamic>))
              .toList();
        });
  }

  /// Get tasks by category
  Future<List<DailyTask>> getTasksByCategory(String category) async {
    try {
      final response = await _supabase.client
          .from('daily_tasks')
          .select()
          .eq('category', category)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => DailyTask.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      developer.log('Error fetching tasks by category: $e');
      return [];
    }
  }
}
