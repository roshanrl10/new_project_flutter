import 'package:new_project_flutter/features/hotelBooking/data/data_source/local_datasource/hotel_remote_datasource.dart';
import 'package:new_project_flutter/features/hotelBooking/domain/entity/hotel_entity.dart';
import 'package:new_project_flutter/features/hotelBooking/domain/entity/booking_entity.dart';
import 'package:new_project_flutter/features/hotelBooking/domain/repository/hotel_repository.dart';

class HotelRepositoryImpl implements HotelRepository {
  final HotelRemoteDataSource remoteDataSource;

  HotelRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Hotel>> fetchHotels() async {
    final models = await remoteDataSource.fetchHotels(); // List<HotelModel>
    return models.map((model) => model.toEntity()).toList(); // List<Hotel>
  }

  @override
  Future<Hotel> createHotel(Map<String, dynamic> hotelData) async {
    // Local implementation doesn't support creating hotels
    throw UnimplementedError(
      'Create hotel not supported in local implementation',
    );
  }

  @override
  Future<List<Booking>> fetchUserBookings(String userId) async {
    // Local implementation doesn't support user bookings
    throw UnimplementedError(
      'User bookings not supported in local implementation',
    );
  }

  @override
  Future<Booking> createBooking(Map<String, dynamic> bookingData) async {
    // Local implementation doesn't support creating bookings
    throw UnimplementedError(
      'Create booking not supported in local implementation',
    );
  }

  @override
  Future<void> deleteBooking(String bookingId) async {
    // Local implementation doesn't support deleting bookings
    throw UnimplementedError(
      'Delete booking not supported in local implementation',
    );
  }
}
