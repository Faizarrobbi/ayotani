import 'dart:developer' as developer;
import '../models/educational_content_model.dart';
import 'supabase_service.dart';

/// Service for handling educational content (video belajar)
class EducationalService {
  final _supabase = SupabaseService();

  /// Get all educational content
  Future<List<EducationalContent>> getAllContent() async {
    try {
      final response = await _supabase.client
          .from('educational_content')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => EducationalContent.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      developer.log('Error fetching educational content: $e');
      return [];
    }
  }

  /// Get content by difficulty level
  Future<List<EducationalContent>> getContentByDifficulty(String difficulty) async {
    try {
      final response = await _supabase.client
          .from('educational_content')
          .select()
          .eq('difficulty', difficulty)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => EducationalContent.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      developer.log('Error fetching content by difficulty: $e');
      return [];
    }
  }

  /// Get beginner content (popular for new users)
  Future<List<EducationalContent>> getBeginnerContent() async {
    return getContentByDifficulty('Beginner');
  }

  /// Get intermediate content
  Future<List<EducationalContent>> getIntermediateContent() async {
    return getContentByDifficulty('Intermediate');
  }

  /// Get content by ID
  Future<EducationalContent?> getContentById(int id) async {
    try {
      final response = await _supabase.client
          .from('educational_content')
          .select()
          .eq('id', id)
          .single();

      return EducationalContent.fromJson(response);
    } catch (e) {
      developer.log('Error fetching content: $e');
      return null;
    }
  }

  /// Search content by title or description
  Future<List<EducationalContent>> searchContent(String query) async {
    try {
      final response = await _supabase.client
          .from('educational_content')
          .select()
          .or('title.ilike.%$query%,description.ilike.%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => EducationalContent.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      developer.log('Error searching content: $e');
      return [];
    }
  }

  /// Stream educational content changes
  Stream<List<EducationalContent>> streamContent() {
    return _supabase.client
        .from('educational_content')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) {
          return (data as List)
              .map((item) => EducationalContent.fromJson(item as Map<String, dynamic>))
              .toList();
        });
  }
}
