// lib/features/hotelBooking/domain/usecases/get_hotels.dart
import 'package:new_project_flutter/features/hotelBooking/domain/entity/hotel_entity.dart';
import 'package:new_project_flutter/features/hotelBooking/domain/repository/hotel_repository.dart';
// import 'package:new_project_flutter/features/hotelBooking/domain/repositories/hotel_repository.dart';

class GetHotels {
  final HotelRepository repository;

  GetHotels(this.repository);

  Future<List<Hotel>> call() async {
    return repository.fetchHotels(); // ✅ Corrected method name
  }
}
