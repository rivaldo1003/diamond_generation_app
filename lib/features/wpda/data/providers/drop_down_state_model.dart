import 'package:flutter/material.dart';

class DropdownStateModel extends ChangeNotifier {
  String? _selectedItem = 'Semua'; // Set nilai default menjadi 'Semua'

  String? get selectedItem => _selectedItem;

  void setSelectedItem(String? value) {
    _selectedItem = value;
    notifyListeners();
  }
}
