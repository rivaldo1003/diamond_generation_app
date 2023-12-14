class UserProfile {
  final int id;
  final int userId;
  final String address;
  final String age;
  final String phone_number;
  final String gender;
  final String birth_place;
  final String birth_date;

  UserProfile({
    required this.id,
    required this.userId,
    required this.address,
    required this.age,
    required this.phone_number,
    required this.gender,
    required this.birth_place,
    required this.birth_date,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      address: json['address'].toString(),
      age: json['age'].toString(),
      phone_number: json['phone_number'].toString(),
      gender: json['gender'].toString(),
      birth_place: json['birth_place'].toString(),
      birth_date: json['birth_date'].toString(),
    );
  }
}
