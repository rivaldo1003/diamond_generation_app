import 'package:flutter/material.dart';
import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';

class SearchUserProvider with ChangeNotifier {
  final GetUserUsecase _getUserUsecase;
  SearchUserProvider({required GetUserUsecase getUserUsecase})
      : _getUserUsecase = getUserUsecase;

  bool _isApproved = false;
  bool _isSortedByName = false;

  bool get isApproved => _isApproved;
  List<AllUsers> userData = [];
  List<AllUsers> filteredUserData = [];

  Future<void> fetchData(BuildContext context, String urlApi) async {
    try {
      List<AllUsers> allUsers = await _getUserUsecase.getAllUsers();
      userData = allUsers;
      filteredUserData = allUsers;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  int countUnapprovedUsers(List<AllUsers> users) {
    int count = 0;
    for (var user in users) {
      if (user.statusPersetujuan != "approved") {
        count++;
      }
    }
    return count;
  }

  Future refreshAllUsers() async {
    userData = await _getUserUsecase.getAllUsers();
    notifyListeners();
  }

  Future<void> sortUser() async {
    if (_isSortedByName) {
      userData.sort((a, b) => a.id.compareTo(b.id));
    } else {
      userData.sort((a, b) => a.fullName.compareTo(b.fullName));
    }
    _isSortedByName = !_isSortedByName;
    notifyListeners();
  }

  void searchUser(String query) {
    List<AllUsers> filteredUsers = userData
        .where(
            (user) => user.fullName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    filteredUserData = filteredUsers;
    notifyListeners();
  }

  void approvedUserButton() {
    _isApproved = true;
    Future.delayed(Duration(seconds: 2), () {
      notifyListeners();
    });
  }

  Future<void> approveUser(
      Map<String, dynamic> body, BuildContext context) async {
    await _getUserUsecase.approveUser(body, context);
    Future.delayed(Duration(seconds: 2), () {
      notifyListeners();
    });
  }

  Future<void> deleteData(String userId, BuildContext context) async {
    await _getUserUsecase.deleteUser(userId, context);
    Future.delayed(Duration(seconds: 2), () {
      notifyListeners();
    });
  }
}
