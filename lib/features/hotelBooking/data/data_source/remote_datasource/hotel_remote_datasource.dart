import '../../../../../core/network/api_service.dart';
import '../../../../../app/constant/api_endpoints.dart';
import '../../model/hotel_model.dart';

abstract class HotelRemoteDataSource {
  Future<List<HotelModel>> getAllHotels();
  Future<HotelModel> createHotel(Map<String, dynamic> hotelData);
}

class HotelRemoteDataSourceImpl implements HotelRemoteDataSource {
  final ApiService _apiService = ApiService();

  @override
  Future<List<HotelModel>> getAllHotels() async {
    try {
      print('🔍 Fetching hotels from: ${ApiEndpoints.getAllHotels}');
      print(
        '🔍 Full URL: ${ApiEndpoints.baseUrl}/${ApiEndpoints.getAllHotels}',
      );

      final response = await _apiService.get(ApiEndpoints.getAllHotels);

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        print('📊 Response data type: ${data.runtimeType}');
        print('📊 Response data keys: ${data.keys}');

        if (data['success'] == true) {
          final List<dynamic> hotels = data['hotels'] ?? [];
          print('🏨 Found ${hotels.length} hotels');

          final hotelModels =
              hotels.map((json) {
                print('🏨 Processing hotel: $json');
                try {
                  final hotel = HotelModel.fromJson(json);
                  print('✅ Successfully created hotel: ${hotel.name}');
                  return hotel;
                } catch (e) {
                  print('❌ Error creating hotel from JSON: $e');
                  print('❌ JSON data: $json');
                  rethrow;
                }
              }).toList();

          print('✅ Successfully created ${hotelModels.length} hotel models');
          return hotelModels;
        } else {
          print('❌ API returned success: false');
          throw Exception('Failed to fetch hotels: ${data['message']}');
        }
      } else {
        print(
          '❌ HTTP Error: ${response.statusCode} - ${response.statusMessage}',
        );
        throw Exception('Failed to fetch hotels: ${response.statusMessage}');
      }
    } catch (e) {
      print('💥 Exception in getAllHotels: $e');
      print('💥 Exception type: ${e.runtimeType}');
      throw Exception('Failed to fetch hotels: $e');
    }
  }

  @override
  Future<HotelModel> createHotel(Map<String, dynamic> hotelData) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.hotels,
        data: hotelData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return HotelModel.fromJson(data['hotel']);
        } else {
          throw Exception('Failed to create hotel: ${data['message']}');
        }
      } else {
        throw Exception('Failed to create hotel: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to create hotel: $e');
    }
  }
}
