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
            return CircularProgressIndicator();
          } else {
            return FutureBuilder<List<HistoryWpda>>(
              future: getUserUsecase.getAllWpdaByUserID(value.userId!),
              builder: (context, snapshot) {
                var data = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'WPDA history is empty',
                          style: MyFonts.customTextStyle(
                            14,
                            FontWeight.w400,
                            MyColor.whiteColor,
                          ),
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CardHeaderHistoryWpda(
                                    title: 'TOTAL WPDA',
                                    totalWpda: snapshot.data!.length.toString(),
                                    color: MyColor.colorGreen,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: CardHeaderHistoryWpda(
                                    title: 'GRADE',
                                    totalWpda: 'A',
                                    color: MyColor.colorLightBlue,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: CardHeaderHistoryWpda(
                                    title: 'MISS',
                                    totalWpda: '1 Day',
                                    color: MyColor.colorRed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final historyWpda = data![index];
                                return CardHistoryWpda(
                                  historyWpda: historyWpda,
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  } else {
                    return Center(
                      child: Text(
                        'WPDA data is empty!',
                        style: MyFonts.customTextStyle(
                          14,
                          FontWeight.w400,
                          MyColor.whiteColor,
                        ),
                      ),
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
    );
  }
}
