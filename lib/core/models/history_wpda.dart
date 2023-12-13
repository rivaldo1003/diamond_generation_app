class History {
  final bool success;
  final int missedDaysTotal;
  final String grade;
  final int totalWPDA;
  final List<HistoryWpda> data;

  History({
    required this.success,
    required this.missedDaysTotal,
    required this.grade,
    required this.totalWPDA,
    required this.data,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<HistoryWpda> wpdaList =
        dataList.map((item) => HistoryWpda.fromJson(item)).toList();

    return History(
      success: json['success'],
      missedDaysTotal: json['missed_days_total'],
      grade: json['grade'],
      totalWPDA: json['total_wpda'],
      data: wpdaList,
    );
  }
}

class HistoryWpda {
  final int id;
  final String readingBook;
  final String verseContent;
  final String messageOfGod;
  final String applicationInLife;
  final String createdAt;
  final int userId;
  final Writer writer;

  HistoryWpda({
    required this.id,
    required this.readingBook,
    required this.verseContent,
    required this.messageOfGod,
    required this.applicationInLife,
    required this.createdAt,
    required this.userId,
    required this.writer,
  });

  factory HistoryWpda.fromJson(Map<String, dynamic> json) {
    return HistoryWpda(
      id: json['id'],
      readingBook: json['reading_book'],
      verseContent: json['verse_content'],
      messageOfGod: json['message_of_god'],
      applicationInLife: json['application_in_life'],
      createdAt: json['created_at'],
      userId: json['user_id'],
      writer: Writer.fromJson(json['writer']),
    );
  }
}

class Writer {
  final int id;
  final String fullName;
  final String email;

  Writer({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory Writer.fromJson(Map<String, dynamic> json) {
    return Writer(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
    );
  }
}
