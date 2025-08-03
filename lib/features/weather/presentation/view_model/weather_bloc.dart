import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_flutter/features/weather/data/model/trekking_place_model.dart';
import 'package:new_project_flutter/features/weather/domain/repository/weather_repository.dart';

import 'weather_event.dart';
import 'weather_state.dart';

import 'package:hive/hive.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;
  final Box<TrekkingPlaceModel> placeBox;

  WeatherBloc(this.repository, this.placeBox) : super(WeatherInitial()) {
    on<LoadTrekkingPlaces>((event, emit) {
      emit(PlacesLoaded(placeBox.values.toList()));
    });

    on<SearchPlace>((event, emit) {
      final filtered =
          placeBox.values
              .where(
                (place) => place.placeName.toLowerCase().contains(
                  event.query.toLowerCase(),
                ),
              )
              .toList();
      emit(PlacesLoaded(filtered));
    });

    on<GetWeather>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await repository.getWeather(
          event.place.latitude,
          event.place.longitude,
        );
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError("Failed to fetch weather"));
      }
    });
  }
}
