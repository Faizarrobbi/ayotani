import 'package:flutter/material.dart';

class MonitorPage extends StatefulWidget {
  final String farmName;
  const MonitorPage({super.key, required this.farmName});

  @override
  State<MonitorPage> createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  // State untuk Tab yang dipilih (Default: Monitoring)
  String selectedTab = "Monitoring";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER MAP (Gambar Satelit Besar)
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      // Gambar Satelit Lahan (Ganti sesuai kebutuhan)
                      image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Aerial_view_of_agricultural_fields_in_California.jpg/800px-Aerial_view_of_agricultural_fields_in_California.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Overlay Garis Arsiran (Opsional, biar mirip desain)
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                  ),
                ),
                // Tombol Back
                Positioned(
                  top: 50,
                  left: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                // Label Tengah (Nama Lahan)
                Positioned(
                  top: 100, left: 0, right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E5E3F),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFC8E6C9), width: 2),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text("12 ha", style: TextStyle(color: Colors.white, fontSize: 12)),
                              SizedBox(width: 5),
                              Icon(Icons.location_on, color: Colors.white, size: 14),
                            ],
                          ),
                          Text(widget.farmName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 2. INFO GRID (4 Kotak Status)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildInfoCard("Kesehatan Tanaman", "Baik", isGood: true),
                      const SizedBox(width: 15),
                      _buildInfoCard("Tanggal Tanam", "08/02/2025"),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _buildInfoCard("Modal", "Rp. 16jt -10%"),
                      const SizedBox(width: 15),
                      _buildInfoCard("Waktu Panen", "~4 Bulan"),
                    ],
                  ),
                ],
              ),
            ),

            // 3. TAB MENU (Monitoring, Tugas, Integrasi, Setting)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildTabButton("Monitoring"),
                  const SizedBox(width: 10),
                  _buildTabButton("Tugas"), // Warna Hijau Gelap
                  const SizedBox(width: 10),
                  _buildTabButton("Integrasi"),
                  const SizedBox(width: 10),
                  _buildTabButton("Setting"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 4. KONTEN DINAMIS (Berubah sesuai Tab)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: selectedTab == "Monitoring" 
                  ? _buildMonitoringContent() 
                  : _buildTugasContent(),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  // Card Info Kecil (Kesehatan, Modal, dll)
  Widget _buildInfoCard(String title, String value, {bool isGood = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 16,
                  color: isGood ? Colors.green : Colors.black
                )),
                if (title == "Kesehatan Tanaman" || title == "Modal")
                  const Icon(Icons.chevron_right, size: 18, color: Colors.grey)
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Tombol Tab (Pindah Menu)
  Widget _buildTabButton(String label) {
    bool isActive = selectedTab == label;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E5E3F) : const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Konten Tab: MONITORING (Cuaca & Tips)
  Widget _buildMonitoringContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Cuaca", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text("Selengkapnya >", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9), // Hijau muda banget
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Column(
                children: const [
                  Icon(Icons.wb_sunny, color: Colors.orange, size: 40),
                  SizedBox(height: 5),
                  Text("24°", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text("Hari ini", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Tips", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E5E3F))),
                    SizedBox(height: 5),
                    Text(
                      "Sirami tanaman tomat anda dengan merata dan teratur. Usahakan agar tanah selalu lembab.",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  // Konten Tab: TUGAS (Progress & List)
  Widget _buildTugasContent() {
    return Column(
      children: [
        // Progress Bar & Next Task
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10)],
          ),
          child: Row(
            children: [
              // Lingkaran Progress (Manual tanpa package tambahan biar ga error)
              SizedBox(
                height: 70, width: 70,
                child: Stack(
                  children: [
                    const Center(child: CircularProgressIndicator(value: 0.8, color: Color(0xFF1E5E3F), strokeWidth: 8)),
                    Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("80%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("Selesai", style: TextStyle(fontSize: 8, color: Colors.grey)),
                      ],
                    ))
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Tugas Selanjutnya", style: TextStyle(color: Color(0xFF1E5E3F), fontWeight: FontWeight.bold)),
                        Text("Hari ini, 12:00", style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text("Menyiapkan irigasi ke sawah dan memberi pupuk", style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.grey),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Lihat Semua Tugas >"),
          ),
        )
      ],
    );
  }
}