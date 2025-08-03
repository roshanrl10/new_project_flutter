class AgencyBooking {
  final String id;
  final String agencyId;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfPeople;
  final double totalPrice;
  final String status;
  final String agencyName;
  final String userName;
  final String? specialRequests;

  AgencyBooking({
    required this.id,
    required this.agencyId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.numberOfPeople,
    required this.totalPrice,
    required this.status,
    required this.agencyName,
    required this.userName,
    this.specialRequests,
  });
}
