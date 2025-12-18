import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/educational_content_model.dart';
import '../../services/educational_service.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import 'package:intl/intl.dart';

class ArticleListScreen extends StatefulWidget {
  const ArticleListScreen({super.key});

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  final _educationalService = EducationalService();
  List<EducationalContent> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    final articles = await _educationalService.getArticles();
    if (mounted) {
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artikel Pertanian', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppColors.green))
          : _articles.isEmpty 
              ? Center(child: Text("Belum ada artikel.", style: GoogleFonts.inter()))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: _articles.length,
                  itemBuilder: (context, index) {
                    return _ArticleCardItem(article: _articles[index]);
                  },
                ),
    );
  }
}

class _ArticleCardItem extends StatelessWidget {
  final EducationalContent article;
  const _ArticleCardItem({required this.article});

  @override
  Widget build(BuildContext context) {
    final date = article.publishedAt != null 
        ? DateFormat('dd MMM yyyy').format(article.publishedAt!) 
        : 'Just now';

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context, 
          AppRoutes.newsArticle, 
          arguments: {'articleId': article.id} // Pass ID
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: article.thumbnailUrl ?? 'https://via.placeholder.com/600x300',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(height: 180, color: Colors.grey[200]),
                errorWidget: (context, url, error) => Container(height: 180, color: Colors.grey[300], child: const Icon(Icons.broken_image)),
              ),
            ),
            
            // Info Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(4)),
                        child: Text(article.difficulty.name.toUpperCase(), style: const TextStyle(fontSize: 10, color: Color(0xFF0A3D2F), fontWeight: FontWeight.bold)),
                      ),
                      Text(date, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.description,
                    style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, size: 12, color: Colors.white),
                      ),
                      const SizedBox(width: 6),
                      Text(article.author ?? 'Admin', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                      const Spacer(),
                      const Icon(Icons.bookmark_border, size: 20, color: Colors.grey),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}