class Partner {
  final String partnerName;
  final int childrenCount;

  Partner({
    required this.partnerName,
    required this.childrenCount,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      partnerName: json['partner_name'].toString(),
      childrenCount: json['children_count'] as int,
    );
  }
}
