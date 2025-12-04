import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; 
import 'package:http/http.dart' as http; 
import 'dart:convert'; 

class WeatherCard extends StatefulWidget {
  const WeatherCard({super.key});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  String temp = "24°";
  String desc = "Hari ini cukup cerah";
  String humidity = "77%";
  String wind = "6 m/s";
  String rain = "10%"; 
  bool isLoading = true; 

  // Masukkan API Key nanti disini
  final String apiKey = "MASUKKAN_API_KEY_DISINI"; 

  @override
  void initState() {
    super.initState();
    _getWeather();
  }

  Future<void> _getWeather() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => isLoading = false);
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      if (apiKey == "MASUKKAN_API_KEY_DISINI") throw Exception("No API Key");

      final url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric&lang=id');
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          temp = "${data['main']['temp'].round()}°";
          desc = data['weather'][0]['description'];
          humidity = "${data['main']['humidity']}%";
          wind = "${data['wind']['speed']} m/s";
          isLoading = false;
        });
      } else {
        throw Exception("Gagal ambil data");
      }
    } catch (e) {
      print("Error Cuaca: $e"); 
      setState(() => isLoading = false); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage("assets/img/weather_bg.jpg"),
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {},
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ]
      ),
      child: Stack(
        children: [
          // Overlay Gelap agar tulisan terbaca
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withValues(alpha: 0.1), Colors.black.withValues(alpha: 0.5)],
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 50),
                    const SizedBox(width: 15),
                    Expanded( 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(temp, style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text(
                            desc[0].toUpperCase() + desc.substring(1), 
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statItem(humidity, "Kelembapan"),
                      _statItem(rain, "Hujan"),
                      _statItem(wind, "Angin"),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}