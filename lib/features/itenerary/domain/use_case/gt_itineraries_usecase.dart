import 'package:new_project_flutter/features/itenerary/domain/entity/itinerary_entity.dart';
import 'package:new_project_flutter/features/itenerary/domain/repository/itinerary_repository.dart';

class GetItineraries {
  final ItineraryRepository repository;

  GetItineraries(this.repository);

  Future<List<ItineraryEntity>> call() {
    return repository.getItineraries();
  }
}
