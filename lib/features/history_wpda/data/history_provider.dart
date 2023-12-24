import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryProvider with ChangeNotifier {
  List<String> _tanggalList = [
    'Bulan ini',
    'Semua',
    'Hari ini',
    'Kemarin',
    '7 Hari Terakhir',
    '30 Hari Terakhir',
  ];

  String _selectedTanggal = 'Bulan ini';
  String _currentMonth = '';

  List<String> get tanggalList => _tanggalList;
  String get selectedTanggal => _selectedTanggal;
  String get currentMonth => _currentMonth;

  void updateSelectedTanggal(String newSelectedTanggal) {
    _selectedTanggal = newSelectedTanggal;
    notifyListeners();
  }

  String _getCurrentMonth() {
    final now = DateTime.now();
    final monthFormat = DateFormat('MMMM', 'id_ID');
    return monthFormat.format(now);
  }
}
