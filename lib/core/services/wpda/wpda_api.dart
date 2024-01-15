import 'dart:convert';
import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/core/models/monthly_report.dart';
import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/features/bottom_nav_bar/bottom_navigation_page.dart';
import 'package:diamond_generation_app/features/loading_diamond/cool_loading.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/add_wpda_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/bible_provider.dart';
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
      Map<String, dynamic> body, BuildContext context, String token) async {
    final wpdaProvider = Provider.of<WpdaProvider>(context, listen: false);
    final bibleProvider = Provider.of<BibleProvider>(context, listen: false);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.createWpdaUrl),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _showSuccessSnackBar(context, wpdaProvider, bibleProvider, data);
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> data = json.decode(response.body);
        _handleError(context, wpdaProvider, data['message'], MyColor.colorRed);
      } else {
        _handleError(
            context, wpdaProvider, 'Gagal membuat WPDA', MyColor.colorRed);
      }
    } catch (e) {
      _handleError(
          context, wpdaProvider, 'Terjadi kesalahan: $e', MyColor.colorRed);
    }
  }

  void _showSuccessSnackBar(BuildContext context, WpdaProvider wpdaProvider,
      BibleProvider bibleProvider, Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString(SharedPreferencesManager.keyRole);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: CoolLoading(),
        );
      },
    );

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

      wpdaProvider.readingBookController.text = '';
      wpdaProvider.verseContentController.text = '';
      wpdaProvider.messageOfGodController.text = '';
      wpdaProvider.applicationInLifeController.text = '';
      bibleProvider.startVerseController.text = '';
      bibleProvider.endVerseController.text = '';

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
  }

  void _handleError(BuildContext context, WpdaProvider wpdaProvider,
      String errorMessage, Color snackBarColor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString(SharedPreferencesManager.keyRole);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: CoolLoading(),
        );
      },
    );

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

      wpdaProvider.readingBookController.text = '';
      wpdaProvider.verseContentController.text = '';
      wpdaProvider.messageOfGodController.text = '';
      wpdaProvider.applicationInLifeController.text = '';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: snackBarColor,
          content: Text(
            errorMessage,
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

  Future<List<WPDA>> getAllWpda(String token) async {
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${token}',
    };
    String imageUrlWithTimestamp =
        "${ApiConstants.getAllWpdaUrl}?timestamp=${DateTime.now().millisecondsSinceEpoch}";
    final response = await http.get(
      Uri.parse(imageUrlWithTimestamp),
      headers: headers,
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((json) {
        return WPDA.fromJson(json);
      }).toList();
    } else {
      throw Exception('Failed to get all wpda data');
    }
  }

  Future<void> editWpda(Map<String, dynamic> body, BuildContext context,
      String token, String id) async {
    final editWpdaProvider =
        Provider.of<EditWpdaProvider>(context, listen: false);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
    final response = await http.put(
      Uri.parse(ApiConstants.editWpdaUrl + '/$id'),
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
                child: CoolLoading(),
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
        editWpdaProvider.readingBookController.text = '';
        editWpdaProvider.verseContentController.text = '';
        editWpdaProvider.messageOfGodController.text = '';
        editWpdaProvider.applicationInLifeController.text = '';
      } else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(
                child: CoolLoading(),
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
                'gagal',
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
    BuildContext context,
    String id,
    String token,
  ) async {
    var url = Uri.parse(
        '${ApiConstants.baseUrl}/wpda/delete/$id'); // Sesuaikan URL dengan endpoint backend Anda

    try {
      var response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Sesuaikan token dengan token autentikasi Anda
        },
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
                  child: CoolLoading(),
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
        }
      } else if (response.statusCode == 404) {
        print('WPDA data not found');
      } else if (response.statusCode == 403) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? role = prefs.getString(SharedPreferencesManager.keyRole);
        final data = json.decode(response.body);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(
                child: CoolLoading(),
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
      } else {
        print('Failed to delete WPDA. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Exception occured while deleting WPDA: $error');
    }
  }

  Future<History> getAllWpdaByUserId(String userId, String token) async {
    final url = Uri.parse(ApiConstants.historyWpdaUrl + '/${userId}');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      return History.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load history data');
    }
  }

  Future<MonthlyReport> fetchWpdaByMonth(BuildContext context, String token,
      String userId, int month, int year) async {
    final url = Uri.parse(
      ApiConstants.historyWpdaUrl + '/filter/$userId?month=$month&year=$year',
    );
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return MonthlyReport.fromJson(jsonResponse);
    } else {
      throw Exception(
          'Failed to load history data. Status code: ${response.statusCode}');
    }
  }

  Future<void> likeWpda(int userId, int wpdaId, String token) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/like/$userId/$wpdaId');
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
    final response = await http.post(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      print('Success connect likeWpda API');
    } else {
      throw Exception('Failed to connect likeWPDA API');
    }
  }

  Future<void> unlikeWpda(int userId, int wpdaId, String token) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/unlike/$userId/$wpdaId');
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
    final response = await http.delete(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      print('Success connect unlikeWpda API');
    } else {
      throw Exception('Failed to connect unlikeWPDA API');
    }
  }
}
