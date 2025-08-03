import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_project_flutter/features/weather/domain/entity/weather_entity.dart';
import 'package:new_project_flutter/features/weather/domain/repository/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final String _apiKey =
      '8a9368f60a4f415ff4d89bf84dd6fc0b'; // Replace with your actual API key

  @override
  Future<WeatherEntity> getWeather(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final temperature = (json['main']['temp'] as num).toDouble();
      final condition = (json['weather'][0]['description'] as String);
      final iconCode = (json['weather'][0]['icon'] as String);

      return WeatherEntity(
        temperature: temperature,
        condition: condition,
        iconCode: iconCode,
      );
    } else {
      throw Exception(
        'Failed to load weather data: ${response.statusCode} ${response.body}',
      );
    }
  }
}
