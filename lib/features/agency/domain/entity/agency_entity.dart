class Agency {
  final String id;
  final String name;
  final String location;
  final double pricePerDay;
  final double rating;
  final String? image;
  final List<String> languages;
  final List<String> specialties;
  final String description;
  final bool available;
  final int experience;
  final String groupSize;
  final ContactInfo contactInfo;
  final List<String> certifications;

  Agency({
    required this.id,
    required this.name,
    required this.location,
    required this.pricePerDay,
    required this.rating,
    this.image,
    required this.languages,
    required this.specialties,
    required this.description,
    required this.available,
    required this.experience,
    required this.groupSize,
    required this.contactInfo,
    required this.certifications,
  });
}

class ContactInfo {
  final String? phone;
  final String? email;
  final String? website;

  ContactInfo({this.phone, this.email, this.website});
}

class Guide {
  final String id;
  final String name;
  final String expertise;

  Guide({required this.id, required this.name, required this.expertise});
}
