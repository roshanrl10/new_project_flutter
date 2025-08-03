import 'package:new_project_flutter/features/itenerary/domain/entity/itinerary_entity.dart';

abstract class ItineraryState {}

class ItineraryInitial extends ItineraryState {}

class ItineraryLoading extends ItineraryState {}

class ItineraryLoaded extends ItineraryState {
  final List<ItineraryEntity> itineraries;
  ItineraryLoaded(this.itineraries);
}

class ItineraryError extends ItineraryState {
  final String message;
  ItineraryError(this.message);
}
