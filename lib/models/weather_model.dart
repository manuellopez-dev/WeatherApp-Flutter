class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final String cityName;
  final String country;
  final DateTime date;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.cityName,
    required this.country,
    required this.date,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id:          json['weather'][0]['id'],
      main:        json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      icon:        json['weather'][0]['icon'],
      temp:        (json['main']['temp'] as num).toDouble(),
      feelsLike:   (json['main']['feels_like'] as num).toDouble(),
      tempMin:     (json['main']['temp_min'] as num).toDouble(),
      tempMax:     (json['main']['temp_max'] as num).toDouble(),
      humidity:    json['main']['humidity'],
      pressure:    json['main']['pressure'],
      windSpeed:   (json['wind']['speed'] as num).toDouble(),
      cityName:    json['name'] ?? '',
      country:     json['sys']['country'] ?? '',
      date:        DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }
}

class ForecastDay {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String main;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;

  ForecastDay({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.main,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date:        DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      tempMin:     (json['main']['temp_min'] as num).toDouble(),
      tempMax:     (json['main']['temp_max'] as num).toDouble(),
      main:        json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      icon:        json['weather'][0]['icon'],
      humidity:    json['main']['humidity'],
      windSpeed:   (json['wind']['speed'] as num).toDouble(),
    );
  }
}