import '../../data/model/itinerary_model.dart';

class ItineraryEntity {
  final String id;
  final String name;
  final List<String> imageUrls;
  final List<String> itinerarySteps;

  ItineraryEntity({
    required this.id,
    required this.name,
    required this.imageUrls,
    required this.itinerarySteps,
  });

  factory ItineraryEntity.fromModel(ItineraryModel model) => ItineraryEntity(
    id: model.id,
    name: model.name,
    imageUrls: model.imageUrls,
    itinerarySteps: model.itinerarySteps,
  );

  static ItineraryModel toModel(ItineraryEntity entity) => ItineraryModel(
    id: entity.id,
    name: entity.name,
    imageUrls: entity.imageUrls,
    itinerarySteps: entity.itinerarySteps,
  );
}
