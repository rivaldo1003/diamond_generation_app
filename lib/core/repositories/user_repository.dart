import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/core/models/user.dart';
import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/core/services/users/user_api.dart';
import 'package:flutter/material.dart';

abstract class UserRepository {
  Future<List<User>> getUsers(String urlApi);
  Future<void> loginUser(Map<String, dynamic> body, BuildContext context);
  Future<void> registerUser(Map<String, dynamic> body, BuildContext context);
  Future<void> submitDataUser(Map<String, dynamic> body, BuildContext context);
  Future<Map<String, dynamic>> getUserProfile(int userId);
  Future<List<AllUsers>> getAllUser();
  Future<void> approveUser(Map<String, dynamic> body, BuildContext context);
  Future<void> deleteUser(String userId, BuildContext context);
}

class UserRepositoryImpl implements UserRepository {
  final UserApi userApi;

  UserRepositoryImpl({
    required this.userApi,
  });
  @override
  Future<List<User>> getUsers(String urlApi) async {
    return await userApi.getUser(urlApi);
  }

  @override
  Future<void> loginUser(
      Map<String, dynamic> body, BuildContext context) async {
    await userApi.loginUser(body, context);
  }

  Future<void> registerUser(
      Map<String, dynamic> body, BuildContext context) async {
    await userApi.registerUser(body, context);
  }

  @override
  Future<void> submitDataUser(
      Map<String, dynamic> body, BuildContext context) async {
    await userApi.submitDataUser(body, context);
  }

  @override
  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    return await userApi.getUserProfile(userId);
  }

  @override
  Future<List<AllUsers>> getAllUser() async {
    return await userApi.getAllUsers();
  }

  @override
  Future<void> approveUser(
      Map<String, dynamic> body, BuildContext context) async {
    await userApi.approveUser(body, context);
  }

  @override
  Future<void> deleteUser(String userId, BuildContext context) async {
    await userApi.deleteUser(userId, context);
  }
}
