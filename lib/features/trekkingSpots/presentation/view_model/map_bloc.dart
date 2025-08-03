import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_flutter/features/trekkingSpots/domain/entity/map_place_entity.dart';
import 'package:new_project_flutter/features/trekkingSpots/domain/repository/map_repository.dart';

import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository repository;
  List<MapPlace> _allPlaces = [];

  MapBloc(this.repository) : super(MapInitial()) {
    on<LoadMapPlaces>((event, emit) async {
      emit(MapLoading());
      try {
        final places = await repository.getMapPlaces();
        _allPlaces = places;
        emit(MapLoaded(places));
      } catch (e) {
        emit(MapError(e.toString()));
      }
    });

    on<SearchMapPlace>((event, emit) {
      final filtered =
          _allPlaces
              .where(
                (place) => place.name.toLowerCase().contains(
                  event.query.toLowerCase(),
                ),
              )
              .toList();
      emit(MapLoaded(filtered));
    });

    on<SelectMapPlace>((event, emit) {
      emit(MapSelected(event.place));
    });
  }
}
