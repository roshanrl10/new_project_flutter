import '../../../../../core/network/api_service.dart';
import '../../../../../app/constant/api_endpoints.dart';
import '../../model/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<List<BookingModel>> fetchUserBookings(String userId);
  Future<BookingModel> createBooking(Map<String, dynamic> bookingData);
  Future<void> deleteBooking(String bookingId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiService _apiService = ApiService();

  @override
  Future<List<BookingModel>> fetchUserBookings(String userId) async {
    try {
      print('🔍 Fetching user bookings for userId: $userId');
      print(
        '🔍 URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.getUserBookings}?userId=$userId',
      );

      final response = await _apiService.get(
        ApiEndpoints.getUserBookings,
        queryParameters: {'userId': userId},
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> bookings = responseData['bookings'] ?? [];

        print('🏨 Found ${bookings.length} bookings');
        print('🏨 Bookings data: $bookings');

        final bookingModels =
            bookings.map((json) {
              print('🏨 Processing booking: $json');
              try {
                final booking = BookingModel.fromJson(json);
                print('✅ Successfully created booking: ${booking.hotelName}');
                print(
                  '✅ Booking details: ID=${booking.id}, Hotel=${booking.hotelName}, Status=${booking.status}',
                );
                return booking;
              } catch (e) {
                print('❌ Error creating booking from JSON: $e');
                print('❌ JSON data: $json');
                rethrow;
              }
            }).toList();

        print('✅ Successfully created ${bookingModels.length} booking models');
        return bookingModels;
      } else {
        print(
          '❌ HTTP Error: ${response.statusCode} - ${response.statusMessage}',
        );
        throw Exception(
          'Failed to fetch user bookings: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('💥 Exception in fetchUserBookings: $e');
      print('💥 Exception type: ${e.runtimeType}');
      throw Exception('Failed to fetch user bookings: $e');
    }
  }

  @override
  Future<BookingModel> createBooking(Map<String, dynamic> bookingData) async {
    try {
      print('🔍 Creating booking with data: $bookingData');
      print('🔍 User ID type: ${bookingData['user']?.runtimeType}');
      print('🔍 User ID value: ${bookingData['user']}');
      print('🔍 Hotel ID: ${bookingData['hotel']}');
      print('🔍 Check-in: ${bookingData['checkIn']}');
      print('🔍 Check-out: ${bookingData['checkOut']}');
      print('🔍 Guests: ${bookingData['guests']}');
      print('🔍 API Endpoint: ${ApiEndpoints.createBooking}');
      print(
        '🔍 Full URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.createBooking}',
      );

      // Validate user ID
      if (bookingData['user'] == null ||
          bookingData['user'].toString().isEmpty) {
        throw Exception('User ID is required and cannot be null or empty');
      }

      final response = await _apiService.post(
        ApiEndpoints.createBooking,
        data: bookingData,
      );

      print('📡 Create booking response status: ${response.statusCode}');
      print('📡 Create booking response data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final booking = BookingModel.fromJson(
          responseData['booking'] ?? responseData,
        );
        print('✅ Successfully created booking: ${booking.hotelName}');
        return booking;
      } else {
        print(
          '❌ HTTP Error: ${response.statusCode} - ${response.statusMessage}',
        );
        throw Exception('Failed to create booking: ${response.statusMessage}');
      }
    } catch (e) {
      print('💥 Exception in createBooking: $e');
      throw Exception('Failed to create booking: $e');
    }
  }

  @override
  Future<void> deleteBooking(String bookingId) async {
    try {
      print('🔍 Deleting booking with ID: $bookingId');

      final response = await _apiService.delete(
        '${ApiEndpoints.deleteBooking}/$bookingId',
      );

      print('📡 Delete booking response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Successfully deleted booking: $bookingId');
      } else {
        print(
          '❌ HTTP Error: ${response.statusCode} - ${response.statusMessage}',
        );
        throw Exception('Failed to delete booking: ${response.statusMessage}');
      }
    } catch (e) {
      print('💥 Exception in deleteBooking: $e');
      throw Exception('Failed to delete booking: $e');
    }
  }
}
