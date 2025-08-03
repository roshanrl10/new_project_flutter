import 'package:new_project_flutter/features/weather/domain/entity/trekking_place.dart';

abstract class WeatherEvent {}

class LoadTrekkingPlaces extends WeatherEvent {}

class SearchPlace extends WeatherEvent {
  final String query;
  SearchPlace(this.query);
}

class GetWeather extends WeatherEvent {
  final TrekkingPlace place;
  GetWeather(this.place);
}

class GetWeatherForLocation extends WeatherEvent {
  final String location;
  GetWeatherForLocation(this.location);
}
