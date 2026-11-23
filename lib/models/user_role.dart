import 'app_models.dart';

export 'app_models.dart' show UserRole;



class UserProfile {
  final String id;
  final String fullName;
  final String nationalId;
  final String agriculturalCardNumber;
  final String phone;
  final String city;
  final UserRole role;
  final String avatarInitials;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.nationalId,
    required this.agriculturalCardNumber,
    required this.phone,
    required this.city,
    required this.role,
    required this.avatarInitials,
  });

  UserProfile copyWith({
    String? fullName,
    String? nationalId,
    String? agriculturalCardNumber,
    String? phone,
    String? city,
    UserRole? role,
    String? avatarInitials,
  }) {
    return UserProfile(
      id: id,
      fullName: fullName ?? this.fullName,
      nationalId: nationalId ?? this.nationalId,
      agriculturalCardNumber: agriculturalCardNumber ?? this.agriculturalCardNumber,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      role: role ?? this.role,
      avatarInitials: avatarInitials ?? this.avatarInitials,
    );
  }
}
