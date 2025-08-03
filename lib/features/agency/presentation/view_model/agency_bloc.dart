import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_flutter/features/agency/domain/repository/agency_repository.dart';
import 'package:new_project_flutter/features/agency/presentation/view_model/agency_event.dart';
import 'package:new_project_flutter/features/agency/presentation/view_model/agency_state.dart';
import 'package:new_project_flutter/features/agency/domain/entity/agency_entity.dart';
import 'package:new_project_flutter/features/agency/domain/entity/agency_booking_entity.dart';

class AgencyBloc extends Bloc<AgencyEvent, AgencyState> {
  final AgencyRepository repository;
  List<Agency> _allAgencies = [];
  // Make local bookings static so they persist across bloc recreations
  static List<AgencyBooking> _localBookings = []; // Store bookings locally

  AgencyBloc(this.repository) : super(AgencyInitial()) {
    on<FetchAgencies>((event, emit) async {
      emit(AgencyLoading());
      try {
        final agencies = await repository.fetchAgencies();
        _allAgencies = agencies;
        emit(AgencyLoaded(agencies));
      } catch (e) {
        emit(AgencyError(e.toString()));
      }
    });

    on<FetchUserAgencyBookings>((event, emit) async {
      emit(AgencyBookingLoading());
      try {
        print('🏢 Fetching agency bookings from local state...');
        print('🏢 Found ${_localBookings.length} local bookings');

        // Debug: Print all local bookings
        for (int i = 0; i < _localBookings.length; i++) {
          final booking = _localBookings[i];
          print(
            '🏢 Local booking $i: ${booking.agencyName} (${booking.status}) - \$${booking.totalPrice}',
          );
        }

        emit(AgencyBookingLoaded(_localBookings));
      } catch (e) {
        emit(AgencyBookingError(e.toString()));
      }
    });

    on<BookAgencyEvent>((event, emit) async {
      print('🏢 BookAgencyEvent triggered');
      emit(AgencyBookingActionLoading());
      try {
        print('🏢 Creating agency booking locally...');

        // Create booking locally without backend
        print('🏢 Creating AgencyBooking with data:');
        print('  - Agency ID: ${event.agencyId}');
        print('  - User ID: 688339f4171a690ae2d5d852');
        print('  - Start Date: ${DateTime.now().toIso8601String()}');
        print(
          '  - End Date: ${DateTime.now().add(const Duration(days: 7)).toIso8601String()}',
        );
        print('  - Number of People: 2');
        print('  - Total Price: 700.0');
        print('  - Status: confirmed');

        final booking = AgencyBooking(
          id:
              DateTime.now().millisecondsSinceEpoch
                  .toString(), // Generate local ID
          agencyId: event.agencyId,
          userId: '688339f4171a690ae2d5d852',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 7)),
          numberOfPeople: 2,
          totalPrice: 700.0,
          status: 'confirmed',
          agencyName:
              'Trekking Agency', // Default name since we don't have agency details
          userName: 'Current User',
          specialRequests: 'Booking from Flutter app',
        );

        print('🏢 AgencyBooking created successfully:');
        print('  - ID: ${booking.id}');
        print('  - Agency Name: ${booking.agencyName}');
        print('  - Status: ${booking.status}');
        print('  - Total Price: ${booking.totalPrice}');
        print('  - Number of People: ${booking.numberOfPeople}');

        // Add to local bookings
        _localBookings.add(booking);
        print('🏢 Agency booking added to local state');
        print('🏢 Total local bookings: ${_localBookings.length}');

        // Emit loaded state with local bookings
        print('🔄 Emitting AgencyBookingLoaded state with local bookings');
        emit(AgencyBookingLoaded(_localBookings));

        // Then emit success state
        print('🏢 Emitting success state');
        emit(AgencyBookingSuccess('Agency booked successfully!'));

        print('✅ Successfully booked agency: ${event.agencyId}');
      } catch (e) {
        print('❌ Error in BookAgencyEvent: $e');
        emit(AgencyBookingError(e.toString()));
      }
    });

    on<BookGuideEvent>((event, emit) async {
      // TODO: Implement guide booking when guide functionality is added
      print('Booking guide: ${event.guideId}');
    });

    on<FilterAgencies>((event, emit) {
      final filtered =
          _allAgencies
              .where(
                (a) => a.name.toLowerCase().contains(event.query.toLowerCase()),
              )
              .toList();
      emit(AgencyLoaded(filtered));
    });

    on<FilterAgenciesByLocation>((event, emit) {
      final filtered =
          _allAgencies
              .where(
                (a) =>
                    event.location == 'All Locations' ||
                    a.location == event.location,
              )
              .toList();
      emit(AgencyLoaded(filtered));
    });

    on<FilterAgenciesByExperience>((event, emit) {
      final filtered =
          _allAgencies
              .where(
                (a) =>
                    event.experience == 'All Experience Levels' ||
                    a.experience.toString() == event.experience,
              )
              .toList();
      emit(AgencyLoaded(filtered));
    });

    on<CancelAgencyBooking>((event, emit) async {
      emit(AgencyBookingActionLoading());
      try {
        print('🏢 Cancelling agency booking locally...');

        // Remove booking from local state
        _localBookings.removeWhere((booking) => booking.id == event.bookingId);
        print('🏢 Booking removed from local state');
        print('🏢 Remaining local bookings: ${_localBookings.length}');

        // Emit updated bookings
        emit(AgencyBookingLoaded(_localBookings));
        emit(AgencyBookingSuccess('Agency booking cancelled successfully!'));
      } catch (e) {
        emit(AgencyBookingError(e.toString()));
      }
    });
  }

  // Debug method to clear local bookings
  static void clearLocalBookings() {
    _localBookings.clear();
    print('🏢 Local bookings cleared');
  }

  // Debug method to get local bookings count
  static int getLocalBookingsCount() {
    return _localBookings.length;
  }
}
