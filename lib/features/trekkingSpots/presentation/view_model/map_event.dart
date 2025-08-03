import 'package:new_project_flutter/features/trekkingSpots/domain/entity/map_place_entity.dart';

abstract class MapEvent {}

class LoadMapPlaces extends MapEvent {}

class SearchMapPlace extends MapEvent {
  final String query;
  SearchMapPlace(this.query);
}

class SelectMapPlace extends MapEvent {
  final MapPlace place;
  SelectMapPlace(this.place);
}

class FilterPlacesByDifficulty extends MapEvent {
  final String difficulty;
  FilterPlacesByDifficulty(this.difficulty);
}

class FilterPlacesByRegion extends MapEvent {
  final String region;
  FilterPlacesByRegion(this.region);
}
