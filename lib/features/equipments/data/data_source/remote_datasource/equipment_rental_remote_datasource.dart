import '../../../../../core/network/api_service.dart';
import '../../../../../app/constant/api_endpoints.dart';
import '../../model/equipment_rental_model.dart';

abstract class EquipmentRentalRemoteDataSource {
  Future<List<EquipmentRentalModel>> fetchUserEquipmentRentals(String userId);
  Future<EquipmentRentalModel> createEquipmentRental(
    Map<String, dynamic> rentalData,
  );
  Future<void> deleteEquipmentRental(String rentalId);
}

class EquipmentRentalRemoteDataSourceImpl
    implements EquipmentRentalRemoteDataSource {
  final ApiService _apiService = ApiService();

  @override
  Future<List<EquipmentRentalModel>> fetchUserEquipmentRentals(
    String userId,
  ) async {
    try {
      print('🔍 Fetching user equipment rentals for userId: $userId');
      print(
        '🔍 URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.getUserEquipmentRentals}?userId=$userId',
      );

      final response = await _apiService.get(
        '${ApiEndpoints.getUserEquipmentRentals}?userId=$userId',
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> rentals = responseData['rentals'] ?? [];

        print('🔧 Found ${rentals.length} equipment rentals');

        final rentalModels =
            rentals.map((json) {
              print('🔧 Processing rental: $json');
              try {
                final rental = EquipmentRentalModel.fromJson(json);
                print('✅ Successfully created rental: ${rental.equipmentName}');
                return rental;
              } catch (e) {
                print('❌ Error creating rental from JSON: $e');
                print('❌ JSON data: $json');
                rethrow;
              }
            }).toList();

        print('✅ Successfully created ${rentalModels.length} rental models');
        return rentalModels;
      } else {
        print(
          '❌ HTTP Error: ${response.statusCode} - ${response.statusMessage}',
        );
        throw Exception(
          'Failed to fetch user equipment rentals: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('💥 Exception in fetchUserEquipmentRentals: $e');
      print('💥 Exception type: ${e.runtimeType}');
      throw Exception('Failed to fetch user equipment rentals: $e');
    }
  }

  @override
  Future<EquipmentRentalModel> createEquipmentRental(
    Map<String, dynamic> rentalData,
  ) async {
    try {
      print('🔍 Creating equipment rental with data: $rentalData');
      print('🔍 User ID: ${rentalData['user']}');
      print('🔍 Equipment ID: ${rentalData['equipment']}');
      print('🔍 Start Date: ${rentalData['startDate']}');
      print('🔍 End Date: ${rentalData['endDate']}');
      print('🔍 Quantity: ${rentalData['quantity']}');
      print('🔍 Total Price: ${rentalData['totalPrice']}');
      print('🔍 Status: ${rentalData['status']}');

      // Validate user ID
      if (rentalData['user'] == null || rentalData['user'].toString().isEmpty) {
        throw Exception('User ID is required and cannot be null or empty');
      }

      final response = await _apiService.post(
        ApiEndpoints.createEquipmentRental,
        data: rentalData,
      );

      print('📡 Create rental response status: ${response.statusCode}');
      print('📡 Create rental response data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final rental = EquipmentRentalModel.fromJson(response.data);
        print('✅ Successfully created rental: ${rental.equipmentName}');
        return rental;
      } else {
        print(
          '❌ HTTP Error: ${response.statusCode} - ${response.statusMessage}',
        );
        throw Exception(
          'Failed to create equipment rental: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('💥 Exception in createEquipmentRental: $e');
      throw Exception('Failed to create equipment rental: $e');
    }
  }

  @override
  Future<void> deleteEquipmentRental(String rentalId) async {
    try {
      print('🔍 Deleting equipment rental with ID: $rentalId');

      final response = await _apiService.delete(
        '${ApiEndpoints.deleteEquipmentRental}/$rentalId',
      );

      print('📡 Delete rental response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Successfully deleted rental: $rentalId');
      } else {
        print(
          '❌ HTTP Error: ${response.statusCode} - ${response.statusMessage}',
        );
        throw Exception(
          'Failed to delete equipment rental: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('💥 Exception in deleteEquipmentRental: $e');
      throw Exception('Failed to delete equipment rental: $e');
    }
  }
}
