import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/iot_reading_model.dart';
import '../../models/land_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/iot_service.dart';
import '../../services/land_service.dart';
import '../../services/weather_service.dart';
import '../../theme/app_colors.dart';
import 'add_land_screen.dart';
import '../../widgets/land_summary_stats.dart';
import '../../widgets/pending_tasks_widget.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> with SingleTickerProviderStateMixin {
  final _iotService = IotService();
  final _landService = LandService();
  final _weatherService = WeatherService();

  late TabController _tabController;
  
  Land? _selectedLand;
  List<Land> _userLands = [];
  Map<String, dynamic>? _weatherData;
  List<IotReading> _iotHistory = [];
  
  bool _isLoading = true;
  final int _selectedDayIndex = 2; 

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() => setState(() {}));
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userId = auth.userProfile?.id;

    if (userId != null) {
      _userLands = await _landService.getUserLands(userId);
      if (_userLands.isNotEmpty && _selectedLand == null) {
        _selectedLand = _userLands.first;
      }
      if (_userLands.isNotEmpty) {
         _iotHistory = await _iotService.getReadingHistory(userId);
      }
    } else {
      // Demo Mode
      _selectedLand = _landService.getDemoLand();
      var demo = await _iotService.getDemoReading('guest');
      _iotHistory = [demo, demo, demo, demo, demo, demo, demo]; 
    }

    _weatherData = await _weatherService.getCurrentWeather(-7.2504, 112.7688);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.green)));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          // MAIN SCROLLABLE CONTENT
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Stack (Map + Overlapping Card)
                // This ensures the card scrolls WITH the page
                Stack(
                  clipBehavior: Clip.none, // Allow card to hang off bottom
                  alignment: Alignment.bottomCenter,
                  children: [
                    _buildMapHeader(),
                    Positioned(
                      bottom: -40, // Hangs 40px over the edge
                      left: 16,
                      right: 16,
                      child: _buildLandSelector(),
                    ),
                  ],
                ),
                
                const SizedBox(height: 60), // Spacer for the overlapping card
                
                // 2. Summary Stats
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const LandSummaryStats(), 
                ),
                
                const SizedBox(height: 24),
                
                // 3. Tabs
                Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildTabButton('Monitoring', 0),
                      _buildTabButton('Tugas', 1),
                      _buildTabButton('Integrasi', 2),
                      _buildTabButton('Setting', 3),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                _buildTabContent(),
                
                const SizedBox(height: 100),
              ],
            ),
          ),
          
          // Back Button (Fixed on screen)
          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddLandScreen()));
          if (result == true) _loadData();
        },
        backgroundColor: AppColors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildMapHeader() {
    return Container(
      height: 280, // Increased height slightly
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://api.mapbox.com/styles/v1/mapbox/satellite-v9/static/112.7688,-7.2504,15,0/600x400?access_token=pk.eyJ1IjoiZGVtb3VzZXIiLCJhIjoiY2w4Z3M5bHMyMDJmMQN1b3h5b3MifQ.placeholder'), 
          fit: BoxFit.cover,
        ),
        color: Colors.grey,
      ),
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 40),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFF0A3D2F), borderRadius: BorderRadius.circular(4)),
                child: Column(
                  children: [
                    Text('${_selectedLand?.areaSize ?? 0} ha', style: const TextStyle(color: Colors.white, fontSize: 10)),
                    Text(_selectedLand?.plantType ?? 'Tanaman', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLandSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Land>(
          value: _userLands.contains(_selectedLand) ? _selectedLand : null,
          isExpanded: true,
          hint: const Text("Pilih Lahan"),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: _userLands.map((Land land) {
            return DropdownMenuItem<Land>(
              value: land,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(land.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                  Text(land.location ?? 'Lokasi tidak ada', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            );
          }).toList(),
          onChanged: (Land? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedLand = newValue;
              });
              // Ideally trigger a re-fetch of IOT data for this specific land ID here
            }
          },
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    bool isSelected = _tabController.index == index;
    return GestureDetector(
      onTap: () => _tabController.animateTo(index),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0A3D2F) : const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text, 
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black, 
              fontWeight: FontWeight.bold,
              fontSize: 13
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_tabController.index) {
      case 0: return _buildMonitoringTab();
      case 1: return _buildTasksTab();
      case 2: return const Center(child: Padding(padding: EdgeInsets.all(32), child: Text("Integrasi API coming soon")));
      case 3: return const Center(child: Padding(padding: EdgeInsets.all(32), child: Text("Settings coming soon")));
      default: return _buildMonitoringTab();
    }
  }

  // --- TAB 1: MONITORING ---
  Widget _buildMonitoringTab() {
    final temp = _weatherData?['current_weather']?['temperature'] ?? 24;
    
    final waterHistory = _iotHistory.map((e) => e.waterLevel ?? 0.0).toList();
    final growthHistory = _iotHistory.map((e) => e.plantGrowth ?? 0.0).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Cuaca', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
                child: const Text('Selengkapnya >', style: TextStyle(fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.white, Colors.green[50]!]),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green[100]!),
              boxShadow: [BoxShadow(color: Colors.green.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    const Icon(Icons.wb_sunny_rounded, color: Colors.orange, size: 36),
                    const SizedBox(height: 8),
                    Text('$temp°', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    const Text('Hari ini', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                Container(width: 1, height: 50, color: Colors.grey[300], margin: const EdgeInsets.symmetric(horizontal: 20)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tips', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(
                        'Sirami tanaman tomat anda dengan merata dan teratur.',
                        style: TextStyle(fontSize: 11, color: Colors.grey[700], height: 1.4),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          const Text('Grafik Lahan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          
          _buildWaterChart(waterHistory),
          const SizedBox(height: 16),
          
          _buildGrowthChart(growthHistory),
        ],
      ),
    );
  }

  // --- TAB 2: TASKS ---
  Widget _buildTasksTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const PendingTasksWidget(),
          
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Maret', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Icon(Icons.calendar_month),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    int day = 17 + index;
                    bool isSelected = index == 2; 
                    return Column(
                      children: [
                        Text(['Min', 'Sen', 'Sel', 'Rab', 'Kam'][index], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        const SizedBox(height: 8),
                        Text('$day', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isSelected ? AppColors.green : Colors.black)),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterChart(List<double> data) {
    if (data.isEmpty) data = [0,0,0,0,0,0,0];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.water_drop_outlined, color: Colors.grey),
              SizedBox(width: 8),
              Text('Air Level (History)', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(data.length, (index) {
              double value = data[index];
              double height = (value / 100 * 80).clamp(10.0, 80.0); 
              bool isLatest = index == data.length - 1;
              
              return Column(
                children: [
                  Container(
                    width: 25,
                    height: height,
                    decoration: BoxDecoration(
                      color: isLatest ? const Color(0xFF2D6A4F) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('${index + 1}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthChart(List<double> data) {
    if (data.isEmpty) data = [0,0,0,0,0,0,0];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bar_chart, color: Colors.grey),
              SizedBox(width: 8),
              Text('Pertumbuhan (cm)', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: CustomPaint(
              painter: GrowthChartPainter(data),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}';
  }
}

class GrowthChartPainter extends CustomPainter {
  final List<double> data;
  GrowthChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE8F5E9)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    double stepY = size.height / 4;
    for (int i = 0; i <= 4; i++) {
      double y = stepY * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint..style = PaintingStyle.stroke..strokeWidth = 0.5..color = Colors.grey[200]!);
    }

    if (data.isEmpty) return;

    final path = Path();
    double stepX = size.width / (data.length - 1);
    
    path.moveTo(0, size.height - (data[0] * 5)); 

    for (int i = 1; i < data.length; i++) {
      double x = i * stepX;
      double y = size.height - (data[i] * 5); 
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
    
    final strokePath = Path();
    strokePath.moveTo(0, size.height - (data[0] * 5));
    for (int i = 1; i < data.length; i++) {
      strokePath.lineTo(i * stepX, size.height - (data[i] * 5));
    }
    canvas.drawPath(strokePath, Paint()..color = AppColors.green..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}