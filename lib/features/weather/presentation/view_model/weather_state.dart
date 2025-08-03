import 'package:new_project_flutter/features/weather/data/model/trekking_place_model.dart';
import 'package:new_project_flutter/features/weather/domain/entity/weather_entity.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherEntity weather;

  WeatherLoaded(this.weather);
}

class PlacesLoaded extends WeatherState {
  final List<TrekkingPlaceModel> places;

  PlacesLoaded(this.places);
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError(this.message);
}
