import 'package:flutter/material.dart';
import '../models/educational_content_model.dart';
import '../services/educational_service.dart';
import '../theme/app_colors.dart';

class EducationalCarousel extends StatefulWidget {
  const EducationalCarousel({super.key});

  @override
  State<EducationalCarousel> createState() => _EducationalCarouselState();
}

class _EducationalCarouselState extends State<EducationalCarousel> {
  final _educationalService = EducationalService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EducationalContent>>(
      future: _educationalService.getAllContent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCarousel();
        }

        if (snapshot.hasError) {
          return _buildErrorCarousel();
        }

        final contents = snapshot.data ?? [];

        if (contents.isEmpty) {
          return _buildEmptyCarousel();
        }

        return _buildContentCarousel(contents);
      },
    );
  }

  /// Build content carousel
  Widget _buildContentCarousel(List<EducationalContent> contents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Video Belajar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Lihat Semua',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: contents.length,
            itemBuilder: (context, index) {
              final content = contents[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildContentCard(content),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build content card
  Widget _buildContentCard(EducationalContent content) {
    final difficultyColor = _getDifficultyColor(content.difficulty);
    final difficultyText = _getDifficultyText(content.difficulty);

    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail placeholder
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: difficultyColor.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.play_circle_fill,
                size: 40,
                color: difficultyColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: difficultyColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    difficultyText,
                    style: TextStyle(
                      fontSize: 10,
                      color: difficultyColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Get difficulty color
  Color _getDifficultyColor(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return Colors.green;
      case DifficultyLevel.intermediate:
        return Colors.orange;
      case DifficultyLevel.advanced:
        return Colors.red;
    }
  }

  /// Get difficulty text
  String _getDifficultyText(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return 'Pemula';
      case DifficultyLevel.intermediate:
        return 'Menengah';
      case DifficultyLevel.advanced:
        return 'Lanjut';
    }
  }

  /// Build loading carousel
  Widget _buildLoadingCarousel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Video Belajar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Build error carousel
  Widget _buildErrorCarousel() {
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
          'Gagal memuat video belajar',
          style: TextStyle(color: Colors.red[700]),
        ),
      ),
    );
  }

  /// Build empty carousel
  Widget _buildEmptyCarousel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Video belajar belum tersedia',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
