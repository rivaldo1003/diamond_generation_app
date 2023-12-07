import 'package:flutter/material.dart';

class AddWpdaWProvider with ChangeNotifier {
  List<String> selectedItems = [];

  void addItem(String item) {
    selectedItems.add(item);
    notifyListeners();
  }

  void removeItem(String item) {
    selectedItems.remove(item);
    notifyListeners();
  }

  void editSelectedItems(bool isChecked, String item) {
    if (isChecked && !selectedItems.contains(item)) {
      selectedItems.add(item);
    } else if (!isChecked && selectedItems.contains(item)) {
      selectedItems.remove(item);
    }
    notifyListeners();
  }

  void editPrayers(List<String> updatePrayers) {
    selectedItems = updatePrayers;
    notifyListeners();
  }
}
