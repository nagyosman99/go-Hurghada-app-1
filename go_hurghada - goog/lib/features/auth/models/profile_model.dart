class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String? profileImagePath;
  final String? phoneNumber;
  final DateTime? updatedAt;

  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profileImagePath,
    this.phoneNumber,
    this.updatedAt,
  });

  // Default empty profile
  factory UserProfile.empty() {
    return const UserProfile(firstName: '', lastName: '', email: '');
  }

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? profileImagePath,
    String? phoneNumber,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profileImagePath': profileImagePath,
      'phoneNumber': phoneNumber,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      profileImagePath: json['profileImagePath'],
      phoneNumber: json['phoneNumber'],
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  String get fullName => '$firstName $lastName'.trim();
}
