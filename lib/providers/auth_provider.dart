import 'package:flutter/material.dart';
import '../models/user_profile_model.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';

/// Provider for managing auth state and user profile
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final SupabaseService _supabase = SupabaseService();

  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _error;
  bool _isOnboardingComplete = false;

  // Getters
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _supabase.currentUser != null;
  bool get isOnboardingComplete => _isOnboardingComplete;

  /// Load user profile from Supabase
  Future<void> loadUserProfile() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _userProfile = await _authService.getCurrentUserProfile();

      // Check if onboarding is complete (we can add this to profiles later)
      _isOnboardingComplete = _userProfile != null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign in user
  Future<bool> signIn({required String email, required String password}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.signIn(email: email, password: password);
      await loadUserProfile();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign up user
  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.signUp(
        email: email,
        password: password,
        username: username,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.signOut();

      _userProfile = null;
      _isOnboardingComplete = false;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mark onboarding as complete
  Future<void> completeOnboarding() async {
    if (_userProfile != null && _supabase.userId != null) {
      _isOnboardingComplete = true;
      notifyListeners();
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? username,
    String? avatarUrl,
  }) async {
    if (_supabase.userId == null) return false;

    try {
      _isLoading = true;
      notifyListeners();

      final updated = await _authService.updateProfile(
        userId: _supabase.userId!,
        username: username,
        avatarUrl: avatarUrl,
      );

      if (updated != null) {
        _userProfile = updated;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
