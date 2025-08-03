import 'package:new_project_flutter/features/hotelBooking/domain/use_case/get_hotels.dart';
import 'package:new_project_flutter/features/hotelBooking/domain/repository/hotel_repository.dart';
import 'package:new_project_flutter/features/hotelBooking/domain/entity/booking_entity.dart';
import 'package:new_project_flutter/features/hotelBooking/presentation/view_model/hotel_booking_event.dart';
import 'package:new_project_flutter/features/hotelBooking/presentation/view_model/hotel_booking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HotelBookingBloc extends Bloc<HotelBookingEvent, HotelBookingState> {
  final GetHotels getHotels;
  final HotelRepository hotelRepository;
  List<Booking> _localBookings = []; // Store bookings locally

  HotelBookingBloc(this.getHotels, this.hotelRepository)
    : super(HotelInitial()) {
    on<FetchHotels>((event, emit) async {
      emit(HotelLoading());
      try {
        final hotels = await getHotels();
        emit(HotelLoaded(hotels));
      } catch (e) {
        emit(HotelError(e.toString()));
      }
    });

    on<FetchUserBookings>((event, emit) async {
      emit(HotelBookingLoading());
      try {
        print('🏨 Fetching hotel bookings from local state...');
        print('🏨 Found ${_localBookings.length} local bookings');
        emit(HotelBookingLoaded(_localBookings));
      } catch (e) {
        emit(HotelBookingError(e.toString()));
      }
    });

    on<BookHotel>((event, emit) async {
      print('🏨 BookHotel event triggered');
      emit(HotelBookingActionLoading());
      try {
        print('🏨 Creating booking locally...');

        // Create booking locally without backend
        final booking = Booking(
          id:
              DateTime.now().millisecondsSinceEpoch
                  .toString(), // Generate local ID
          hotelId: event.bookingData['hotel'] ?? '',
          userId: event.bookingData['user'] ?? '',
          checkInDate: DateTime.parse(event.bookingData['checkIn']),
          checkOutDate: DateTime.parse(event.bookingData['checkOut']),
          totalPrice: (event.bookingData['totalPrice'] as num).toDouble(),
          status: event.bookingData['status'] ?? 'confirmed',
          hotelName: event.bookingData['hotelName'] ?? 'Unknown Hotel',
          userName: 'Current User',
        );

        // Add to local bookings
        _localBookings.add(booking);
        print('🏨 Hotel booking added to local state');
        print('🏨 Total local bookings: ${_localBookings.length}');

        // Emit loaded state with local bookings
        print('🔄 Emitting HotelBookingLoaded state with local bookings');
        emit(HotelBookingLoaded(_localBookings));

        // Then emit success state
        print('🏨 Emitting success state');
        emit(HotelBookingSuccess('Hotel booked successfully!'));
      } catch (e) {
        print('❌ Error in BookHotel: $e');
        emit(HotelBookingError(e.toString()));
      }
    });

    on<CancelHotelBooking>((event, emit) async {
      emit(HotelBookingActionLoading());
      try {
        print('🏨 Cancelling hotel booking locally...');

        // Remove booking from local state
        _localBookings.removeWhere((booking) => booking.id == event.bookingId);
        print('🏨 Booking removed from local state');
        print('🏨 Remaining local bookings: ${_localBookings.length}');

        // Emit updated bookings
        emit(HotelBookingLoaded(_localBookings));
        emit(HotelBookingSuccess('Hotel booking cancelled successfully!'));
      } catch (e) {
        emit(HotelBookingError(e.toString()));
      }
    });

    on<SearchHotels>((event, emit) {
      // TODO: Implement search functionality
    });

    on<FilterHotelsByLocation>((event, emit) {
      // TODO: Implement location filter
    });

    on<FilterHotelsByPrice>((event, emit) {
      // TODO: Implement price filter
    });
  }
}
