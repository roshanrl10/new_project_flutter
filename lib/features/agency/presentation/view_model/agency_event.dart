abstract class AgencyEvent {}

class FetchAgencies extends AgencyEvent {}

class FetchUserAgencyBookings extends AgencyEvent {
  final String userId;
  FetchUserAgencyBookings(this.userId);
}

class BookAgencyEvent extends AgencyEvent {
  final String agencyId;
  BookAgencyEvent(this.agencyId);
}

class BookGuideEvent extends AgencyEvent {
  final String guideId;
  BookGuideEvent(this.guideId);
}

class FilterAgencies extends AgencyEvent {
  final String query;
  FilterAgencies(this.query);
}

class FilterAgenciesByLocation extends AgencyEvent {
  final String location;
  FilterAgenciesByLocation(this.location);
}

class FilterAgenciesByExperience extends AgencyEvent {
  final String experience;
  FilterAgenciesByExperience(this.experience);
}

class CancelAgencyBooking extends AgencyEvent {
  final String bookingId;
  CancelAgencyBooking(this.bookingId);
}
