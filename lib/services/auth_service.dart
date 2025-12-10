import 'dart:developer' as developer;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile_model.dart';
import 'supabase_service.dart';

class AuthService {
  final _supabase = SupabaseService();

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await _supabase.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _createProfileWithRetry(
          userId: response.user!.id,
          username: username,
        );
      }

      return response;
    } catch (e) {
      developer.log('Signup Error: $e');
      rethrow;
    }
  }

  Future<void> _createProfileWithRetry({
    required String userId,
    required String username,
    int retries = 3,
  }) async {
    for (int i = 0; i < retries; i++) {
      try {
        await _supabase.client.from('profiles').upsert({
          'id': userId,
          'username': username,
          'level': 1,
          'gems': 0,
          'updated_at': DateTime.now().toIso8601String(),
        });
        return; 
      } catch (e) {
        developer.log('Attempt ${i + 1} failed: $e');
        if (i == retries - 1) rethrow;
        await Future.delayed(Duration(seconds: i + 1));
      }
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.client.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<UserProfile?> getCurrentUserProfile() async {
    try {
      if (_supabase.userId == null) return null;
      final response = await _supabase.client
          .from('profiles')
          .select()
          .eq('id', _supabase.userId!)
          .single();
      return UserProfile.fromJson(response);
    } catch (e) {
      developer.log('Error fetching user profile: $e');
      return null;
    }
  }

  Future<UserProfile?> updateProfile({
    required String userId,
    String? username,
    String? avatarUrl,
    int? level,
    int? gems,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (username != null) updates['username'] = username;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (level != null) updates['level'] = level;
      if (gems != null) updates['gems'] = gems;
      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabase.client
          .from('profiles')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();
      return UserProfile.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addGems(String userId, int gemsToAdd) async {
    try {
      final response = await _supabase.client
          .from('profiles')
          .select('gems')
          .eq('id', userId)
          .single();
      final currentGems = response['gems'] as int? ?? 0;
      final newGems = currentGems + gemsToAdd;
      await _supabase.client
          .from('profiles')
          .update({
            'gems': newGems,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }

  Stream<UserProfile?> streamUserProfile(String userId) {
    return _supabase.client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((data) {
          if (data.isEmpty) return null;
          return UserProfile.fromJson(data.first);
        });
  }
}