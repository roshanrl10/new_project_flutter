import '../../domain/repository/hotel_repository.dart';
import '../../domain/entity/hotel_entity.dart';
import '../../domain/entity/booking_entity.dart';
import '../data_source/remote_datasource/hotel_remote_datasource.dart';
import '../data_source/remote_datasource/booking_remote_datasource.dart';
import '../model/hotel_model.dart';
import '../model/booking_model.dart';

class HotelRepositoryImpl implements HotelRepository {
  final HotelRemoteDataSource hotelRemoteDataSource;
  final BookingRemoteDataSource bookingRemoteDataSource;

  HotelRepositoryImpl({
    required this.hotelRemoteDataSource,
    required this.bookingRemoteDataSource,
  });

  @override
  Future<List<Hotel>> fetchHotels() async {
    final models = await hotelRemoteDataSource.getAllHotels();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Hotel> createHotel(Map<String, dynamic> hotelData) async {
    final model = await hotelRemoteDataSource.createHotel(hotelData);
    return model.toEntity();
  }

  @override
  Future<List<Booking>> fetchUserBookings(String userId) async {
    final models = await bookingRemoteDataSource.fetchUserBookings(userId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Booking> createBooking(Map<String, dynamic> bookingData) async {
    final model = await bookingRemoteDataSource.createBooking(bookingData);
    return model.toEntity();
  }

  @override
  Future<void> deleteBooking(String bookingId) async {
    await bookingRemoteDataSource.deleteBooking(bookingId);
  }
}
