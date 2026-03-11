import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather_model.dart';
import '../models/city_model.dart';

class WeatherService {
  static String get _apiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  static String get _baseUrl => dotenv.env['OPENWEATHER_BASE_URL'] ?? 'https://api.openweathermap.org';

  // Clima actual por ciudad
  Future<Weather> getCurrentWeatherByCity(String city) async {
    final url = Uri.parse(
      '$_baseUrl/data/2.5/weather?q=$city&appid=$_apiKey&units=metric&lang=es'
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al obtener el clima: ${response.statusCode}');
  }

  // Clima actual por coordenadas
  Future<Weather> getCurrentWeatherByCoords(double lat, double lon) async {
    final url = Uri.parse(
      '$_baseUrl/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=es'
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al obtener el clima: ${response.statusCode}');
  }

  // Pronóstico 5 días por coordenadas
  Future<List<ForecastDay>> getForecast(double lat, double lon) async {
    final url = Uri.parse(
      '$_baseUrl/data/2.5/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=es'
    );
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Error al obtener pronóstico: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final List items = data['list'];

    // Agrupar por día — tomar la lectura de mediodía (12:00)
    final Map<String, ForecastDay> byDay = {};
    for (var item in items) {
      final dt = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      final key = '${dt.year}-${dt.month}-${dt.day}';
      final hour = dt.hour;

      if (!byDay.containsKey(key) || (hour - 12).abs() < (byDay[key]!.date.hour - 12).abs()) {
        byDay[key] = ForecastDay.fromJson(item);
      }
    }

    return byDay.values.take(5).toList();
  }

  // Buscar ciudades
  Future<List<City>> searchCities(String query) async {
    if (query.trim().isEmpty) return [];
    final url = Uri.parse(
      '$_baseUrl/geo/1.0/direct?q=$query&limit=5&appid=$_apiKey'
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => City.fromJson(e)).toList();
    }
    return [];
  }
}