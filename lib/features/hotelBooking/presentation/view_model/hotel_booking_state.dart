import 'package:new_project_flutter/features/hotelBooking/domain/entity/hotel_entity.dart';
import 'package:new_project_flutter/features/hotelBooking/domain/entity/booking_entity.dart';

abstract class HotelBookingState {}

class HotelInitial extends HotelBookingState {}

class HotelLoading extends HotelBookingState {}

class HotelLoaded extends HotelBookingState {
  final List<Hotel> hotels;

  HotelLoaded(this.hotels);
}

class HotelError extends HotelBookingState {
  final String message;

  HotelError(this.message);
}

// User Booking States
class HotelBookingLoading extends HotelBookingState {}

class HotelBookingLoaded extends HotelBookingState {
  final List<Booking> bookings;

  HotelBookingLoaded(this.bookings);
}

class HotelBookingError extends HotelBookingState {
  final String message;

  HotelBookingError(this.message);
}

// Booking Action States
class HotelBookingSuccess extends HotelBookingState {
  final String message;
  HotelBookingSuccess(this.message);
}

class HotelBookingActionLoading extends HotelBookingState {}

class HotelBookingCancelled extends HotelBookingState {
  final String message;
  HotelBookingCancelled(this.message);
}
