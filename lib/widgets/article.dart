import 'package:flutter/material.dart';

class ArticleSection extends StatelessWidget {
  const ArticleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Top Articles", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("SEE ALL", style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: const [
              // ITEM 1
              ArticleCard(
                title: "Kisah Sukses Petani Banyuwangi",
                date: "2 Jam yang lalu",
                // Cukup masukkan path gambarnya saja (String)
                imagePath: "assets/img/petanibanyu.jpg", 
              ),
              SizedBox(height: 15),
              // ITEM 2
              ArticleCard(
                title: "Inovasi Drone Penyiram Pupuk",
                date: "1 Hari yang lalu",
                // Cukup masukkan path gambarnya saja (String)
                imagePath: "assets/img/drone.jpg", 
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ArticleCard extends StatelessWidget {
  // Ganti imageUrl jadi imagePath biar jelas
  final String title, date, imagePath; 
  const ArticleCard({super.key, required this.title, required this.date, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ]
      ),
      child: Row(
        children: [
          // GAMBAR
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
            // PERBAIKAN: Gunakan Image.asset untuk file lokal
            child: Image.asset(
              imagePath, 
              height: 100, 
              width: 100, 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Kalau gambar gak ketemu, muncul kotak abu-abu
                return Container(height: 100, width: 100, color: Colors.grey[300], child: const Icon(Icons.broken_image));
              },
            ),
          ),
          // TEKS
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}