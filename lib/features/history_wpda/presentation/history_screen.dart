import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/core/usecases/get_wpda_usecase.dart';
import 'package:diamond_generation_app/features/filter_screen/presentation/filter_screen.dart';
import 'package:diamond_generation_app/features/history_wpda/widgets/card_history_wpda.dart';
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
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? token;

  Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString(SharedPreferencesManager.keyToken);
      print('Ini token saya : $token');
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
    final wpdaProvider = Provider.of<WpdaProvider>(context);
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Riwayat WPDA',
        action: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.history,
                color: MyColor.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<LoginProvider>(
        builder: (context, value, _) {
          if (value.userId == null) {
            value.loadUserId();
            print('INI VALUE DARI SF : ${value.userId}');
            return Center(child: CircularProgressIndicator());
          } else {
            return FutureBuilder<History>(
              future: Future.delayed(
                Duration(milliseconds: 500),
                () => getWpdaUsecase.getAllWpdaByUserID(value.userId!, token!),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: ButtonWidget(
                                    title: 'Coba Lagi',
                                    onPressed: () async {
                                      await wpdaProvider.refreshWpdaHistory(
                                          value.userId!, token!);
                                    },
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
                        children: [
                          _buildHeaderWidget(context, history),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                await wpdaProvider.refreshWpdaHistory(
                                    value.userId!, token!);
                              },
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                itemCount: history.data.length,
                                itemBuilder: (context, index) {
                                  final historyWpda = history.data[index];
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
                      totalWpda: 'C',
                      color: MyColor.colorLightBlue,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: CardHeaderHistoryWpda(
                      title: 'HARI TERLEWAT',
                      totalWpda: '0',
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
                'WPDA tidak ditemukan. Server sedang dalam perbaikan',
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
                        totalWpda: history!.totalWPDA.toString(),
                        color: MyColor.colorGreen,
                        onTap: () {},
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: CardHeaderHistoryWpda(
                        title: 'NILAI',
                        totalWpda: (history.data.isEmpty) ? 'C' : history.grade,
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
                        totalWpda: (history.missedDaysTotal == -1)
                            ? '0'
                            : history.missedDaysTotal
                                .toString(), // Replace with the actual missed day value
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
