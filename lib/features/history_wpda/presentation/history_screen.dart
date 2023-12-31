import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/core/usecases/get_wpda_usecase.dart';
import 'package:diamond_generation_app/features/filter_screen/presentation/filter_screen.dart';
import 'package:diamond_generation_app/features/history_wpda/widgets/card_history_wpda.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/wpda_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final getWpdaUsecase = Provider.of<GetWpdaUsecase>(context);
    final wpdaProvider = Provider.of<WpdaProvider>(context);
    return Scaffold(
      appBar: AppBarWidget(title: 'Riwayat WPDA'),
      body: Consumer<LoginProvider>(
        builder: (context, value, _) {
          if (value.userId == null) {
            value.loadUserId();
            return Center(child: CircularProgressIndicator());
          } else {
            return FutureBuilder<History>(
              future: getWpdaUsecase.getAllWpdaByUserID(value.userId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final history = snapshot.data;
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          'Server sedang dalam masalah! Riwayat WPDA tidak ditemukan'),
                    );
                  } else {
                    if (history!.history.isEmpty) {
                      return Column(
                        children: [
                          _buildHeaderWidget(context, history),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/emoji.png',
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                ),
                                SizedBox(height: 8),
                                Center(
                                  child: Text(
                                    'WPDA data is empty!',
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
                      return Column(
                        children: [
                          _buildHeaderWidget(context, history),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                await wpdaProvider
                                    .refreshWpdaHistory(value.userId!);
                              },
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                itemCount: history.history.length,
                                itemBuilder: (context, index) {
                                  final historyWpda = history.history[index];
                                  return CardHistoryWpda(
                                    historyWpda: historyWpda,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildDataNotFoundWidget(BuildContext context, History? history) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: MyColor.greyText,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info,
                        color: MyColor.whiteColor,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Perhitungan catatan WPDA dibawah ini adalah terhitung sejak anda mendaftar.',
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
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CardHeaderHistoryWpda(
                      title: 'TOTAL WPDA',
                      totalWpda: '0',
                      color: MyColor.colorGreen,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: CardHeaderHistoryWpda(
                      title: 'NILAI',
                      totalWpda: history!.grade,
                      color: MyColor.colorLightBlue,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: CardHeaderHistoryWpda(
                      title: 'HARI TERLEWAT',
                      totalWpda:
                          (history == null) ? '0' : history.missed_days_total,
                      color: MyColor.colorRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width / 2 - 50,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/emoji.png',
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'WPDA data not found! Server error',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.w500,
                  MyColor.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderWidget(BuildContext context, History? history) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: MyColor.greyText,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info,
                          color: MyColor.whiteColor,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Perhitungan catatan WPDA dibawah ini adalah terhitung sejak anda mendaftar.',
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
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CardHeaderHistoryWpda(
                        title: 'TOTAL WPDA',
                        totalWpda: history!.history.length.toString(),
                        color: MyColor.colorGreen,
                        onTap: () {},
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: CardHeaderHistoryWpda(
                        title: 'NILAI',
                        totalWpda:
                            (history.history.isEmpty) ? 'C' : history.grade,
                        color: MyColor.colorLightBlue,
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return FilterScreen();
                          }));
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: CardHeaderHistoryWpda(
                        title: 'HARI TERLEWAT',
                        totalWpda: (history.missed_days_total == "-1")
                            ? '0'
                            : history
                                .missed_days_total, // Replace with the actual missed day value
                        color: MyColor.colorRed,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardHeaderHistoryWpda extends StatelessWidget {
  final String title;
  final String totalWpda;
  final Color color;
  void Function()? onTap;

  CardHeaderHistoryWpda({
    super.key,
    required this.totalWpda,
    required this.title,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          splashColor: MyColor.primaryColor,
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: MyFonts.customTextStyle(
                  10,
                  FontWeight.bold,
                  MyColor.whiteColor,
                ),
              ),
              Text(
                totalWpda,
                style: MyFonts.customTextStyle(
                  18,
                  FontWeight.bold,
                  MyColor.whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
