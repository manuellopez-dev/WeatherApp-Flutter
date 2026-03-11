import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/weather_utils.dart';

class ForecastCard extends StatelessWidget {
  final List<ForecastDay> forecast;

  const ForecastCard({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.white54, size: 13),
              SizedBox(width: 6),
              Text(
                'PRONÓSTICO 5 DÍAS',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...forecast.map((day) => _ForecastRow(day: day)),
        ],
      ),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  final ForecastDay day;

  const _ForecastRow({required this.day});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(
              WeatherUtils.getDayName(day.date),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            WeatherUtils.getWeatherEmoji(day.main, day.date),
            style: const TextStyle(fontSize: 18),
          ),
          const Spacer(),
          Text(
            WeatherUtils.formatTemp(day.tempMin),
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(width: 8),
          _TempBar(min: day.tempMin, max: day.tempMax),
          const SizedBox(width: 8),
          SizedBox(
            width: 34,
            child: Text(
              WeatherUtils.formatTemp(day.tempMax),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _TempBar extends StatelessWidget {
  final double min;
  final double max;

  const _TempBar({required this.min, required this.max});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.orange.shade300],
        ),
      ),
    );
  }
}