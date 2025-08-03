import 'package:new_project_flutter/features/trekkingSpots/data/data_source/local_datasource/map_local_data_source.dart';
import 'package:new_project_flutter/features/trekkingSpots/domain/entity/map_place_entity.dart';
import 'package:new_project_flutter/features/trekkingSpots/domain/repository/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  final MapLocalDataSource localDataSource;

  MapRepositoryImpl(this.localDataSource);

  @override
  Future<List<MapPlace>> getMapPlaces() async {
    return localDataSource.getMapPlaces();
  }
}
