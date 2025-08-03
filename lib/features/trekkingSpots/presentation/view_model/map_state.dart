import 'package:new_project_flutter/features/trekkingSpots/domain/entity/map_place_entity.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final List<MapPlace> places;
  MapLoaded(this.places);
}

class MapSelected extends MapState {
  final MapPlace selectedPlace;
  MapSelected(this.selectedPlace);
}

class MapError extends MapState {
  final String message;
  MapError(this.message);
}
