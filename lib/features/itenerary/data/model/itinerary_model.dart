import 'package:hive/hive.dart';

part 'itinerary_model.g.dart';

@HiveType(typeId: 3)
class ItineraryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<String> imageUrls;

  @HiveField(3)
  final List<String> itinerarySteps;

  ItineraryModel({
    required this.id,
    required this.name,
    required this.imageUrls,
    required this.itinerarySteps,
  });
}
