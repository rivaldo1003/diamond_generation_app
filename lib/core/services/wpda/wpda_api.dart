import 'dart:convert';
import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/features/bottom_nav_bar/bottom_navigation_page.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/edit_wpda_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/wpda_provider.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WpdaApi {
  final String urlApi;

  WpdaApi({
    required this.urlApi,
  });

  Future<void> createWpda(
      Map<String, dynamic> body, BuildContext context) async {
    final wpdaProvider = Provider.of<WpdaProvider>(context, listen: false);
    final headers = {
      "Content-Type": "application/json",
    };
    final response = await http.post(
      Uri.parse(ApiConstants.createWpdaUrl),
      headers: headers,
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? role = prefs.getString(SharedPreferencesManager.keyRole);
      if (data['success']) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            });
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return BottomNavigationPage(
                index: (role == "admin") ? 1 : 0,
              );
            }),
            (route) => false,
          );
          wpdaProvider.aplikasiKehidupanController.text = '';
          wpdaProvider.isiKitabController.text = '';
          wpdaProvider.kitabBacaanController.text = '';
          wpdaProvider.pesanTuhanController.text = '';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColor.colorGreen,
              content: Text(
                '${data['message']}',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.w500,
                  MyColor.whiteColor,
                ),
              ),
            ),
          );
        });
      } else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            });
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColor.colorRed,
              content: Text(
                '${data['message']}',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.w500,
                  MyColor.whiteColor,
                ),
              ),
            ),
          );
        });
      }
    } else {
      throw Exception('Failed to create WPDA');
    }
  }

  Future<List<WPDA>> getAllWpda() async {
    final headers = {"Content-Type": "application/json"};
    final response = await http.get(
      Uri.parse(ApiConstants.getAllWpdaUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body)['wpda'];
      return jsonResponse.map((json) {
        return WPDA.fromJson(json);
      }).toList();
    } else {
      throw Exception('Failed to get all wpda data');
    }
  }

  Future<void> editWpda(Map<String, dynamic> body, BuildContext context) async {
    final editWpdaProvider =
        Provider.of<EditWpdaProvider>(context, listen: false);
    final headers = {"Content-Type": "application/json"};
    final response = await http.post(
      Uri.parse(ApiConstants.editWpdaUrl),
      headers: headers,
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? role = prefs.getString(SharedPreferencesManager.keyRole);
      if (data['success']) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            });
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return BottomNavigationPage(
                index: (role == "admin") ? 1 : 0,
              );
            }),
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColor.colorGreen,
              content: Text(
                '${data['message']}',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.w500,
                  MyColor.whiteColor,
                ),
              ),
            ),
          );
        });
        editWpdaProvider.aplikasiKehidupanController.text = '';
        editWpdaProvider.isiKitabController.text = '';
        editWpdaProvider.kitabBacaanController.text = '';
        editWpdaProvider.pesanTuhanController.text = '';
      } else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            });
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return BottomNavigationPage(
                index: (role == "admin") ? 1 : 0,
              );
            }),
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColor.colorRed,
              content: Text(
                '${data['message']}',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.w500,
                  MyColor.whiteColor,
                ),
              ),
            ),
          );
        });
      }
    } else {
      throw Exception('Failed edit data');
    }
  }

  Future<void> deleteWpda(
      Map<String, dynamic> body, BuildContext context) async {
    final headers = {"Content-Type": "application/jon"};
    final response = await http.post(
      Uri.parse(ApiConstants.deleteWpdaUrl),
      headers: headers,
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? role = prefs.getString(SharedPreferencesManager.keyRole);
      if (data['success']) {
        print(role);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            });
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return BottomNavigationPage(
                index: (role == "admin") ? 1 : 0,
              );
            }),
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColor.colorGreen,
              content: Text(
                '${data['message']}',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.w500,
                  MyColor.whiteColor,
                ),
              ),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: MyColor.colorGreen,
            content: Text(
              '${data['message']}',
              style: MyFonts.customTextStyle(
                14,
                FontWeight.w500,
                MyColor.whiteColor,
              ),
            ),
          ),
        );
      }
    } else {
      throw Exception('Failed to delete data');
    }
  }
}
