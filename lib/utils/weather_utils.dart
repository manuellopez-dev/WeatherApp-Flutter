import 'package:flutter/material.dart';

class WeatherUtils {
  // Gradiente de fondo según condición
  static List<Color> getBackgroundGradient(String main, DateTime date) {
    final hour = date.hour;
    final isNight = hour < 6 || hour >= 20;

    if (isNight) {
      return [const Color(0xFF0f0c29), const Color(0xFF302b63), const Color(0xFF24243e)];
    }

    switch (main.toLowerCase()) {
      case 'clear':
        return [const Color(0xFF2980B9), const Color(0xFF6DD5FA), const Color(0xFFFFFFFF)];
      case 'clouds':
        return [const Color(0xFF4B6CB7), const Color(0xFF182848)];
      case 'rain':
      case 'drizzle':
        return [const Color(0xFF1a1a2e), const Color(0xFF16213e), const Color(0xFF0f3460)];
      case 'thunderstorm':
        return [const Color(0xFF0f0c29), const Color(0xFF302b63)];
      case 'snow':
        return [const Color(0xFFe0eafc), const Color(0xFFcfdef3)];
      case 'mist':
      case 'fog':
      case 'haze':
        return [const Color(0xFF606c88), const Color(0xFF3f4c6b)];
      default:
        return [const Color(0xFF2980B9), const Color(0xFF6DD5FA)];
    }
  }

  // Emoji según condición
  static String getWeatherEmoji(String main, DateTime date) {
    final hour = date.hour;
    final isNight = hour < 6 || hour >= 20;

    switch (main.toLowerCase()) {
      case 'clear':
        return isNight ? '🌙' : '☀️';
      case 'clouds':
        return isNight ? '☁️' : '⛅';
      case 'rain':
        return '🌧️';
      case 'drizzle':
        return '🌦️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'fog':
      case 'haze':
        return '🌫️';
      default:
        return '🌡️';
    }
  }

  // Día de la semana en español
  static String getDayName(DateTime date) {
    const days = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
    final today = DateTime.now();
    if (date.day == today.day && date.month == today.month) return 'Hoy';
    if (date.day == today.day + 1 && date.month == today.month) return 'Mañana';
    return days[date.weekday % 7];
  }

  // Formatear temperatura
  static String formatTemp(double temp) => '${temp.round()}°';
}