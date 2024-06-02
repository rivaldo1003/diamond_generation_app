import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/core/models/monthly_data_wpda.dart';
import 'package:diamond_generation_app/core/models/user.dart';
import 'package:diamond_generation_app/core/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class GetUserUsecase {
  final UserRepository userRepository;

  GetUserUsecase({
    required this.userRepository,
  });

  Future<List<User>> execute(String urlApi) async {
    return await userRepository.getUsers(urlApi);
  }

  Future<void> loginUser(
      Map<String, dynamic> body, BuildContext context) async {
    await userRepository.loginUser(body, context);
  }

  Future<void> registerUser(
      Map<String, dynamic> body, BuildContext context) async {
    await userRepository.registerUser(body, context);
  }

  Future<void> submitDataUser(Map<String, dynamic> body, BuildContext context,
      String token, String id) async {
    await userRepository.submitDataUser(body, context, token, id);
  }

  Future<Map<String, dynamic>> getUserProfile(int userId, String token) async {
    return await userRepository.getUserProfile(userId, token);
  }

  Future<List<AllUsers>> getAllUsers(String token) async {
    return await userRepository.getAllUser(token);
  }

  Future<void> approveUser(
      BuildContext context, String token, String id) async {
    await userRepository.approveUser(context, token, id);
  }

  Future<void> deleteUser(
      String userId, BuildContext context, String token) async {
    await userRepository.deleteUser(userId, context, token);
  }

  Future<void> updateProfile(String userId, BuildContext context, String token,
      Map<String, dynamic> body) async {
    await userRepository.updateProfile(context, body, userId, token);
  }

  Future<Map<String, dynamic>> getTotalNewUsers(String token) async {
    return await userRepository.getTotalNewUsers(token);
  }

  Future<ApiResponse> getMonthlyDataForAllUsers(String token) async {
    return await userRepository.getMonthlyDataForAllUsers(token);
  }

  Future<void> verifyUser(
      BuildContext context, Map<String, dynamic> body, String token) async {
    return await userRepository.verifyUser(context, body, token);
  }

  Future<Map<String, dynamic>> userGenderTotal(String token) async {
    return await userRepository.userGenderTotal(token);
  }

  Future<void> updateFullName(BuildContext context, Map<String, dynamic> body,
      String userId, String token) async {
    return await userRepository.updateFullName(context, body, userId, token);
  }

  Future<void> logout(BuildContext context, String token) async {
    return await userRepository.logout(context, token);
  }

  Future<void> verifyEmail(
      BuildContext context, String token, String email) async {
    return await userRepository.verifyEmail(context, token, email);
  }

  Future<void> forgetPassword(
      BuildContext context, Map<String, dynamic> body) async {
    return await userRepository.forgetPassword(context, body);
  }

  Future<void> changeRole(BuildContext context, Map<String, dynamic> body,
      String id, String token) async {
    return await userRepository.changeRole(context, body, id, token);
  }
}
