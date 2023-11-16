// import 'package:diamond_generation_app/core/models/all_users.dart';
// import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
// import 'package:flutter/material.dart';

// class ViewAllDataProvider with ChangeNotifier {
//   final GetUserUsecase _getUserUsecase;
//   ViewAllDataProvider({required GetUserUsecase getUserUsecase})
//       : _getUserUsecase = getUserUsecase;
//   bool _isApproved = false;

//   bool get isApproved => _isApproved;

//   List<AllUsers> users = [];

//   Future refreshAllUsers() async {
//     users = await _getUserUsecase.getAllUsers();
//     notifyListeners();
//   }

//   void approvedUserButton() {
//     _isApproved = true;
//     notifyListeners();
//   }

//   Future approveUser(Map<String, dynamic> body, BuildContext context) async {
//     await _getUserUsecase.approveUser(body, context);
//     Future.delayed(Duration(seconds: 2), () {
//       notifyListeners();
//     });
//   }

//   Future deleteData(String userId, BuildContext context) async {
//     await _getUserUsecase.deleteUser(userId, context);
//     Future.delayed(Duration(seconds: 2), () {
//       notifyListeners();
//     });
//   }
// }
