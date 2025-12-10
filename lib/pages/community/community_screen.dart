import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Komunitas Tani', 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.green.withOpacity(0.1),
                  child: const Icon(Icons.person, color: AppColors.green),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Apa yang anda tanam hari ini?", 
                  style: TextStyle(color: Colors.grey, fontSize: 14)
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Diskusi Terbaru",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildPostItem(
            name: "Budi Santoso",
            role: "Petani Cabai",
            time: "2 jam yang lalu",
            content: "Alhamdulillah panen cabai hari ini melimpah! Harga di pasar juga sedang bagus.",
            likes: 24,
            comments: 5,
          ),
          _buildPostItem(
            name: "Siti Aminah",
            role: "Pemula",
            time: "5 jam yang lalu",
            content: "Ada yang tau cara mengatasi daun menguning pada tanaman tomat?",
            likes: 12,
            comments: 8,
            hasImage: true, 
          ),
        ],
      ),
    );
  }

  Widget _buildPostItem({
    required String name,
    required String role,
    required String time,
    required String content,
    required int likes,
    required int comments,
    bool hasImage = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), 
            blurRadius: 8, 
            offset: const Offset(0, 2)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: Text(name[0], style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text("$role • $time", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: const TextStyle(height: 1.5)),
          if (hasImage) ...[
            const SizedBox(height: 12),
            Container(
              height: 150, 
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.image, size: 50, color: Colors.green),
              ),
            ),
          ],
          const SizedBox(height: 16),
          const Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(onPressed: () {}, icon: const Icon(Icons.thumb_up_outlined, size: 18), label: Text("$likes")),
              TextButton.icon(onPressed: () {}, icon: const Icon(Icons.comment_outlined, size: 18), label: Text("$comments")),
            ],
          ),
        ],
      ),
    );
  }
}