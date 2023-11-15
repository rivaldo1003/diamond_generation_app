import 'package:diamond_generation_app/core/models/user.dart';
import 'package:diamond_generation_app/core/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  final UserRepository _userRepository;

  HomeProvider({required UserRepository userRepository})
      : _userRepository = userRepository;

  List<User> _users = [];
  List<User> _filteredUser = [];
  List<User> get users => _users;
  List<User> get filteredUser => _filteredUser;

  set users(List<User> value) {
    _users = value;
    _filteredUser = value;
    notifyListeners();
  }

  void sortUserByname() {
    _users.sort((a, b) => a.fullName.compareTo(b.fullName));
    notifyListeners();
  }

  void searchUser(String query) {
    _filteredUser = _users
        .where(
            (user) => user.fullName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
