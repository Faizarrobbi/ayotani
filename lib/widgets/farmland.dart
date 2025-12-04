import 'package:flutter/material.dart';
import '../pages/monitorpage.dart'; // Pastikan file ini ada

class FarmSection extends StatelessWidget {
  const FarmSection({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Lahan Pertanian", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("SEE ALL", style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 240, 
          child: ListView(
            scrollDirection: Axis.horizontal, // Scroll Samping
            physics: const BouncingScrollPhysics(), // Efek mantul
            padding: const EdgeInsets.only(left: 20, right: 10),
            children: const [
              FarmCard(
                cropName: "Tomat",
                size: "12 ha",
                // Pakai Assets sesuai nama file kamu
                imagePath: "assets/img/lahan1.png",
              ),
              SizedBox(width: 15),
              FarmCard(
                cropName: "Padi",
                size: "24 ha",
                imagePath: "assets/img/lahan2.png",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FarmCard extends StatelessWidget {
  final String cropName, size, imagePath;
  const FarmCard({super.key, required this.cropName, required this.size, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke Halaman Monitoring
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MonitorPage(farmName: cropName)),
        );
      },
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imagePath), // LOAD DARI ASSET
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Overlay Hitam Transparan
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withValues(alpha: 0.3), 
              ),
            ),
            // Efek Arsiran Garis
            Container(
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.1, 0.1, 0.2, 0.2, 0.3, 0.3, 0.4, 0.4],
                  colors: [
                    Colors.white.withValues(alpha: 0.1), Colors.transparent,
                    Colors.white.withValues(alpha: 0.1), Colors.transparent,
                    Colors.white.withValues(alpha: 0.1), Colors.transparent,
                    Colors.white.withValues(alpha: 0.1), Colors.transparent,
                  ],
                  tileMode: TileMode.repeated,
                ),
              ),
            ),
            Center(
              child: Container(
                width: 140,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E5E3F),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFC8E6C9), width: 2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(size, style: const TextStyle(color: Colors.white, fontSize: 14)),
                        const SizedBox(width: 5),
                        const Icon(Icons.location_on, color: Colors.white, size: 16),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(cropName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}