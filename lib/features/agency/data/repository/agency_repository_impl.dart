import '../../domain/repository/agency_repository.dart';
import '../../domain/entity/agency_entity.dart';
import '../../domain/entity/agency_booking_entity.dart';
import '../data_source/remote_datasource/agency_remote_datasource.dart';
// import '../model/agency_model.dart';
// import '../model/agency_booking_model.dart';

class AgencyRepositoryImpl implements AgencyRepository {
  final AgencyRemoteDataSource dataSource;

  AgencyRepositoryImpl(this.dataSource);

  @override
  Future<List<Agency>> fetchAgencies() async {
    final models = await dataSource.fetchAgencies();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Agency> createAgency(Map<String, dynamic> agencyData) async {
    final model = await dataSource.createAgency(agencyData);
    return model.toEntity();
  }

  @override
  Future<List<AgencyBooking>> fetchAgencyBookings() async {
    final models = await dataSource.fetchAgencyBookings();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<AgencyBooking>> fetchUserAgencyBookings(String userId) async {
    final models = await dataSource.fetchUserAgencyBookings(userId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<AgencyBooking> createAgencyBooking(
    Map<String, dynamic> bookingData,
  ) async {
    final model = await dataSource.createAgencyBooking(bookingData);
    return model.toEntity();
  }

  @override
  Future<void> deleteAgencyBooking(String bookingId) async {
    await dataSource.deleteAgencyBooking(bookingId);
  }
}
