class UserProfile {
  final String id;
  final String userId;
  final String address;
  final String phone_number;
  final String birth_place;
  final String birth_date;

  UserProfile({
    required this.id,
    required this.userId,
    required this.address,
    required this.phone_number,
    required this.birth_place,
    required this.birth_date,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      userId: json['user_id'],
      address: json['address'],
      phone_number: json['phone_number'],
      birth_place: json['birth_place'],
      birth_date: json['birth_date'],
    );
  }
}
