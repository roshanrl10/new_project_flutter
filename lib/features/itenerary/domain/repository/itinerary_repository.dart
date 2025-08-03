import 'package:new_project_flutter/features/itenerary/domain/entity/itinerary_entity.dart';

abstract class ItineraryRepository {
  Future<List<ItineraryEntity>> getItineraries();
  Future<void> saveItinerary(ItineraryEntity itinerary);
}
