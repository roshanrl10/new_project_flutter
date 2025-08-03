class Booking {
  final String id;
  final String hotelId;
  final String userId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final double totalPrice;
  final String status;
  final String hotelName;
  final String userName;

  Booking({
    required this.id,
    required this.hotelId,
    required this.userId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalPrice,
    required this.status,
    required this.hotelName,
    required this.userName,
  });
}
