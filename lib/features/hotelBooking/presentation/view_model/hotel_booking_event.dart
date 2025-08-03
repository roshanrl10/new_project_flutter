abstract class HotelBookingEvent {}

class FetchHotels extends HotelBookingEvent {}

class FetchUserBookings extends HotelBookingEvent {
  final String userId;
  FetchUserBookings(this.userId);
}

class SearchHotels extends HotelBookingEvent {
  final String query;
  SearchHotels(this.query);
}

class FilterHotelsByLocation extends HotelBookingEvent {
  final String location;
  FilterHotelsByLocation(this.location);
}

class FilterHotelsByPrice extends HotelBookingEvent {
  final String priceRange;
  FilterHotelsByPrice(this.priceRange);
}

class BookHotel extends HotelBookingEvent {
  final Map<String, dynamic> bookingData;
  BookHotel(this.bookingData);
}

class CancelHotelBooking extends HotelBookingEvent {
  final String bookingId;
  CancelHotelBooking(this.bookingId);
}
