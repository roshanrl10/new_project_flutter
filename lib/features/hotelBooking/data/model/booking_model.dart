import '../../domain/entity/booking_entity.dart';

class BookingModel extends Booking {
  BookingModel({
    required super.id,
    required super.hotelId,
    required super.userId,
    required super.checkInDate,
    required super.checkOutDate,
    required super.totalPrice,
    required super.status,
    required super.hotelName,
    required super.userName,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    print('🏨 Parsing booking JSON: $json');

    // Extract hotel name from populated hotel object
    String hotelName = '';
    if (json['hotel'] is Map<String, dynamic>) {
      hotelName = json['hotel']['name'] ?? '';
      print('🏨 Extracted hotel name: $hotelName');
    } else {
      print('🏨 Hotel object is not a Map: ${json['hotel']}');
    }

    // Calculate total price (backend doesn't provide this)
    double totalPrice = 0.0;
    if (json['hotel'] is Map<String, dynamic> &&
        json['hotel']['price'] != null) {
      final hotelPrice = (json['hotel']['price'] as num).toDouble();
      final checkIn = DateTime.parse(json['checkIn']);
      final checkOut = DateTime.parse(json['checkOut']);
      final days = checkOut.difference(checkIn).inDays;
      final guests = json['guests'] ?? 1;
      totalPrice = hotelPrice * days * guests;
      print('🏨 Calculated total price: $totalPrice');
    } else {
      print('🏨 Could not calculate total price - hotel or price is null');
    }

    final bookingModel = BookingModel(
      id: json['_id'] ?? json['id'] ?? '',
      hotelId:
          json['hotel'] is Map<String, dynamic>
              ? json['hotel']['_id'] ?? ''
              : '',
      userId: json['user'] ?? '',
      checkInDate: DateTime.parse(json['checkIn']),
      checkOutDate: DateTime.parse(json['checkOut']),
      totalPrice: totalPrice,
      status: json['status'] ?? 'confirmed',
      hotelName: hotelName,
      userName: '', // Backend doesn't provide user name
    );

    print(
      '🏨 Created booking model: ${bookingModel.hotelName} (${bookingModel.status})',
    );
    return bookingModel;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotelId': hotelId,
      'userId': userId,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'totalPrice': totalPrice,
      'status': status,
      'hotelName': hotelName,
      'userName': userName,
    };
  }

  Booking toEntity() {
    return Booking(
      id: id,
      hotelId: hotelId,
      userId: userId,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      totalPrice: totalPrice,
      status: status,
      hotelName: hotelName,
      userName: userName,
    );
  }

  factory BookingModel.fromEntity(Booking booking) {
    return BookingModel(
      id: booking.id,
      hotelId: booking.hotelId,
      userId: booking.userId,
      checkInDate: booking.checkInDate,
      checkOutDate: booking.checkOutDate,
      totalPrice: booking.totalPrice,
      status: booking.status,
      hotelName: booking.hotelName,
      userName: booking.userName,
    );
  }
}
