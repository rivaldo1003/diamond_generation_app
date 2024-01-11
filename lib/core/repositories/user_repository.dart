import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/core/models/monthly_data_wpda.dart';
import 'package:diamond_generation_app/core/models/user.dart';
import 'package:diamond_generation_app/core/services/users/user_api.dart';
import 'package:flutter/material.dart';

abstract class UserRepository {
  Future<List<User>> getUsers(String urlApi);
  Future<void> loginUser(Map<String, dynamic> body, BuildContext context);
  Future<void> registerUser(Map<String, dynamic> body, BuildContext context);
  Future<void> submitDataUser(
      Map<String, dynamic> body, BuildContext context, String token, String id);
  Future<Map<String, dynamic>> getUserProfile(int userId, String token);
  Future<List<AllUsers>> getAllUser(String token);
  Future<void> approveUser(BuildContext context, String token, String id);
  Future<void> deleteUser(String userId, BuildContext context, String token);
  Future<void> updateProfile(BuildContext context, Map<String, dynamic> body,
      String userId, String token);
  Future<Map<String, dynamic>> getTotalNewUsers(String token);
  Future<ApiResponse> getMonthlyDataForAllUsers(String token);
  Future<void> verifyUser(
      BuildContext context, Map<String, dynamic> body, String token);
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
    Map<String, dynamic> body,
    BuildContext context,
    String token,
    String id,
  ) async {
    await userApi.submitDataUser(body, context, token, id);
  }

  @override
  Future<Map<String, dynamic>> getUserProfile(int userId, String token) async {
    return await userApi.getUserProfile(userId, token);
  }

  @override
  Future<List<AllUsers>> getAllUser(String token) async {
    return await userApi.getAllUsers(token);
  }

  @override
  Future<void> approveUser(
      BuildContext context, String token, String id) async {
    await userApi.approveUser(context, token, id);
  }

  @override
  Future<void> deleteUser(
      String userId, BuildContext context, String token) async {
    await userApi.deleteUser(userId, context, token);
  }

  @override
  Future<void> updateProfile(BuildContext context, Map<String, dynamic> body,
      String userId, String token) async {
    await userApi.updateProfile(context, userId, token, body);
  }

  @override
  Future<Map<String, dynamic>> getTotalNewUsers(String token) async {
    return await userApi.getTotalNewUsers(token);
  }

  @override
  Future<ApiResponse> getMonthlyDataForAllUsers(String token) async {
    return await userApi.getMonthlyDataForAllUsers(token);
  }

  @override
  Future<void> verifyUser(
      BuildContext context, Map<String, dynamic> body, String token) async {
    await userApi.verifyUser(context, body, token);
  }
}
