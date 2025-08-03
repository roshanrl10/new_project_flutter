import 'package:new_project_flutter/features/weather/domain/entity/trekking_place.dart';
import 'package:new_project_flutter/features/weather/domain/repository/trekking_place_repository.dart';

class GetTrekkingPlaces {
  final TrekkingPlaceRepository repository;

  GetTrekkingPlaces(this.repository);

  List<TrekkingPlace> call() => repository.getPlaces();
}
