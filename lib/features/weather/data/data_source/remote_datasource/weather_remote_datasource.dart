// import 'package:dio/dio.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../app/constant/api_endpoints.dart';
import '../../model/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather(double lat, double lon);
  Future<WeatherModel> getWeatherForecast(double lat, double lon);
  Future<WeatherModel> getMockWeatherData();
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final ApiService _apiService = ApiService();

  @override
  Future<WeatherModel> getCurrentWeather(double lat, double lon) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.currentWeather,
        queryParameters: {'lat': lat, 'lon': lon},
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to fetch current weather: ${response.statusMessage}',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch current weather: $e');
    }
  }

  @override
  Future<WeatherModel> getWeatherForecast(double lat, double lon) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.weatherForecast,
        queryParameters: {'lat': lat, 'lon': lon},
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to fetch weather forecast: ${response.statusMessage}',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch weather forecast: $e');
    }
  }

  @override
  Future<WeatherModel> getMockWeatherData() async {
    try {
      final response = await _apiService.get(ApiEndpoints.mockWeather);

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to fetch mock weather: ${response.statusMessage}',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch mock weather: $e');
    }
  }
}
