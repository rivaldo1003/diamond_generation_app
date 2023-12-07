String getAbbreviation(String fullText) {
  final Map<String, String> prayerAbbreviations = {
    'Bejana Pembasuhan': 'BP',
    'Mesbah Bakaran': 'MB',
    'Ruang Kudus': 'RK',
    'Ruang Maha Kudus': 'RMK',
    'Nilai-Nilai GSJA SK': 'Nilai GSJA SK',
    'Tidak Berdoa': 'Tidak Berdoa'
    // Tambahkan singkatan untuk item doa lainnya di sini
  };

  return prayerAbbreviations[fullText] ?? fullText;
}
