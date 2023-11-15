class WPDA {
  final String id;
  final String userId;
  final String kitabBacaan;
  final String isiKitab;
  final String pesanTuhan;
  final String aplikasiKehidupan;
  final String createdAt;
  final String fullName;
  final String email;

  WPDA({
    required this.id,
    required this.userId,
    required this.kitabBacaan,
    required this.isiKitab,
    required this.pesanTuhan,
    required this.aplikasiKehidupan,
    required this.createdAt,
    required this.fullName,
    required this.email,
  });

  factory WPDA.fromJson(Map<String, dynamic> json) {
    return WPDA(
      id: json['id'],
      userId: json['user_id'],
      kitabBacaan: json['kitab_bacaan'],
      isiKitab: json['isi_kitab'],
      pesanTuhan: json['pesan_tuhan'],
      aplikasiKehidupan: json['aplikasi_kehidupan'],
      createdAt: json['created_at'].toString(),
      fullName: json['full_name'],
      email: json['email'],
    );
  }
}
