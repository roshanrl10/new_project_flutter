import 'package:new_project_flutter/features/trekkingSpots/domain/entity/map_place_entity.dart';

abstract class MapRepository {
  Future<List<MapPlace>> getMapPlaces();
}
