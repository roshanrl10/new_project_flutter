import 'package:new_project_flutter/features/agency/domain/entity/agency_entity.dart';
import 'package:new_project_flutter/features/agency/domain/entity/agency_booking_entity.dart';

abstract class AgencyRepository {
  Future<List<Agency>> fetchAgencies();
  Future<Agency> createAgency(Map<String, dynamic> agencyData);
  Future<List<AgencyBooking>> fetchAgencyBookings();
  Future<List<AgencyBooking>> fetchUserAgencyBookings(String userId);
  Future<AgencyBooking> createAgencyBooking(Map<String, dynamic> bookingData);
  Future<void> deleteAgencyBooking(String bookingId);
}

// usecase/get_agencies_usecase.dart
class GetAgenciesUseCase {
  final AgencyRepository repository;
  GetAgenciesUseCase(this.repository);
  Future<List<Agency>> call() => repository.fetchAgencies();
}
