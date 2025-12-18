import 'dart:developer' as developer;
import '../models/educational_content_model.dart';
import 'supabase_service.dart';

class EducationalService {
  final _supabase = SupabaseService();

  /// Get ONLY Videos (All)
  Future<List<EducationalContent>> getVideos() async {
    try {
      final response = await _supabase.client
          .from('educational_content')
          .select()
          .eq('content_type', 'video') 
          .order('created_at', ascending: false);

      return (response as List).map((item) => EducationalContent.fromJson(item)).toList();
    } catch (e) {
      developer.log('Error fetching videos: $e');
      return [];
    }
  }

  /// Get ONLY Videos by Difficulty (FIX for undefined method)
  Future<List<EducationalContent>> getVideosByDifficulty(String difficulty) async {
    try {
      final response = await _supabase.client
          .from('educational_content')
          .select()
          .eq('content_type', 'video')
          .eq('difficulty', difficulty)
          .order('created_at', ascending: false);

      return (response as List).map((item) => EducationalContent.fromJson(item)).toList();
    } catch (e) {
      developer.log('Error fetching videos by difficulty: $e');
      return [];
    }
  }

  /// Get ONLY Articles
  Future<List<EducationalContent>> getArticles() async {
    try {
      final response = await _supabase.client
          .from('educational_content')
          .select()
          .eq('content_type', 'article') 
          .order('created_at', ascending: false);

      return (response as List).map((item) => EducationalContent.fromJson(item)).toList();
    } catch (e) {
      developer.log('Error fetching articles: $e');
      return [];
    }
  }

  /// Get ALL content (mixed)
  Future<List<EducationalContent>> getAllContent() async {
    try {
      final response = await _supabase.client
          .from('educational_content')
          .select()
          .order('created_at', ascending: false);
      return (response as List).map((item) => EducationalContent.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }
  
  // Fetch single content details
  Future<EducationalContent?> getContentById(int id) async {
    try {
      final response = await _supabase.client
          .from('educational_content')
          .select()
          .eq('id', id)
          .single();
      return EducationalContent.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}