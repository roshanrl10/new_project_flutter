import '../../domain/entity/agency_booking_entity.dart';

class AgencyBookingModel extends AgencyBooking {
  AgencyBookingModel({
    required super.id,
    required super.agencyId,
    required super.userId,
    required super.startDate,
    required super.endDate,
    required super.numberOfPeople,
    required super.totalPrice,
    required super.status,
    required super.agencyName,
    required super.userName,
    super.specialRequests,
  });

  factory AgencyBookingModel.fromJson(Map<String, dynamic> json) {
    print('🏢 Parsing agency booking JSON: $json');

    // Handle populated agency object
    String agencyName = '';
    String agencyId = '';
    if (json['agency'] is Map<String, dynamic>) {
      final agency = json['agency'] as Map<String, dynamic>;
      agencyName = agency['name']?.toString() ?? '';
      agencyId = agency['_id']?.toString() ?? '';
    } else {
      agencyId = json['agency']?.toString() ?? '';
      agencyName = json['agencyName']?.toString() ?? '';
    }

    // Handle populated user object
    String userName = '';
    String userId = '';
    if (json['user'] is Map<String, dynamic>) {
      final user = json['user'] as Map<String, dynamic>;
      userName = user['username']?.toString() ?? '';
      userId = user['_id']?.toString() ?? '';
    } else {
      userId = json['user']?.toString() ?? '';
      userName = json['userName']?.toString() ?? '';
    }

    return AgencyBookingModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      agencyId: agencyId,
      userId: userId,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      numberOfPeople: json['numberOfPeople'] ?? json['groupSize'] ?? 1,
      totalPrice: _safeParseDouble(json['totalPrice']),
      status: json['status']?.toString() ?? 'pending',
      agencyName: agencyName,
      userName: userName,
      specialRequests: json['specialRequests']?.toString(),
    );
  }

  // Helper method to safely parse double values
  static double _safeParseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        print('⚠️ Error parsing double from string: $value');
        return 0.0;
      }
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agency': agencyId,
      'user': userId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'numberOfPeople': numberOfPeople,
      'totalPrice': totalPrice,
      'status': status,
      'agencyName': agencyName,
      'userName': userName,
      'specialRequests': specialRequests,
    };
  }

  AgencyBooking toEntity() {
    return AgencyBooking(
      id: id,
      agencyId: agencyId,
      userId: userId,
      startDate: startDate,
      endDate: endDate,
      numberOfPeople: numberOfPeople,
      totalPrice: totalPrice,
      status: status,
      agencyName: agencyName,
      userName: userName,
      specialRequests: specialRequests,
    );
  }
}
