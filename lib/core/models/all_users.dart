class AllUsers {
  final String id;
  final String fullName;
  final String email;
  final String createdAt;
  final String accountNumber;
  final String role;
  final String address;
  final String phoneNumber;
  final String gender;
  final String age;
  final String birthPlace;
  final String birthDate;
  final String profileCompleted;
  final String approvalStatus;
  final String grade;
  final String missedDaysTotal;
  final List<DataWpda> dataWpda;

  AllUsers({
    required this.id,
    required this.fullName,
    required this.email,
    required this.createdAt,
    required this.accountNumber,
    required this.role,
    required this.address,
    required this.phoneNumber,
    required this.gender,
    required this.age,
    required this.birthPlace,
    required this.birthDate,
    required this.profileCompleted,
    required this.approvalStatus,
    required this.grade,
    required this.missedDaysTotal,
    required this.dataWpda,
  });

  factory AllUsers.fromJson(Map<String, dynamic> json) {
    var wpdaHistoryList = json['wpda_history'] as List<dynamic>;
    List<DataWpda> parsedWpdaHistoryList =
        wpdaHistoryList.map((data) => DataWpda.fromJson(data)).toList();
    return AllUsers(
      id: json['id'].toString(),
      fullName: json['full_name'].toString(),
      email: json['email'].toString(),
      createdAt: json['created_at'].toString(),
      accountNumber: json['account_number'].toString(),
      role: json['role'].toString(),
      address: json['address'].toString(),
      phoneNumber: json['phone_number'].toString(),
      gender: json['gender'].toString(),
      age: json['age'].toString(),
      birthPlace: json['birth_place'].toString(),
      birthDate: json['birth_date'].toString(),
      profileCompleted: json['profile_completed'].toString(),
      approvalStatus: json['approval_status'].toString(),
      grade: json['grade'].toString(),
      missedDaysTotal: json['missed_days_total'].toString(),
      dataWpda: parsedWpdaHistoryList,
    );
  }
}

class DataWpda {
  final String id;
  final String readingBook;
  final String verseContent;
  final String applicationInLife;
  final String messageOfGod;
  final String selectedPrayers;
  final String createdAt;

  DataWpda({
    required this.id,
    required this.readingBook,
    required this.verseContent,
    required this.applicationInLife,
    required this.messageOfGod,
    required this.selectedPrayers,
    required this.createdAt,
  });

  factory DataWpda.fromJson(Map<String, dynamic> json) {
    return DataWpda(
      id: json['id'].toString(),
      readingBook: json['reading_book'].toString(),
      verseContent: json['verse_content'].toString(),
      applicationInLife: json['application_in_life'].toString(),
      messageOfGod: json['message_of_god'].toString(),
      selectedPrayers: json['selected_prayers'].toString(),
      createdAt: json['created_at'].toString(),
    );
  }
}
