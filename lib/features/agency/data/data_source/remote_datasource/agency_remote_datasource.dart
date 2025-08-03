import '../../../../../core/network/api_service.dart';
import '../../../../../app/constant/api_endpoints.dart';
import '../../model/agency_model.dart';
import '../../model/agency_booking_model.dart';

abstract class AgencyRemoteDataSource {
  Future<List<AgencyModel>> fetchAgencies();
  Future<AgencyModel> createAgency(Map<String, dynamic> agencyData);
  Future<List<AgencyBookingModel>> fetchAgencyBookings();
  Future<List<AgencyBookingModel>> fetchUserAgencyBookings(String userId);
  Future<AgencyBookingModel> createAgencyBooking(
    Map<String, dynamic> bookingData,
  );
  Future<void> deleteAgencyBooking(String bookingId);
}

class AgencyRemoteDataSourceImpl implements AgencyRemoteDataSource {
  final ApiService _apiService = ApiService();

  @override
  Future<List<AgencyModel>> fetchAgencies() async {
    try {
      print('🔍 Fetching agencies from: ${ApiEndpoints.getAllAgencies}');
      print(
        '🔍 Full URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.getAllAgencies}',
      );

      final response = await _apiService.get(ApiEndpoints.getAllAgencies);

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> agencies = response.data;
        print('🏔️ Found ${agencies.length} agencies');

        final agencyModels =
            agencies.map((json) {
              print('🏔️ Processing agency: $json');
              try {
                final agency = AgencyModel.fromJson(json);
                print('✅ Successfully created agency: ${agency.name}');
                return agency;
              } catch (e) {
                print('❌ Error creating agency from JSON: $e');
                print('❌ JSON data: $json');
                rethrow;
              }
            }).toList();

        print('✅ Successfully created ${agencyModels.length} agency models');
        return agencyModels;
      } else {
        print(
          '❌ HTTP Error: ${response.statusCode} - ${response.statusMessage}',
        );
        throw Exception('Failed to fetch agencies: ${response.statusMessage}');
      }
    } catch (e) {
      print('💥 Exception in fetchAgencies: $e');
      print('💥 Exception type: ${e.runtimeType}');
      throw Exception('Failed to fetch agencies: $e');
    }
  }

  @override
  Future<AgencyModel> createAgency(Map<String, dynamic> agencyData) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.createAgency,
        data: agencyData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AgencyModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create agency: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to create agency: $e');
    }
  }

  @override
  Future<List<AgencyBookingModel>> fetchAgencyBookings() async {
    try {
      final response = await _apiService.get(
        '${ApiEndpoints.agencyBookings}/all',
      );

      if (response.statusCode == 200) {
        final List<dynamic> bookings = response.data;
        return bookings
            .map((json) => AgencyBookingModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to fetch agency bookings: ${response.statusMessage}',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch agency bookings: $e');
    }
  }

  @override
  Future<List<AgencyBookingModel>> fetchUserAgencyBookings(
    String userId,
  ) async {
    try {
      print('🔍 Fetching user agency bookings for userId: $userId');
      print(
        '🔍 URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.getUserAgencyBookings}?userId=$userId',
      );

      final response = await _apiService.get(
        '${ApiEndpoints.getUserAgencyBookings}?userId=$userId',
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> bookings = responseData['bookings'] ?? [];

        print('🏔️ Found ${bookings.length} agency bookings');

        final bookingModels =
            bookings.map((json) {
              print('🏔️ Processing agency booking: $json');
              try {
                final booking = AgencyBookingModel.fromJson(json);
                print(
                  '✅ Successfully created agency booking: ${booking.agencyName}',
                );
                return booking;
              } catch (e) {
                print('❌ Error creating agency booking from JSON: $e');
                print('❌ JSON data: $json');
                rethrow;
              }
            }).toList();

        print(
          '✅ Successfully created ${bookingModels.length} agency booking models',
        );
        return bookingModels;
      } else {
        print(
          '❌ HTTP Error: ${response.statusCode} - ${response.statusMessage}',
        );
        throw Exception(
          'Failed to fetch user agency bookings: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('💥 Exception in fetchUserAgencyBookings: $e');
      print('💥 Exception type: ${e.runtimeType}');
      throw Exception('Failed to fetch user agency bookings: $e');
    }
  }

  @override
  Future<AgencyBookingModel> createAgencyBooking(
    Map<String, dynamic> bookingData,
  ) async {
    try {
      print('🔍 Creating agency booking with data: $bookingData');

      final response = await _apiService.post(
        ApiEndpoints.createAgencyBooking,
        data: bookingData,
      );

      print('📡 Create agency booking response status: ${response.statusCode}');
      print('📡 Create agency booking response data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final booking = AgencyBookingModel.fromJson(response.data);
        print('✅ Successfully created agency booking: ${booking.agencyName}');
        return booking;
      } else {
        print(
          '❌ HTTP Error: ${response.statusCode} - ${response.statusMessage}',
        );
        throw Exception(
          'Failed to create agency booking: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('💥 Exception in createAgencyBooking: $e');
      throw Exception('Failed to create agency booking: $e');
    }
  }

  @override
  Future<void> deleteAgencyBooking(String bookingId) async {
    try {
      print('🔍 Deleting agency booking with ID: $bookingId');

      final response = await _apiService.delete(
        '${ApiEndpoints.deleteAgencyBooking}/$bookingId',
      );

      print('📡 Delete agency booking response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Successfully deleted agency booking: $bookingId');
      } else {
        print(
          '❌ HTTP Error: ${response.statusCode} - ${response.statusMessage}',
        );
        throw Exception(
          'Failed to delete agency booking: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('💥 Exception in deleteAgencyBooking: $e');
      throw Exception('Failed to delete agency booking: $e');
    }
  }
}
