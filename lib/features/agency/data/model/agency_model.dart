import '../../domain/entity/agency_entity.dart';

class AgencyModel extends Agency {
  AgencyModel({
    required super.id,
    required super.name,
    required super.location,
    required super.pricePerDay,
    required super.rating,
    super.image,
    required super.languages,
    required super.specialties,
    required super.description,
    required super.available,
    required super.experience,
    required super.groupSize,
    required super.contactInfo,
    required super.certifications,
  });

  factory AgencyModel.fromJson(Map<String, dynamic> json) {
    // Safely parse languages
    List<String> languages = [];
    if (json['languages'] != null) {
      try {
        if (json['languages'] is List) {
          languages =
              (json['languages'] as List)
                  .map((item) => item?.toString() ?? '')
                  .where((item) => item.isNotEmpty)
                  .toList();
        }
      } catch (e) {
        print('⚠️ Error parsing languages: $e');
        languages = [];
      }
    }

    // Safely parse specialties
    List<String> specialties = [];
    if (json['specialties'] != null) {
      try {
        if (json['specialties'] is List) {
          specialties =
              (json['specialties'] as List)
                  .map((item) => item?.toString() ?? '')
                  .where((item) => item.isNotEmpty)
                  .toList();
        }
      } catch (e) {
        print('⚠️ Error parsing specialties: $e');
        specialties = [];
      }
    }

    // Safely parse certifications
    List<String> certifications = [];
    if (json['certifications'] != null) {
      try {
        if (json['certifications'] is List) {
          certifications =
              (json['certifications'] as List)
                  .map((item) => item?.toString() ?? '')
                  .where((item) => item.isNotEmpty)
                  .toList();
        }
      } catch (e) {
        print('⚠️ Error parsing certifications: $e');
        certifications = [];
      }
    }

    // Parse contact info
    ContactInfo contactInfo = ContactInfo();
    if (json['contactInfo'] != null) {
      final contactData = json['contactInfo'] as Map<String, dynamic>;
      contactInfo = ContactInfo(
        phone: contactData['phone']?.toString(),
        email: contactData['email']?.toString(),
        website: contactData['website']?.toString(),
      );
    }

    return AgencyModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      pricePerDay: _safeParseDouble(json['pricePerDay']),
      rating: _safeParseDouble(json['rating']),
      image: json['image']?.toString(),
      languages: languages,
      specialties: specialties,
      description: json['description']?.toString() ?? '',
      available: json['available'] == true,
      experience: json['experience'] ?? 0,
      groupSize: json['groupSize']?.toString() ?? '',
      contactInfo: contactInfo,
      certifications: certifications,
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
      'name': name,
      'location': location,
      'pricePerDay': pricePerDay,
      'rating': rating,
      'image': image,
      'languages': languages,
      'specialties': specialties,
      'description': description,
      'available': available,
      'experience': experience,
      'groupSize': groupSize,
      'contactInfo': {
        'phone': contactInfo.phone,
        'email': contactInfo.email,
        'website': contactInfo.website,
      },
      'certifications': certifications,
    };
  }

  Agency toEntity() {
    return Agency(
      id: id,
      name: name,
      location: location,
      pricePerDay: pricePerDay,
      rating: rating,
      image: image,
      languages: languages,
      specialties: specialties,
      description: description,
      available: available,
      experience: experience,
      groupSize: groupSize,
      contactInfo: contactInfo,
      certifications: certifications,
    );
  }
}
