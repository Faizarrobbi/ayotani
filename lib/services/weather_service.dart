import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  // Free Open-Meteo API
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<Map<String, dynamic>?> getCurrentWeather(double lat, double long) async {
    try {
      final url = Uri.parse('$_baseUrl?latitude=$lat&longitude=$long&current_weather=true');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}