import '../entity/weather_entity.dart';

abstract class WeatherRepository {
  Future<WeatherEntity> getWeather(double lat, double lon);
}
