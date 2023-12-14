import 'package:diamond_generation_app/core/models/all_users.dart';
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

  Future<void> deleteUser(String userId, BuildContext context) async {
    await userRepository.deleteUser(userId, context);
  }
}
