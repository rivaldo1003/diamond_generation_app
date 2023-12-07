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
  final String age;
  final String birthPlace;
  final String birthDate;
  final String profile_completed;
  final String statusPersetujuan;
  final String grade;
  final String missedDaysTotal;
  final List<DataWpda> dataWpda;

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
    required this.age,
    required this.birthPlace,
    required this.birthDate,
    required this.profile_completed,
    required this.dataWpda,
    required this.statusPersetujuan,
    required this.grade,
    required this.missedDaysTotal,
  });

  factory AllUsers.fromJson(Map<String, dynamic> json) {
    var wpdaHistoryList = json['wpda']['wpda_history'] as List<dynamic>;
    List<DataWpda> parsedWpdaHistoryList =
        wpdaHistoryList.map((data) => DataWpda.fromJson(data)).toList();
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
      age: json['age'].toString(),
      birthPlace: json['birth_place'].toString(),
      birthDate: json['birth_date'].toString(),
      profile_completed: json['profile_completed'].toString(),
      statusPersetujuan: json['status_persetujuan'].toString(),
      grade: json['grade'].toString(),
      missedDaysTotal: json['missed_days_total'].toString(),
      dataWpda: parsedWpdaHistoryList,
    );
  }
}

class DataWpda {
  final String id;
  final String kitabBacaan;
  final String isiKitab;
  final String aplikasiKehidupan;
  final String pesanTuhan;
  final String selectedPrayers;
  final String createdAt;

  DataWpda({
    required this.id,
    required this.kitabBacaan,
    required this.isiKitab,
    required this.aplikasiKehidupan,
    required this.pesanTuhan,
    required this.selectedPrayers,
    required this.createdAt,
  });

  factory DataWpda.fromJson(Map<String, dynamic> json) {
    return DataWpda(
      id: json['id'].toString(),
      kitabBacaan: json['kitab_bacaan'].toString(),
      isiKitab: json['isi_kitab'].toString(),
      aplikasiKehidupan: json['aplikasi_kehidupan'].toString(),
      createdAt: json['created_at'].toString(),
      pesanTuhan: json['pesan_tuhan'].toString(),
      selectedPrayers: json['selected_prayers'].toString(),
    );
  }
}
