class History {
  final bool success;
  final int missedDaysTotal;
  final int missedDaysLast7Days;
  final int missedDaysLast30Days;
  final String grade;
  final int totalWPDA;
  final List<HistoryWpda> data;

  History({
    required this.success,
    required this.missedDaysTotal,
    required this.missedDaysLast7Days,
    required this.missedDaysLast30Days,
    required this.grade,
    required this.totalWPDA,
    required this.data,
  });

  List<HistoryWpda> filterLast30Days() {
    final now = DateTime.now();
    final last30Days = now.subtract(Duration(days: 30));

    return data.where((item) {
      return DateTime.parse(item.createdAt).isAfter(last30Days) &&
          DateTime.parse(item.createdAt).isBefore(now);
    }).toList();
  }

  List<HistoryWpda> filterLast7Days() {
    final now = DateTime.now();
    final last7Days = now.subtract(Duration(days: 7));

    return data
        .where((item) =>
            DateTime.parse(item.createdAt).isAfter(last7Days) &&
            DateTime.parse(item.createdAt).isBefore(now))
        .toList();
  }

  List<HistoryWpda> filterByDate(String selectedDate) {
    print('Selected Date: $selectedDate');

    if (selectedDate == 'Kemarin') {
      final now = DateTime.now();
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      final startOfYesterday =
          DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 0, 0);
      final endOfYesterday =
          DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);

      return data.where((item) {
        DateTime itemDate = DateTime.parse(item.createdAt);
        return itemDate.isAfter(startOfYesterday) &&
            itemDate.isBefore(endOfYesterday);
      }).toList();
    } else {
      return data;
    }
  }

  List<HistoryWpda> onDay(String selectedDate) {
    if (selectedDate == 'Hari ini') {
      final now = DateTime.now();
      final yesterday = DateTime(now.year, now.month, now.day);

      return data.where((item) {
        DateTime itemDate = DateTime.parse(item.createdAt);
        return itemDate.isAfter(yesterday) && itemDate.isBefore(now);
      }).toList();
    } else {
      return data;
    }
  }

  factory History.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<HistoryWpda> wpdaList =
        dataList.map((item) => HistoryWpda.fromJson(item)).toList();

    return History(
      success: json['success'],
      missedDaysTotal: json['missed_days_total'],
      missedDaysLast7Days: json['missed_days_last_7_days'],
      missedDaysLast30Days: json['missed_days_last_30_days'],
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
