class UserProfile {
  final int id;
  final int userId;
  final String address;
  final String age;
  final String phone_number;
  final String gender;
  final String grade;
  final String birth_place;
  final String birth_date;
  final String profile_picture;
  final String missed_days_total;

  UserProfile({
    required this.id,
    required this.userId,
    required this.address,
    required this.age,
    required this.phone_number,
    required this.gender,
    required this.grade,
    required this.birth_place,
    required this.birth_date,
    required this.profile_picture,
    required this.missed_days_total,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      address: json['address'].toString(),
      age: json['age'].toString(),
      phone_number: json['phone_number'].toString(),
      gender: json['gender'].toString(),
      grade: json['grade'].toString(),
      birth_place: json['birth_place'].toString(),
      birth_date: json['birth_date'].toString(),
      profile_picture: json['profile_picture'].toString(),
      missed_days_total: json['missed_days_total'].toString(),
    );
  }
}
