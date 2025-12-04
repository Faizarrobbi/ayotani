import 'package:flutter/material.dart';

class VideoSection extends StatefulWidget {
  const VideoSection({super.key});
  @override
  State<VideoSection> createState() => _VideoSectionState();
}

class _VideoSectionState extends State<VideoSection> {
  String selectedCategory = "All";

  // Data Video dengan Gambar Assets
  final List<Map<String, String>> allVideos = [
    {
      "title": "Cara Menanam Cabe Merah",
      "level": "Beginner",
      "rating": "4.2",
      "views": "12k",
      "image": "assets/icons/tomat.jpeg" // Pakai gambar tomat sbg contoh
    },
    {
      "title": "Teknik Irigasi Padi",
      "level": "Intermediet",
      "rating": "4.8",
      "views": "5.3k",
      "image": "assets/icons/padi.jpg"
    },
    {
      "title": "Tips Drone Pertanian",
      "level": "Advanced",
      "rating": "4.9",
      "views": "2k",
      "image": "assets/icons/drone.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredVideos = selectedCategory == "All"
        ? allVideos
        : allVideos.where((video) => video["level"] == selectedCategory).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Video Belajar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("SEE ALL", style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Scroll Horizontal Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildChip("All"),
              const SizedBox(width: 10),
              _buildChip("Beginner"),
              const SizedBox(width: 10),
              _buildChip("Intermediet"),
              const SizedBox(width: 10),
              _buildChip("Advanced"),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Scroll Samping
            padding: const EdgeInsets.only(left: 20, right: 10),
            itemCount: filteredVideos.length,
            itemBuilder: (context, index) {
              final video = filteredVideos[index];
              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: VideoCard(
                  title: video["title"]!,
                  level: video["level"]!,
                  rating: video["rating"]!,
                  views: video["views"]!,
                  imagePath: video["image"]!,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label) {
    bool isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0B6138) : const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(
            color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final String title, level, rating, views, imagePath;
  const VideoCard({super.key, required this.title, required this.level, required this.rating, required this.views, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(imagePath, height: 120, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(level, style: const TextStyle(color: Color(0xFF00880C), fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Free", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const Spacer(),
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    Text(" $rating ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(views, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}