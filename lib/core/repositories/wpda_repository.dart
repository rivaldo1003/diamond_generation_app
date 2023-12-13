import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/core/services/wpda/wpda_api.dart';
import 'package:flutter/material.dart';

abstract class WpdaRepository {
  Future<void> createWpda(
      Map<String, dynamic> body, BuildContext context, String token);
  Future<List<WPDA>> getAllWpda(String token);
  Future<void> editWpda(
      Map<String, dynamic> body, BuildContext context, String token, String id);
  Future<void> deleteWpda(BuildContext context, String token, String id);
  Future<History> getAllWpdaByUserId(String userId, String token);
}

class WpdaRepositoryImpl implements WpdaRepository {
  final WpdaApi wpdaApi;

  WpdaRepositoryImpl({
    required this.wpdaApi,
  });

  @override
  Future<void> createWpda(
      Map<String, dynamic> body, BuildContext context, String token) async {
    await wpdaApi.createWpda(body, context, token);
  }

  @override
  Future<List<WPDA>> getAllWpda(String token) async {
    return await wpdaApi.getAllWpda(token);
  }

  @override
  Future<void> editWpda(Map<String, dynamic> body, BuildContext context,
      String token, String id) async {
    await wpdaApi.editWpda(body, context, token, id);
  }

  @override
  Future<void> deleteWpda(BuildContext context, String token, String id) async {
    await wpdaApi.deleteWpda(context, token, id);
  }

  @override
  Future<History> getAllWpdaByUserId(String userId, String token) async {
    return await wpdaApi.getAllWpdaByUserId(userId, token);
  }
}
