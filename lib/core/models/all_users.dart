class AllUsers {
  final String id;
  final String fullName;
  final String email;
  final String registration_date;
  final String account_number;
  final String role;
  final String address;
  final String phoneNumber;
  final String gender;
  final String birthPlace;
  final String birthDate;
  final String profile_completed;

  AllUsers({
    required this.id,
    required this.fullName,
    required this.email,
    required this.registration_date,
    required this.account_number,
    required this.role,
    required this.address,
    required this.phoneNumber,
    required this.gender,
    required this.birthPlace,
    required this.birthDate,
    required this.profile_completed,
  });

  factory AllUsers.fromJson(Map<String, dynamic> json) {
    return AllUsers(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      registration_date: json['registration_date'],
      account_number: json['account_number'],
      role: json['role'],
      address: json['address'].toString(),
      phoneNumber: json['phone_number'].toString(),
      gender: json['gender'].toString(),
      birthPlace: json['birth_place'].toString(),
      birthDate: json['birth_date'].toString(),
      profile_completed: json['profile_completed'].toString(),
    );
  }
}
