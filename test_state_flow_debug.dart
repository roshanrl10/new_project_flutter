import 'package:dio/dio.dart';
import 'lib/features/hotelBooking/data/model/booking_model.dart';
import 'lib/features/hotelBooking/data/data_source/remote_datasource/booking_remote_datasource.dart';
import 'lib/features/hotelBooking/data/repository/hotel_repository_impl.dart';
import 'lib/features/hotelBooking/domain/use_case/get_hotels.dart';
import 'lib/features/hotelBooking/presentation/view_model/hotel_booking_bloc.dart';
import 'lib/features/hotelBooking/presentation/view_model/hotel_booking_event.dart';
import 'lib/features/hotelBooking/presentation/view_model/hotel_booking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  print('🧪 Testing HotelBookingBloc state flow...');

  // Initialize dependencies
  final dio = Dio();
  final bookingRemoteDataSource = BookingRemoteDataSource(dio);
  final hotelRepository = HotelRepositoryImpl(bookingRemoteDataSource);
  final getHotels = GetHotels(hotelRepository);

  // Create bloc
  final bloc = HotelBookingBloc(getHotels, hotelRepository);

  // Listen to state changes
  bloc.stream.listen((state) {
    print('🔄 State changed: ${state.runtimeType}');
    if (state is HotelBookingLoaded) {
      print('📊 HotelBookingLoaded - Found ${state.bookings.length} bookings');
      for (var booking in state.bookings) {
        print('  - ${booking.hotelName} (${booking.status})');
      }
    } else if (state is HotelBookingSuccess) {
      print('✅ HotelBookingSuccess: ${state.message}');
    } else if (state is HotelBookingError) {
      print('❌ HotelBookingError: ${state.message}');
    }
  });

  try {
    // Test 1: Fetch existing bookings
    print('\n🧪 Test 1: Fetching existing bookings...');
    bloc.add(FetchUserBookings('688339f4171a690ae2d5d852'));

    // Wait for state to settle
    await Future.delayed(Duration(seconds: 2));

    // Test 2: Create a new booking
    print('\n🧪 Test 2: Creating a new booking...');
    final bookingData = {
      'hotel': '688339f4171a690ae2d5d852', // Use a valid hotel ID
      'user': '688339f4171a690ae2d5d852',
      'checkIn': '2024-12-25',
      'checkOut': '2024-12-27',
      'guests': 2,
    };

    bloc.add(BookHotel(bookingData));

    // Wait for the booking process to complete
    await Future.delayed(Duration(seconds: 5));

    // Test 3: Fetch bookings again to verify the new booking appears
    print('\n🧪 Test 3: Fetching bookings again...');
    bloc.add(FetchUserBookings('688339f4171a690ae2d5d852'));

    await Future.delayed(Duration(seconds: 3));

    print('\n✅ State flow test completed');
  } catch (e) {
    print('❌ Error during state flow test: $e');
  }
}
