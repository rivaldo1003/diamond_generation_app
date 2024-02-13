import 'package:diamond_generation_app/core/models/user_profile.dart';

class AllUsers {
  final String id;
  final String fullName;
  final String email;
  final String createdAt;
  final String accountNumber;
  final String role;
  final String totalWpda;
  final String address;
  final String deviceToken;

  final String profileCompleted;
  final String approvalStatus;
  final List<DataWpda> dataWpda;
  final UserProfile? profile;

  AllUsers({
    required this.id,
    required this.fullName,
    required this.email,
    required this.createdAt,
    required this.accountNumber,
    required this.role,
    required this.totalWpda,
    required this.address,
    required this.profileCompleted,
    required this.approvalStatus,
    required this.dataWpda,
    required this.profile,
    required this.deviceToken,
  });

  factory AllUsers.fromJson(Map<String, dynamic> json) {
    var wpdaHistoryList = json['wpda_history'] as List<dynamic>;
    List<DataWpda> parsedWpdaHistoryList =
        wpdaHistoryList.map((data) => DataWpda.fromJson(data)).toList();

    var userProfile = json['profile'];
    UserProfile? profile;
    if (userProfile != null) {
      profile = UserProfile.fromJson(userProfile);
    }

    return AllUsers(
      id: json['id'].toString(),
      fullName: json['full_name'].toString(),
      email: json['email'].toString(),
      createdAt: json['created_at'].toString(),
      accountNumber: json['account_number'].toString(),
      role: json['role'].toString(),
      totalWpda: json['total_wpda'].toString(),
      address: json['address'].toString(),
      profileCompleted: json['profile_completed'].toString(),
      approvalStatus: json['approval_status'].toString(),
      deviceToken: json['device_token'].toString(),
      dataWpda: parsedWpdaHistoryList,
      profile: profile,
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
