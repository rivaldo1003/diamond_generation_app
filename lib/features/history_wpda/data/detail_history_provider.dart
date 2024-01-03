import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailHistoryProvider with ChangeNotifier {
  List<String> _monthList = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  List<String> _yearList = [
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
  ];

  // MONTH
  String _selectedMonth = '';
  String _currentMonth = '';

  //YEAR
  String _selectedYear = '';
  String _currentYear = '';

  //MONTH
  List<String> get monthList => _monthList;
  String get selectedMonth => _selectedMonth;
  String get currentMonth => _currentMonth;

  //YEAR
  List<String> get yearList => _yearList;
  String get selectedYear => _selectedYear;
  String get currentYear => _currentYear;

  DetailHistoryProvider() {
    _selectedMonth = _getCurrentMonth();
    _selectedYear = _getCurrentYear();
  }

  void updateSelectedMonth(String newSelectedMonth) {
    _selectedMonth = newSelectedMonth;
    notifyListeners();
  }

  void updateSelectedYear(String newSelectedYear) {
    _selectedYear = newSelectedYear;
    notifyListeners();
  }

  String _getCurrentMonth() {
    final now = DateTime.now();
    final monthFormat = DateFormat('MMMM', 'id_ID');
    _currentMonth = monthFormat.format(now); // Update _currentMonth juga
    return _currentMonth;
  }

  String _getCurrentYear() {
    final now = DateTime.now();
    final monthFormat = DateFormat('yyyy', 'id_ID');
    _currentMonth = monthFormat.format(now); // Update _currentMonth juga
    return _currentMonth;
  }
}
