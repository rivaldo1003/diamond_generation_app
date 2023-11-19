class History {
  final bool success;
  final List<HistoryWpda> history;
  final String missed_days_total;
  final String grade;

  History({
    required this.success,
    required this.history,
    required this.missed_days_total,
    required this.grade,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    List<dynamic> historyData = json['history'] ?? [];
    List<HistoryWpda> historyList =
        historyData.map((e) => HistoryWpda.fromJson(e)).toList();

    return History(
      success: json['success'] ?? false,
      history: historyList,
      missed_days_total: json['missed_days_total'] ?? '',
      grade: json['grade'] ?? '',
    );
  }
}

class HistoryWpda {
  final String id;
  final String userId;
  final String fullName;
  final String email;
  final String kitabBacaan;
  final String isiKitab;
  final String pesanTuhan;
  final String aplikasiKehidupan;
  final String createdAt;

  HistoryWpda({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.kitabBacaan,
    required this.isiKitab,
    required this.pesanTuhan,
    required this.aplikasiKehidupan,
    required this.createdAt,
  });

  factory HistoryWpda.fromJson(Map<String, dynamic> json) {
    return HistoryWpda(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      kitabBacaan: json['kitab_bacaan'] ?? '',
      isiKitab: json['isi_kitab'] ?? '',
      pesanTuhan: json['pesan_tuhan'] ?? '',
      aplikasiKehidupan: json['aplikasi_kehidupan'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
