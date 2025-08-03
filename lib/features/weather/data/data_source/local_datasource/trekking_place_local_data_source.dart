import 'package:hive/hive.dart';
import 'package:new_project_flutter/features/weather/data/model/trekking_place_model.dart';

class TrekkingPlaceLocalDataSource {
  final box = Hive.box<TrekkingPlaceModel>('trekking_places');

  List<TrekkingPlaceModel> getTrekkingPlaces() {
    return box.values.toList();
  }

  Future<void> addPlace(TrekkingPlaceModel model) async {
    await box.add(model);
  }
}
