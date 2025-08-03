import '../../../../../core/network/api_service.dart';
import '../../../../../app/constant/api_endpoints.dart';
import '../../model/equipment_model.dart';
import '../../model/equipment_rental_model.dart';

abstract class EquipmentRemoteDataSource {
  Future<List<EquipmentModel>> fetchEquipments();
  Future<EquipmentModel> createEquipment(Map<String, dynamic> equipmentData);
  Future<List<EquipmentRentalModel>> fetchEquipmentRentals();
  Future<EquipmentRentalModel> createEquipmentRental(
    Map<String, dynamic> rentalData,
  );
}

class EquipmentRemoteDataSourceImpl implements EquipmentRemoteDataSource {
  final ApiService _apiService = ApiService();

  @override
  Future<List<EquipmentModel>> fetchEquipments() async {
    try {
      print('🔍 Fetching equipment from: ${ApiEndpoints.getAllEquipment}');
      print(
        '🔍 Full URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.getAllEquipment}',
      );

      final response = await _apiService.get(ApiEndpoints.getAllEquipment);

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> equipment = response.data;
        print('🏕️ Found ${equipment.length} equipment items');

        final equipmentModels =
            equipment.map((json) {
              print('🏕️ Processing equipment: $json');
              try {
                final equipment = EquipmentModel.fromJson(json);
                print('✅ Successfully created equipment: ${equipment.name}');
                return equipment;
              } catch (e) {
                print('❌ Error creating equipment from JSON: $e');
                print('❌ JSON data: $json');
                rethrow;
              }
            }).toList();

        print(
          '✅ Successfully created ${equipmentModels.length} equipment models',
        );
        return equipmentModels;
      } else {
        print(
          '❌ HTTP Error: ${response.statusCode} - ${response.statusMessage}',
        );
        throw Exception('Failed to fetch equipment: ${response.statusMessage}');
      }
    } catch (e) {
      print('💥 Exception in fetchEquipments: $e');
      print('💥 Exception type: ${e.runtimeType}');
      throw Exception('Failed to fetch equipment: $e');
    }
  }

  @override
  Future<EquipmentModel> createEquipment(
    Map<String, dynamic> equipmentData,
  ) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.createEquipment,
        data: equipmentData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return EquipmentModel.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to create equipment: ${response.statusMessage}',
        );
      }
    } catch (e) {
      throw Exception('Failed to create equipment: $e');
    }
  }

  @override
  Future<List<EquipmentRentalModel>> fetchEquipmentRentals() async {
    try {
      final response = await _apiService.get(
        '${ApiEndpoints.equipmentRentals}/all',
      );

      if (response.statusCode == 200) {
        final List<dynamic> rentals = response.data;
        return rentals
            .map((json) => EquipmentRentalModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to fetch equipment rentals: ${response.statusMessage}',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch equipment rentals: $e');
    }
  }

  @override
  Future<EquipmentRentalModel> createEquipmentRental(
    Map<String, dynamic> rentalData,
  ) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.createEquipmentRental,
        data: rentalData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return EquipmentRentalModel.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to create equipment rental: ${response.statusMessage}',
        );
      }
    } catch (e) {
      throw Exception('Failed to create equipment rental: $e');
    }
  }
}
