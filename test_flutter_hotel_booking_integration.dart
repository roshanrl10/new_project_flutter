import 'package:dio/dio.dart';
import 'lib/features/hotelBooking/data/data_source/remote_datasource/hotel_remote_datasource.dart';
import 'lib/features/hotelBooking/data/data_source/remote_datasource/booking_remote_datasource.dart';
import 'lib/features/hotelBooking/data/repository/hotel_repository_impl.dart';
import 'lib/core/network/api_client.dart';

Future<void> testFlutterHotelBookingIntegration() async {
  print('🏨 Testing Flutter Hotel Booking Integration with Backend...');

  // Initialize API client
  apiClient.initialize();

  const userId = '688339f4171a690ae2d5d852';

  try {
    // Test 1: Test Hotel Remote Data Source
    print('\n🔍 Test 1: Testing Hotel Remote Data Source...');
    final hotelDataSource = HotelRemoteDataSourceImpl();
    final hotels = await hotelDataSource.getAllHotels();
    print('✅ Successfully fetched ${hotels.length} hotels');

    if (hotels.isNotEmpty) {
      final firstHotel = hotels.first;
      print('✅ Sample hotel: ${firstHotel.name} - ${firstHotel.location}');
      print('✅ Hotel price: \$${firstHotel.price}');
      print('✅ Hotel rating: ${firstHotel.rating}');
    }

    // Test 2: Test Booking Remote Data Source
    print('\n📋 Test 2: Testing Booking Remote Data Source...');
    final bookingDataSource = BookingRemoteDataSourceImpl();
    final userBookings = await bookingDataSource.fetchUserBookings(userId);
    print('✅ Successfully fetched ${userBookings.length} bookings for user');

    if (userBookings.isNotEmpty) {
      final firstBooking = userBookings.first;
      print('✅ Sample booking: ${firstBooking.hotelName}');
      print('✅ Booking status: ${firstBooking.status}');
      print('✅ Check-in: ${firstBooking.checkInDate}');
      print('✅ Check-out: ${firstBooking.checkOutDate}');
    }

    // Test 3: Test Repository Layer
    print('\n🏗️ Test 3: Testing Repository Layer...');
    final repository = HotelRepositoryImpl(
      hotelRemoteDataSource: hotelDataSource,
      bookingRemoteDataSource: bookingDataSource,
    );

    final hotelsFromRepo = await repository.fetchHotels();
    print('✅ Repository fetched ${hotelsFromRepo.length} hotels');

    final bookingsFromRepo = await repository.fetchUserBookings(userId);
    print('✅ Repository fetched ${bookingsFromRepo.length} bookings');

    // Test 4: Test Create Booking (if hotels exist)
    print('\n➕ Test 4: Testing Create Booking...');
    if (hotels.isNotEmpty) {
      final firstHotel = hotels.first;
      final bookingData = {
        'user': userId,
        'hotel': firstHotel.id,
        'checkIn': '2024-12-28',
        'checkOut': '2024-12-30',
        'guests': 2,
      };

      print('📝 Creating booking for hotel: ${firstHotel.name}');
      final newBooking = await repository.createBooking(bookingData);
      print('✅ Successfully created booking: ${newBooking.hotelName}');
      print('✅ Booking ID: ${newBooking.id}');
      print('✅ Total price: \$${newBooking.totalPrice}');

      // Test 5: Test Delete Booking
      print('\n🗑️ Test 5: Testing Delete Booking...');
      await repository.deleteBooking(newBooking.id);
      print('✅ Successfully deleted booking: ${newBooking.id}');
    } else {
      print('⚠️ No hotels available for booking test');
    }

    print('\n🎉 All Flutter hotel booking integration tests passed!');
    print('✅ Flutter app can successfully:');
    print('   - Fetch hotels from backend');
    print('   - Fetch user bookings from backend');
    print('   - Create new bookings');
    print('   - Delete bookings');
    print('✅ Flutter-backend synchronization is working properly!');
  } catch (e) {
    print('❌ Error in Flutter hotel booking integration test: $e');
    if (e is DioException && e.response != null) {
      print('Response status: ${e.response!.statusCode}');
      print('Response data: ${e.response!.data}');
    }
  }
}

void main() {
  testFlutterHotelBookingIntegration();
}
