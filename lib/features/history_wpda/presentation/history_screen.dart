import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:diamond_generation_app/features/history_wpda/widgets/card_history_wpda.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final getUserUsecase = Provider.of<GetUserUsecase>(context);
    return Scaffold(
      appBar: AppBarWidget(title: 'History WPDA'),
      body: Consumer<LoginProvider>(
        builder: (context, value, _) {
          if (value.userId == null) {
            value.loadUserId();
            return Center(child: CircularProgressIndicator());
          } else {
            return FutureBuilder<History>(
              future: getUserUsecase.getAllWpdaByUserID(value.userId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final history = snapshot.data;
                  if (history == null || history.history.isEmpty) {
                    return _buildDataNotFoundWidget(context, history!);
                  } else {
                    return Column(
                      children: [
                        _buildHeaderWidget(context, history),
                        Expanded(
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
                      ],
                    );
                  }
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildDataNotFoundWidget(BuildContext context, History history) {
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
                          'Perhitungan catatan WPDA dibawah ini adalah dalam 1 bulan terakhir terhitung setelah anda mendaftar.',
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
                      title: 'GRADE',
                      totalWpda:
                          (history.history.isEmpty) ? 'C' : history.grade,
                      color: MyColor.colorLightBlue,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: CardHeaderHistoryWpda(
                      title: 'MISSED DAY',
                      totalWpda: history
                          .missed_days_total, // Show '0' for missed day when history is empty
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
                'WPDA data not found!',
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

  Widget _buildHeaderWidget(BuildContext context, History history) {
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
                            'Perhitungan catatan WPDA dibawah ini adalah dalam 1 bulan terakhir terhitung setelah anda mendaftar.',
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
                        totalWpda: history.history.length.toString(),
                        color: MyColor.colorGreen,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: CardHeaderHistoryWpda(
                        title: 'GRADE',
                        totalWpda:
                            history.history.isEmpty ? 'C' : history.grade,
                        color: MyColor.colorLightBlue,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: CardHeaderHistoryWpda(
                        title: 'MISSED DAY',
                        totalWpda: history.missed_days_total,
                        color: MyColor.colorRed,
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

  const CardHeaderHistoryWpda({
    super.key,
    required this.totalWpda,
    required this.title,
    required this.color,
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
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: MyFonts.customTextStyle(
                  12,
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
