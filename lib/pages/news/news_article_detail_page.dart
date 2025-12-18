import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../models/educational_content_model.dart';
import '../../models/comment_model.dart';
import '../../services/educational_service.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';

class NewsArticleDetailPage extends StatefulWidget {
  final int? articleId; // Accepts ID now

  const NewsArticleDetailPage({super.key, this.articleId});

  @override
  State<NewsArticleDetailPage> createState() => _NewsArticleDetailPageState();
}

class _NewsArticleDetailPageState extends State<NewsArticleDetailPage> {
  final _educationalService = EducationalService();
  EducationalContent? _article;
  bool _isLoading = true;
  bool isLiked = false;
  int likeCount = 147; // Dummy for now, ideally from DB

  // Dummy comments (Feature: Connect to DB later)
  final List<Comment> comments = [
    Comment(
      id: 1,
      author: "Petani Maju",
      time: "10 mins ago",
      text: "Artikel yang sangat bermanfaat!",
      likes: 5,
      replies: [],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchArticleDetails();
  }

  Future<void> _fetchArticleDetails() async {
    if (widget.articleId == null) return;
    
    final article = await _educationalService.getContentById(widget.articleId!);
    if (mounted) {
      setState(() {
        _article = article;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.green)));
    if (_article == null) return const Scaffold(body: Center(child: Text("Artikel tidak ditemukan")));

    final date = _article!.publishedAt != null 
        ? DateFormat('dd MMMM yyyy – HH:mm').format(_article!.publishedAt!) 
        : 'Unknown Date';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.bookmark_border, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Hero(
              tag: 'article_${_article!.id}',
              child: CachedNetworkImage(
                imageUrl: _article!.thumbnailUrl ?? 'https://via.placeholder.com/800x400',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                placeholder: (_,__) => Container(color: Colors.grey[200]),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta Data
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                        child: Text(_article!.author ?? 'Admin', style: const TextStyle(color: AppColors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Title
                  Text(
                    _article!.title,
                    style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                  const SizedBox(height: 24),
                  
                  // Body (Simple Text Rendering)
                  Text(
                    _article!.contentBody ?? _article!.description,
                    style: GoogleFonts.lora(fontSize: 16, height: 1.8, color: Colors.grey[800]), 
                  ),
                  
                  const SizedBox(height: 30),
                  const Divider(),
                  
                  // Interaction
                  _buildInteractionBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => setState(() => isLiked = !isLiked),
          child: Row(
            children: [
              Icon(isLiked ? Icons.thumb_up : Icons.thumb_up_outlined, color: isLiked ? Colors.blue : Colors.grey),
              const SizedBox(width: 8),
              Text('${isLiked ? likeCount + 1 : likeCount} Likes', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        InkWell(
          onTap: () {
             Navigator.pushNamed(
              context,
              AppRoutes.comments,
              arguments: {'comments': comments, 'commentCount': comments.length},
            );
          },
          child: Row(
            children: [
              const Icon(Icons.comment_outlined, color: Colors.grey),
              const SizedBox(width: 8),
              const Text('Comments', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}