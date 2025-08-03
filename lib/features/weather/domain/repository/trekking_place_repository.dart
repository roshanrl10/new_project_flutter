import 'package:new_project_flutter/features/weather/domain/entity/trekking_place.dart';

abstract class TrekkingPlaceRepository {
  List<TrekkingPlace> getPlaces();
}
