import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/core/models/user.dart';
import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/core/services/api_services.dart';
import 'package:flutter/material.dart';

abstract class UserRepository {
  Future<List<User>> getUsers(String urlApi);
  Future<void> loginUser(Map<String, dynamic> body, BuildContext context);
  Future<void> registerUser(Map<String, dynamic> body, BuildContext context);
  Future<void> submitDataUser(Map<String, dynamic> body, BuildContext context);
  Future<Map<String, dynamic>> getUserProfile(int userId);
  Future<List<AllUsers>> getAllUser();
  Future<void> createWpda(Map<String, dynamic> body, BuildContext context);
  Future<List<WPDA>> getAllWpda();
  Future<List<HistoryWpda>> getAllWpdaByUserId(String userId);
}

class UserRepositoryImpl implements UserRepository {
  final ApiService apiService;

  UserRepositoryImpl({
    required this.apiService,
  });
  @override
  Future<List<User>> getUsers(String urlApi) async {
    return await apiService.getUser(urlApi);
  }

  @override
  Future<void> loginUser(
      Map<String, dynamic> body, BuildContext context) async {
    await apiService.loginUser(body, context);
  }

  Future<void> registerUser(
      Map<String, dynamic> body, BuildContext context) async {
    await apiService.registerUser(body, context);
  }

  @override
  Future<void> submitDataUser(
      Map<String, dynamic> body, BuildContext context) async {
    await apiService.submitDataUser(body, context);
  }

  @override
  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    return await apiService.getUserProfile(userId);
  }

  @override
  Future<List<AllUsers>> getAllUser() async {
    return await apiService.getAllUsers();
  }

  @override
  Future<void> createWpda(
      Map<String, dynamic> body, BuildContext context) async {
    await apiService.createWpda(body, context);
  }

  @override
  Future<List<WPDA>> getAllWpda() async {
    return await apiService.getAllWpda();
  }

  @override
  Future<List<HistoryWpda>> getAllWpdaByUserId(String userId) async {
    return await apiService.getAllWpdaByUserId(userId);
  }
}
