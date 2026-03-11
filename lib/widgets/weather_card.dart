import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/weather_utils.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // Emoji grande
          Text(
            WeatherUtils.getWeatherEmoji(weather.main, weather.date),
            style: const TextStyle(fontSize: 120),
          ),

          const SizedBox(height: 8),

          // Temperatura grande
          Text(
            WeatherUtils.formatTemp(weather.temp),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 90,
              fontWeight: FontWeight.w100,
              height: 1,
            ),
          ),

          const SizedBox(height: 8),

          // Descripción
          // Descripción
Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.25),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.white.withOpacity(0.3)),
  ),
  child: Text(
    weather.description.toUpperCase(),
    style: const TextStyle(
      color: Colors.white,
      fontSize: 12,
      letterSpacing: 2,
      fontWeight: FontWeight.w600,
    ),
  ),
),

          const SizedBox(height: 12),

          // Ciudad
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.white60, size: 16),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${weather.cityName}, ${weather.country}',
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Sensación térmica
          Text(
            'Sensación ${WeatherUtils.formatTemp(weather.feelsLike)}  •  Máx ${WeatherUtils.formatTemp(weather.tempMax)}  Mín ${WeatherUtils.formatTemp(weather.tempMin)}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.45),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 28),

          // Stats row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(icon: '💧', label: 'Humedad', value: '${weather.humidity}%'),
                _Divider(),
                _StatItem(icon: '💨', label: 'Viento', value: '${weather.windSpeed.round()} m/s'),
                _Divider(),
                _StatItem(icon: '🌡️', label: 'Presión', value: '${weather.pressure} hPa'),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _StatItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: Colors.white.withOpacity(0.12));
  }
}