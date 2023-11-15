class User {
  final String id;
  final String fullName;
  final String age;
  final String phoneNumber;
  final String gender;
  final String images;

  User({
    required this.id,
    required this.fullName,
    required this.age,
    required this.phoneNumber,
    required this.gender,
    required this.images,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      age: json['age'],
      phoneNumber: json['phone_number'],
      gender: json['gender'],
      images: json['images'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'age': age,
      "phone_number": phoneNumber,
      "gender": gender,
      "images": images,
    };
  }
}
