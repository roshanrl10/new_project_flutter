import 'package:new_project_flutter/features/itenerary/domain/entity/itinerary_entity.dart';

abstract class ItineraryEvent {}

class LoadItinerariesEvent extends ItineraryEvent {}

class SaveItineraryEvent extends ItineraryEvent {
  final ItineraryEntity itinerary;
  SaveItineraryEvent(this.itinerary);
}

class SearchItineraryEvent extends ItineraryEvent {
  final String query;
  SearchItineraryEvent(this.query);
}
