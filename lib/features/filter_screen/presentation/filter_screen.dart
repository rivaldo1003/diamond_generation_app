import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/core/models/monthly_report.dart';
import 'package:diamond_generation_app/core/usecases/get_wpda_usecase.dart';
import 'package:diamond_generation_app/features/history_wpda/widgets/card_history_wpda.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:diamond_generation_app/shared/widgets/placeholder_card_wpda.dart';
import 'package:diamond_generation_app/shared/widgets/placeholder_history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterScreen extends StatefulWidget {
  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? token;

  Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString(SharedPreferencesManager.keyToken);
      print(token);
    });
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final getWpdaUsecase = Provider.of<GetWpdaUsecase>(context);
    return Scaffold(
        appBar: AppBarWidget(title: 'Filter WPDA'),
        body: FutureBuilder<MonthlyReport>(
          future: Future.delayed(
            Duration(milliseconds: 500),
            () => getWpdaUsecase.fetchWpdaByMonth(
                context, token!, '32', 12, 2023),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return PlaceholderCardWpda();
            } else {
              final history = snapshot.data;
              if (snapshot.hasError) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/emoji.png',
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Ada gangguan sepertinya',
                              style: MyFonts.customTextStyle(
                                16,
                                FontWeight.bold,
                                MyColor.whiteColor,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Coba lagi atau kembali nanti.',
                              style: MyFonts.customTextStyle(
                                12,
                                FontWeight.w500,
                                MyColor.greyText,
                              ),
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ButtonWidget(
                                title: 'Coba Lagi',
                                onPressed: () async {},
                                color: MyColor.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      PlaceholderHistory(),
                      PlaceholderHistory(),
                      PlaceholderHistory(),
                      PlaceholderHistory(),
                      SizedBox(height: 12),
                    ],
                  ),
                );
              } else {
                if (history!.data.isEmpty) {
                  return Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/emoji.png',
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),
                            SizedBox(height: 8),
                            Center(
                              child: Text(
                                'Belum ada riwayat WPDA',
                                style: MyFonts.customTextStyle(
                                  14,
                                  FontWeight.w500,
                                  MyColor.whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  history.data.sort((a, b) => DateTime.parse(b.createdAt)
                      .compareTo(DateTime.parse(a.createdAt)));
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          child: RefreshIndicator(
                              onRefresh: () async {},
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                // controller: _scrollController,
                                itemCount: history.data.length,
                                itemBuilder: (context, index) {
                                  final monthlyReport = history.data[index];
                                  return Text('data');
                                },
                              ))),
                    ],
                  );
                }
              }
            }
          },
        ));
  }
}
