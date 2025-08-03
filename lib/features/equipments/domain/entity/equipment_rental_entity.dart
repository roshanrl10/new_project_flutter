class EquipmentRental {
  final String id;
  final String equipmentId;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final String status;
  final String equipmentName;
  final String userName;
  final int quantity;
  final String specialRequests;

  EquipmentRental({
    required this.id,
    required this.equipmentId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.equipmentName,
    required this.userName,
    required this.quantity,
    required this.specialRequests,
  });
}
