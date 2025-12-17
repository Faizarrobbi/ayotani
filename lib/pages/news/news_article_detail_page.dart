// File: lib/pages/news/news_article_detail_page.dart
// HALAMAN DETAIL ARTIKEL dengan preview comment

import 'package:flutter/material.dart';
import '../../models/comment_model.dart';
import '../../routes/app_routes.dart';

class NewsArticleDetailPage extends StatefulWidget {
  const NewsArticleDetailPage({Key? key}) : super(key: key);

  @override
  State<NewsArticleDetailPage> createState() => _NewsArticleDetailPageState();
}

class _NewsArticleDetailPageState extends State<NewsArticleDetailPage> {
  bool isLiked = false;
  int likeCount = 147;
  
  final List<Comment> comments = [
    Comment(
      id: 1,
      author: "Daniel caesar",
      time: "32 mins",
      text: "Terima kasih atas informasinya, ini sangat membantu para petani pemula dalam menanggulangi penyakit pada tanaman cabai.",
      likes: 28,
      replies: [
        Comment(
          id: 11,
          author: "Daniel caesar",
          time: "32 mins",
          text: "Terima kasih atas informasinya.",
          likes: 28,
          replies: [],
        ),
      ],
    ),
    Comment(
      id: 2,
      author: "Daniel caesar",
      time: "32 mins",
      text: "Ptis ini nice banget infonya sangat membantu.",
      likes: 28,
      replies: [],
    ),
    Comment(
      id: 3,
      author: "Daniel caesar",
      time: "32 mins",
      text: "Bener banget tuh kak. Berguna banget infonya, khususnya buat aku yang masih pemula dalam bertani. Aku jadi tau jenis-jenis penyakit pada cabai. So, next bisa jadi pembelajaran bagi aku.",
      likes: 28,
      replies: [],
    ),
    Comment(
      id: 4,
      author: "Daniel caesar",
      time: "32 mins",
      text: "Ya valid banget tuh infonya. Btw, aku juga pernah baca di salah satu artikel dari mahasiswa Institut Teknologi Sepuluh Nopember yang kebetulan lagi teliti tentang itu, dan hasilnya juga sama persis. Mantap lah infonya.",
      likes: 28,
      replies: [],
    ),
    Comment(
      id: 5,
      author: "Justin Timberlake",
      time: "1 hour",
      text: "Wow, baru tahu kalau cabai merah bisa terkena penyakit seperti ini.",
      likes: 15,
      replies: [],
    ),
  ];

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount = isLiked ? likeCount + 1 : likeCount - 1;
    });
  }

  void _navigateToComments() {
    Navigator.pushNamed(
      context,
      AppRoutes.comments,
      arguments: {
        'comments': comments,
        'commentCount': comments.length,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'News Article',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildArticleImage(),
            _buildArticleContent(),
            _buildInteractionBar(),
            const Divider(height: 1),
            _buildPreviewComment(),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleImage() {
    return Stack(
      children: [
        Image.network(
          'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=800&q=80',
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[300],
              child: const Icon(Icons.image, size: 100, color: Colors.grey),
            );
          },
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.image, size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  'Petani (Ilustrasi)',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArticleContent() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cerita Petani Banyuwangi Sukses Terapkan Pertanian Terpadu',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'June 28 – 17:58',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.6,
              ),
              children: [
                TextSpan(
                  text: 'BANYUWANGI',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' – Petani di Desa Temuguruh, Kecamatan Sempu, Banyuwangi berhasil mengembangkan konsep pertanian terintegrasi (Integrated Farming System). Salah satunya Nuryanto. Dia memanfaatkan keterkaitan antara tanaman, serta peternakan untuk meningkatkan produktivitas dan keberlanjutan usaha tani.\n\n',
                ),
                TextSpan(
                  text: 'Konsep ini tidak hanya meningkatkan hasil panen, tetapi juga mengurangi biaya produksi dan dampak lingkungan. Nuryanto menjelaskan bahwa sistem ini dimulai dengan memanfaatkan limbah ternak sebagai pupuk organik untuk tanaman.\n\n',
                ),
                TextSpan(
                  text: '"Kotoran sapi dan kambing kami olah jadi kompos berkualitas. Ini membantu mengurangi penggunaan pupuk kimia yang mahal," ujar Nuryanto.\n\n',
                ),
                TextSpan(
                  text: 'Selain itu, sisa hasil panen seperti jerami dan batang jagung digunakan sebagai pakan ternak. Sistem saling menguntungkan ini menciptakan siklus yang efisien dan ramah lingkungan.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: _toggleLike,
            child: Row(
              children: [
                Icon(
                  isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                  color: isLiked ? Colors.blue : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  '$likeCount likes',
                  style: TextStyle(
                    color: isLiked ? Colors.blue : Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: _navigateToComments,
            child: Row(
              children: [
                Icon(Icons.chat_bubble_outline, color: Colors.grey[700], size: 20),
                const SizedBox(width: 6),
                Text(
                  '${comments.length} comments',
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ],
            ),
          ),
          Icon(Icons.share_outlined, color: Colors.grey[700], size: 20),
        ],
      ),
    );
  }

  Widget _buildPreviewComment() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: _buildCommentItem(comments[0], false),
    );
  }

  Widget _buildCommentItem(Comment comment, bool isReply) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: isReply ? 16 : 20,
          backgroundColor: Colors.grey[300],
          child: Icon(
            Icons.person,
            color: Colors.grey[600],
            size: isReply ? 18 : 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    comment.author,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    comment.time,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                comment.text,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.thumb_up_outlined, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${comment.likes}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Reply',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}