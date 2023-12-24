class MonthlyReport {
  bool success;
  String grade;
  int totalWpda;
  int missedDaysTotal;
  String month;
  List<ReportData> data;

  MonthlyReport({
    required this.success,
    required this.grade,
    required this.totalWpda,
    required this.missedDaysTotal,
    required this.month,
    required this.data,
  });

  factory MonthlyReport.fromJson(Map<String, dynamic> json) {
    return MonthlyReport(
      success: json['success'] ?? false,
      grade: json['grade'] ?? '',
      totalWpda: json['total_wpda'] ?? 0,
      missedDaysTotal: json['missed_days_total'] ?? 0,
      month: json['month'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => ReportData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ReportData {
  int id;
  String readingBook;
  String verseContent;
  String messageOfGod;
  String applicationInLife;
  String createdAt;
  int userId;
  Writer writer;

  ReportData({
    required this.id,
    required this.readingBook,
    required this.verseContent,
    required this.messageOfGod,
    required this.applicationInLife,
    required this.createdAt,
    required this.userId,
    required this.writer,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      id: json['id'] ?? 0,
      readingBook: json['reading_book'] ?? '',
      verseContent: json['verse_content'] ?? '',
      messageOfGod: json['message_of_god'] ?? '',
      applicationInLife: json['application_in_life'] ?? '',
      createdAt: json['created_at'] ?? '',
      userId: json['user_id'] ?? 0,
      writer: Writer.fromJson(json['writer'] ?? {}),
    );
  }
}

class Writer {
  int id;
  String fullName;
  String email;
  String profilePicture;

  Writer({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profilePicture,
  });

  factory Writer.fromJson(Map<String, dynamic> json) {
    return Writer(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
    );
  }
}
