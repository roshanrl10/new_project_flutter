class WeatherEntity {
  final double temperature;
  final String condition;
  final String iconCode;

  WeatherEntity({
    required this.temperature,
    required this.condition,
    required this.iconCode,
  });

  String get iconUrl => 'http://openweathermap.org/img/wn/$iconCode@2x.png';
}
