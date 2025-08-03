import 'package:new_project_flutter/features/agency/domain/entity/agency_entity.dart';
import 'package:new_project_flutter/features/agency/domain/entity/agency_booking_entity.dart';

abstract class AgencyState {}

class AgencyInitial extends AgencyState {}

class AgencyLoading extends AgencyState {}

class AgencyLoaded extends AgencyState {
  final List<Agency> agencies;
  AgencyLoaded(this.agencies);
}

class AgencyError extends AgencyState {
  final String message;
  AgencyError(this.message);
}

// User Agency Booking States
class AgencyBookingLoading extends AgencyState {}

class AgencyBookingLoaded extends AgencyState {
  final List<AgencyBooking> agencyBookings;

  AgencyBookingLoaded(this.agencyBookings);
}

class AgencyBookingError extends AgencyState {
  final String message;

  AgencyBookingError(this.message);
}

// Agency Booking Action States
class AgencyBookingSuccess extends AgencyState {
  final String message;
  AgencyBookingSuccess(this.message);
}

class AgencyBookingActionLoading extends AgencyState {}

class AgencyBookingCancelled extends AgencyState {
  final String message;
  AgencyBookingCancelled(this.message);
}
