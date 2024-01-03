import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/core/models/monthly_report.dart';
import 'package:diamond_generation_app/core/usecases/get_wpda_usecase.dart';
import 'package:diamond_generation_app/features/history_wpda/data/detail_history_provider.dart';
import 'package:diamond_generation_app/features/history_wpda/widgets/card_history_wpda.dart';
import 'package:diamond_generation_app/features/history_wpda/widgets/card_monthly_report.dart';
import 'package:diamond_generation_app/features/history_wpda/widgets/month_drop_down.dart';
import 'package:diamond_generation_app/features/history_wpda/widgets/placeholder_ranking.dart';
import 'package:diamond_generation_app/features/history_wpda/widgets/year_drop_down.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/wpda_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:diamond_generation_app/shared/widgets/placeholder_card_wpda.dart';
import 'package:diamond_generation_app/shared/widgets/placeholder_history.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailHistoryWPDA extends StatefulWidget {
  @override
  State<DetailHistoryWPDA> createState() => _DetailHistoryWPDAState();
}

class _DetailHistoryWPDAState extends State<DetailHistoryWPDA> {
  String? token;
  String? userId;

  Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString(SharedPreferencesManager.keyToken);
      print(token);
    });
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString(SharedPreferencesManager.keyUserId);
    });
    return userId;
  }

  late DetailHistoryProvider? detailHistoryProvider;

  @override
  void initState() {
    getUserId();
    getToken();
    detailHistoryProvider =
        Provider.of<DetailHistoryProvider>(context, listen: false);
    _getCurrentYear();
    super.initState();
  }

  String _getCurrentYear() {
    final String year = detailHistoryProvider!.selectedYear;
    print('YEAR OUTPUT :${year}');
    return year;
  }

  String _getCurrentMonth() {
    final now = DateTime.now();
    final monthFormat = DateFormat('MMMM', 'id_ID');
    return monthFormat.format(now);
  }

  @override
  Widget build(BuildContext context) {
    final detailHistoryProvider = Provider.of<DetailHistoryProvider>(context);
    final wpdaProvider = Provider.of<WpdaProvider>(context);
    final getWpdaUsecase = Provider.of<GetWpdaUsecase>(context);
    String monthName = detailHistoryProvider.selectedMonth;
    int monthNumber = MonthConverter.monthNameToNumber(monthName);
    int currentYear = int.parse(_getCurrentYear());

    return Scaffold(
      appBar: AppBarWidget(title: 'Detail History WPDA'),
      body: FutureBuilder(
        future: Future.delayed(
          Duration(milliseconds: 300),
          () => getWpdaUsecase.fetchWpdaByMonth(
              context,
              (token == null) ? '' : token!,
              (userId == null) ? '' : userId!,
              monthNumber,
              currentYear),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return PlaceholderCardWpda();
          } else {
            if (snapshot.hasData) {
              final dataWpda = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Tahun',
                            style: MyFonts.customTextStyle(
                              16,
                              FontWeight.bold,
                              MyColor.primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: YearDropDown(),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: MonthDropDown(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: MyColor.colorBlackBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DetailHistoryItem(
                              title: 'Total WPDA',
                              output: dataWpda!.totalWpda.toString()),
                          SizedBox(height: 2),
                          DetailHistoryItem(
                              title: 'Nilai', output: dataWpda.grade),
                          SizedBox(height: 2),
                          DetailHistoryItem(
                            title: 'Hari Terlewat',
                            output:
                                dataWpda.missedDaysTotalThisMonth.toString(),
                            textColor: MyColor.colorRed,
                          ),
                          SizedBox(height: 2),
                          DetailHistoryItem(
                              title: 'Doa Tabernakel', output: '-'),
                        ],
                      ),
                    ),
                  ),
                  (snapshot.data!.data.isNotEmpty)
                      ? Expanded(
                          child: RefreshIndicator(
                          onRefresh: () async {
                            await wpdaProvider.refreshWpdaHistory(
                                (userId == null) ? '' : userId!,
                                (token == null) ? '' : token!);
                          },
                          child: ListView.builder(
                            itemCount: snapshot.data!.data.length,
                            itemBuilder: (context, index) {
                              snapshot.data!.data.sort((a, b) =>
                                  DateTime.parse(b.createdAt)
                                      .compareTo(DateTime.parse(a.createdAt)));
                              return CardMonthlyReport(
                                reportData: snapshot.data!.data[index],
                              );
                            },
                          ),
                        ))
                      : // _buildHeaderWidget(context, history),
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
                                  'Belum ada riwayat WPDA  dibulan $monthName ${_getCurrentYear()}',
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                        color: MyColor.primaryColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ranking',
                              style: MyFonts.customTextStyle(
                                18,
                                FontWeight.bold,
                                MyColor.whiteColor,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '1',
                                  style: MyFonts.customTextStyle(
                                    18,
                                    FontWeight.bold,
                                    MyColor.whiteColor,
                                  ),
                                ),
                                Text(
                                  ' / ${dataWpda.totalUsers}',
                                  style: MyFonts.customTextStyle(
                                    12,
                                    FontWeight.w500,
                                    MyColor.whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        DetailHistoryItem(
                          title: 'Total Semua WPDA',
                          output: dataWpda.totalAllWpda.toString(),
                          textColor: MyColor.whiteColor,
                        ),
                        SizedBox(height: 2),
                        DetailHistoryItem(
                          title: 'Rata-Rata Nilai',
                          output: 'A',
                          textColor: MyColor.whiteColor,
                        ),
                        SizedBox(height: 2),
                        DetailHistoryItem(
                          title: 'Total Hari Terlewat',
                          output: dataWpda.missedDaysTotal.toString(),
                          textColor: MyColor.colorRed,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (!snapshot.hasData || snapshot.data == null) {
              return PlaceholderCardWpda();
            } else {
              return Center(
                child: Text('No data'),
              );
            }
          }
        },
      ),
    );
  }
}

class DetailHistoryItem extends StatelessWidget {
  final String title;
  final String output;
  Color? textColor;

  DetailHistoryItem({
    super.key,
    required this.title,
    required this.output,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: MyFonts.customTextStyle(
            14,
            FontWeight.w500,
            MyColor.whiteColor,
          ),
        ),
        Text(
          output,
          style: MyFonts.customTextStyle(
            14,
            FontWeight.bold,
            (textColor != null) ? textColor : MyColor.colorLightBlue,
          ),
        ),
      ],
    );
  }
}
