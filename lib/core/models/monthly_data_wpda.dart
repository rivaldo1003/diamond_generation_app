class MonthlyUserData {
  final String month;
  final int totalWpda;
  final int missedDaysTotal;

  MonthlyUserData({
    required this.month,
    required this.totalWpda,
    required this.missedDaysTotal,
  });

  factory MonthlyUserData.fromJson(Map<String, dynamic> json) {
    return MonthlyUserData(
      month: json['month'],
      totalWpda: json['total_wpda'],
      missedDaysTotal: json['missed_days_total'],
    );
  }
}

class UserData {
  final int userId;
  final String fullName;
  final String email;
  final String profilePicture;
  final String grade;
  final List<MonthlyUserData> monthlyData;

  UserData({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.profilePicture,
    required this.grade,
    required this.monthlyData,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> monthlyDataList = json['monthly_data'];
    final List<MonthlyUserData> monthlyData =
        monthlyDataList.map((dynamic item) {
      return MonthlyUserData.fromJson(item as Map<String, dynamic>);
    }).toList();
    return UserData(
      userId: json['user_id'],
      fullName: json['full_name'],
      email: json['email'],
      profilePicture: json['profile_picture'],
      grade: json['grade'],
      monthlyData: monthlyData,
    );
  }
}

class ApiResponse {
  final bool success;
  final List<UserData> data;

  ApiResponse({
    required this.success,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> userDataList = json['data'];
    final List<UserData> data = userDataList
        .map((dynamic item) => UserData.fromJson(item as Map<String, dynamic>))
        .toList();

    return ApiResponse(
      success: json['success'],
      data: data,
    );
  }
}
