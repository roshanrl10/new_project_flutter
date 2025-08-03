// lib/features/hotelBooking/domain/repositories/hotel_repository.dart
import 'package:new_project_flutter/features/hotelBooking/domain/entity/hotel_entity.dart';
import 'package:new_project_flutter/features/hotelBooking/domain/entity/booking_entity.dart';

abstract class HotelRepository {
  Future<List<Hotel>> fetchHotels();
  Future<Hotel> createHotel(Map<String, dynamic> hotelData);
  Future<List<Booking>> fetchUserBookings(String userId);
  Future<Booking> createBooking(Map<String, dynamic> bookingData);
  Future<void> deleteBooking(String bookingId);
}
