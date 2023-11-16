import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/core/models/user.dart';
import 'package:diamond_generation_app/core/models/wpda.dart';
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

  Future<void> submitDataUser(
      Map<String, dynamic> body, BuildContext context) async {
    await userRepository.submitDataUser(body, context);
  }

  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    return await userRepository.getUserProfile(userId);
  }

  Future<List<AllUsers>> getAllUsers() async {
    return await userRepository.getAllUser();
  }

  Future<void> createWpda(
      Map<String, dynamic> body, BuildContext context) async {
    await userRepository.createWpda(body, context);
  }

  Future<List<WPDA>> getAllWpda() async {
    return await userRepository.getAllWpda();
  }

  Future<List<HistoryWpda>> getAllWpdaByUserID(String userId) async {
    return await userRepository.getAllWpdaByUserId(userId);
  }

  Future<void> approveUser(
      Map<String, dynamic> body, BuildContext context) async {
    await userRepository.approveUser(body, context);
  }

  Future<void> deleteUser(String userId, BuildContext context) async {
    await userRepository.deleteUser(userId, context);
  }
}
