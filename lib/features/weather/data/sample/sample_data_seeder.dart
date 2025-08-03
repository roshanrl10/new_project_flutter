// import 'package:hive/hive.dart';
// import 'package:new_project_flutter/features/weather/data/model/trekking_place_model.dart';

// class SampleDataSeeder {
//   final Box<TrekkingPlaceModel> box;

//   SampleDataSeeder(this.box);

//   Future<void> seed() async {
//     if (box.isNotEmpty) return; // Prevent duplication on restart

//     final List<TrekkingPlaceModel> places = [
//       TrekkingPlaceModel(
//         name: "Everest Base Camp",
//         latitude: 27.9881,
//         longitude: 86.9250,
//       ),
//       TrekkingPlaceModel(
//         name: "Annapurna Base Camp",
//         latitude: 28.5306,
//         longitude: 83.8780,
//       ),
//       TrekkingPlaceModel(
//         name: "Langtang Valley",
//         latitude: 28.2114,
//         longitude: 85.5567,
//       ),
//       TrekkingPlaceModel(
//         name: "Manaslu Circuit",
//         latitude: 28.5495,
//         longitude: 84.5612,
//       ),
//       TrekkingPlaceModel(
//         name: "Ghorepani Poon Hill",
//         latitude: 28.4000,
//         longitude: 83.6800, placeName: '', lat: null, lon: null,
//       ),
//     ];

//     for (final place in places) {
//       await box.add(place);
//     }
//   }
// }
