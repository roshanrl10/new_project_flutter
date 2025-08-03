import 'package:hive/hive.dart';
import '../../model/itinerary_model.dart';

abstract class ItineraryLocalDataSource {
  Future<List<ItineraryModel>> getItineraries();
  Future<void> saveItinerary(ItineraryModel itinerary);
  Future<void> deleteItinerary(String id);
}

class ItineraryLocalDataSourceImpl implements ItineraryLocalDataSource {
  final Box<ItineraryModel> itineraryBox;

  ItineraryLocalDataSourceImpl(this.itineraryBox);

  @override
  Future<List<ItineraryModel>> getItineraries() async {
    return itineraryBox.values.toList();
  }

  @override
  Future<void> saveItinerary(ItineraryModel itinerary) async {
    await itineraryBox.put(itinerary.id, itinerary);
  }

  @override
  Future<void> deleteItinerary(String id) async {
    await itineraryBox.delete(id);
  }
}
