import 'package:supabase_flutter/supabase_flutter.dart';

/// Singleton wrapper for Supabase client to simplify operations
class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  /// Get the Supabase client instance
  SupabaseClient get client => Supabase.instance.client;

  /// Get the current authenticated user
  User? get currentUser => client.auth.currentUser;

  /// Get the current user ID
  String? get userId => currentUser?.id;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;
}
