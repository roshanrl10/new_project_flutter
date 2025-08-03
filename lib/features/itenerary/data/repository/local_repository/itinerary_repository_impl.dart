import 'package:new_project_flutter/features/itenerary/data/data_source/local_datasource/itinerary_local_datasource.dart';
import 'package:new_project_flutter/features/itenerary/domain/entity/itinerary_entity.dart';
import 'package:new_project_flutter/features/itenerary/domain/repository/itinerary_repository.dart';

class ItineraryRepositoryImpl implements ItineraryRepository {
  final ItineraryLocalDataSource localDataSource;

  ItineraryRepositoryImpl(this.localDataSource);

  @override
  Future<List<ItineraryEntity>> getItineraries() async {
    final models = await localDataSource.getItineraries();
    return models.map((e) => ItineraryEntity.fromModel(e)).toList();
  }

  @override
  Future<void> saveItinerary(ItineraryEntity itinerary) {
    final model = ItineraryEntity.toModel(itinerary);
    return localDataSource.saveItinerary(model);
  }
}
