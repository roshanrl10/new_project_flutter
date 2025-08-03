class AuthUser {
  final String id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? token;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AuthUser({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.token,
    this.role = 'normal',
    this.createdAt,
    this.updatedAt,
  });

  bool get isAdmin => role == 'admin';
  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'token': token,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      token: json['token']?.toString(),
      role: json['role']?.toString() ?? 'normal',
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'].toString())
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'].toString())
              : null,
    );
  }

  AuthUser copyWith({
    String? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? token,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AuthUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      token: token ?? this.token,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
