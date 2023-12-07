import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/core/services/wpda/wpda_api.dart';
import 'package:flutter/material.dart';

abstract class WpdaRepository {
  Future<void> createWpda(Map<String, dynamic> body, BuildContext context);
  Future<List<WPDA>> getAllWpda();
  Future<void> editWpda(Map<String, dynamic> body, BuildContext context);
  Future<void> deleteWpda(Map<String, dynamic> body, BuildContext context);
  Future<History> getAllWpdaByUserId(String userId);
}

class WpdaRepositoryImpl implements WpdaRepository {
  final WpdaApi wpdaApi;

  WpdaRepositoryImpl({
    required this.wpdaApi,
  });

  @override
  Future<void> createWpda(
      Map<String, dynamic> body, BuildContext context) async {
    await wpdaApi.createWpda(body, context);
  }

  @override
  Future<List<WPDA>> getAllWpda() async {
    return await wpdaApi.getAllWpda();
  }

  @override
  Future<void> editWpda(Map<String, dynamic> body, BuildContext context) async {
    await wpdaApi.editWpda(body, context);
  }

  @override
  Future<void> deleteWpda(
      Map<String, dynamic> body, BuildContext context) async {
    await wpdaApi.deleteWpda(body, context);
  }

  @override
  Future<History> getAllWpdaByUserId(String userId) async {
    return await wpdaApi.getAllWpdaByUserId(userId);
  }
}
