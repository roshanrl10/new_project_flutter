import 'package:hive/hive.dart';
import 'package:new_project_flutter/features/trekkingSpots/data/model/map_place_model.dart';

class MapLocalDataSource {
  final Box<MapPlaceModel> mapBox;

  MapLocalDataSource(this.mapBox);

  List<MapPlaceModel> getMapPlaces() {
    return mapBox.values.toList();
  }

  void savePlace(MapPlaceModel place) {
    mapBox.add(place);
  }
}
