import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/core/models/monthly_report.dart';
import 'package:diamond_generation_app/core/usecases/get_wpda_usecase.dart';
import 'package:diamond_generation_app/features/history_wpda/data/history_provider.dart';
import 'package:diamond_generation_app/features/history_wpda/presentation/detail_history.dart';
import 'package:diamond_generation_app/features/history_wpda/widgets/card_history_wpda.dart';
import 'package:diamond_generation_app/features/history_wpda/widgets/card_monthly_report.dart';
import 'package:diamond_generation_app/features/history_wpda/widgets/filter_date_dropdown.dart';
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

class HistoryScreen extends StatefulWidget {
  String? id;
  String? fullName;

  HistoryScreen({
    super.key,
    this.id,
    this.fullName,
  });
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? token;

  Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString(SharedPreferencesManager.keyToken);
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
    final historyProvider = Provider.of<HistoryProvider>(context);
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Riwayat ${widget.fullName ?? 'WPDA'}',
      ),
      body: Consumer<LoginProvider>(
        builder: (context, value, _) {
          if (value.userId == null) {
            value.loadUserId();
            return Center(child: CircularProgressIndicator());
          } else {
            DateTime now = DateTime.now();
            var currentMonth = now.month;
            var currentYear = now.year;
            if (historyProvider.selectedTanggal == 'Bulan ini') {
              return FutureBuilder(
                future: getWpdaUsecase.fetchWpdaByMonth(
                    context,
                    (token == null) ? '' : token!,
                    (widget.id == null) ? value.userId! : widget.id!,
                    currentMonth,
                    currentYear),
                builder: (context, snapshot) {
                  print(value.userId);
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return PlaceholderCardWpda();
                  } else {
                    final monthlyReport = snapshot.data;
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
                      if (monthlyReport!.data.isEmpty) {
                        return Column(
                          children: [
                            HeaderMonthlyReport(
                              monthlyReport: monthlyReport,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/emoji.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
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
                        monthlyReport.data.sort((a, b) =>
                            DateTime.parse(b.createdAt)
                                .compareTo(DateTime.parse(a.createdAt)));
                        return Column(
                          children: [
                            HeaderMonthlyReport(monthlyReport: monthlyReport),
                            Expanded(
                                child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              // controller: _scrollController,
                              itemCount: monthlyReport.data.length,
                              itemBuilder: (context, index) {
                                final monthlyReportData =
                                    monthlyReport.data[index];
                                return CardMonthlyReport(
                                  reportData: monthlyReportData,
                                );
                              },
                            ))
                          ],
                        );
                      }
                    }
                  }
                },
              );
            } else {
              return FutureBuilder<History>(
                future: Future.delayed(
                  Duration(milliseconds: 500),
                  () => getWpdaUsecase.getAllWpdaByUserID(
                    (widget.id == null) ? value.userId! : widget.id!,
                    token!,
                  ),
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
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
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
                            _buildHeaderWidget(context, history),
                            Expanded(
                              child: RefreshIndicator(
                                  onRefresh: () async {
                                    await wpdaProvider.refreshWpdaHistory(
                                        value.userId!, token!);
                                  },
                                  child: (historyProvider.selectedTanggal ==
                                          'Semua')
                                      ? ListView.builder(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          // controller: _scrollController,
                                          itemCount: history.data.length,
                                          itemBuilder: (context, index) {
                                            final historyWpda =
                                                history.data[index];
                                            return CardHistoryWpda(
                                              historyWpda: historyWpda,
                                            );
                                          },
                                        )
                                      : (historyProvider.selectedTanggal ==
                                              '7 Hari Terakhir')
                                          ? FutureBuilder<List<HistoryWpda>>(
                                              future: Future.delayed(
                                                Duration(milliseconds: 500),
                                                () => history.filterLast7Days(),
                                              ),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                } else {
                                                  final filteredData =
                                                      snapshot.data ?? [];

                                                  return (snapshot
                                                          .data!.isNotEmpty)
                                                      ? ListView.builder(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 12,
                                                            vertical: 4,
                                                          ),
                                                          itemCount:
                                                              filteredData
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final historyWpda =
                                                                filteredData[
                                                                    index];
                                                            return CardHistoryWpda(
                                                              historyWpda:
                                                                  historyWpda,
                                                            );
                                                          },
                                                        )
                                                      : Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                'assets/images/emoji.png',
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.15,
                                                              ),
                                                              SizedBox(
                                                                  height: 8),
                                                              Center(
                                                                child: Text(
                                                                  'Tidak ada data ditemukan',
                                                                  style: MyFonts
                                                                      .customTextStyle(
                                                                    14,
                                                                    FontWeight
                                                                        .w500,
                                                                    MyColor
                                                                        .whiteColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                }
                                              },
                                            )
                                          : (historyProvider.selectedTanggal ==
                                                  'Kemarin')
                                              ? FutureBuilder<
                                                  List<HistoryWpda>>(
                                                  future: Future.delayed(
                                                    Duration(milliseconds: 500),
                                                    () => history.filterByDate(
                                                        historyProvider
                                                            .selectedTanggal),
                                                  ),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          'Error: ${snapshot.error}');
                                                    } else {
                                                      final filteredData =
                                                          snapshot.data ?? [];
                                                      return (snapshot
                                                              .data!.isNotEmpty)
                                                          ? ListView.builder(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal: 12,
                                                                vertical: 4,
                                                              ),
                                                              itemCount:
                                                                  filteredData
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                final historyWpda =
                                                                    filteredData[
                                                                        index];
                                                                return CardHistoryWpda(
                                                                  historyWpda:
                                                                      historyWpda,
                                                                );
                                                              },
                                                            )
                                                          : Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    'assets/images/emoji.png',
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.15,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          8),
                                                                  Center(
                                                                    child: Text(
                                                                      'Tidak ada data ditemukan',
                                                                      style: MyFonts
                                                                          .customTextStyle(
                                                                        14,
                                                                        FontWeight
                                                                            .w500,
                                                                        MyColor
                                                                            .whiteColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                    }
                                                  },
                                                )
                                              : (historyProvider
                                                          .selectedTanggal ==
                                                      '30 Hari Terakhir')
                                                  ? FutureBuilder<
                                                      List<HistoryWpda>>(
                                                      future: Future.delayed(
                                                        Duration(
                                                            milliseconds: 500),
                                                        () => history
                                                            .filterLast30Days(),
                                                      ),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return Text(
                                                              'Error: ${snapshot.error}');
                                                        } else {
                                                          final filteredData =
                                                              snapshot.data ??
                                                                  [];
                                                          return (snapshot.data!
                                                                  .isNotEmpty)
                                                              ? ListView
                                                                  .builder(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical: 4,
                                                                  ),
                                                                  itemCount:
                                                                      filteredData
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    final historyWpda =
                                                                        filteredData[
                                                                            index];
                                                                    return CardHistoryWpda(
                                                                      historyWpda:
                                                                          historyWpda,
                                                                    );
                                                                  },
                                                                )
                                                              : Center(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        'assets/images/emoji.png',
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.15,
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              8),
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          'Tidak ada data ditemukan',
                                                                          style:
                                                                              MyFonts.customTextStyle(
                                                                            14,
                                                                            FontWeight.w500,
                                                                            MyColor.whiteColor,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                        }
                                                      },
                                                    )
                                                  : FutureBuilder<
                                                      List<HistoryWpda>>(
                                                      future: Future.delayed(
                                                        Duration(
                                                            milliseconds: 500),
                                                        () => history.onDay(
                                                            historyProvider
                                                                .selectedTanggal),
                                                      ),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return Text(
                                                              'Error: ${snapshot.error}');
                                                        } else {
                                                          final filteredData =
                                                              snapshot.data ??
                                                                  [];

                                                          return (snapshot.data!
                                                                  .isNotEmpty)
                                                              ? ListView
                                                                  .builder(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical: 4,
                                                                  ),
                                                                  itemCount:
                                                                      filteredData
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    final historyWpda =
                                                                        filteredData[
                                                                            index];
                                                                    return CardHistoryWpda(
                                                                      historyWpda:
                                                                          historyWpda,
                                                                    );
                                                                  },
                                                                )
                                                              : Center(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        'assets/images/emoji.png',
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.15,
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              8),
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          'Tidak ada data ditemukan',
                                                                          style:
                                                                              MyFonts.customTextStyle(
                                                                            14,
                                                                            FontWeight.w500,
                                                                            MyColor.whiteColor,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                        }
                                                      },
                                                    )),
                            ),
                          ],
                        );
                      }
                    }
                  }
                },
              );
            }
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
                      totalWpda: history!.totalWPDA.toString(),
                      color: MyColor.colorGreen,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: CardHeaderHistoryWpda(
                      title: 'NILAI',
                      totalWpda: history.grade,
                      color: MyColor.colorLightBlue,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: CardHeaderHistoryWpda(
                      title: 'HARI TERLEWAT',
                      totalWpda: history.missedDaysTotal.toString(),
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
                'WPDA tidak ditemukan. Server sedang dalam perbaikan.',
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
    final historyProvider = Provider.of<HistoryProvider>(context);
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
                            'Perhitungan catatan WPDA dibawah ini adalah terhitung sejak anda mendaftar. Untuk nilai dihitung setiap bulan.',
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
                SizedBox(height: 8),
                FilterDateDropdown(),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CardHeaderHistoryWpda(
                        title: 'TOTAL WPDA',
                        totalWpda: (historyProvider.selectedTanggal ==
                                '7 Hari Terakhir')
                            ? history!
                                .filterLast7Days()
                                .fold(
                                  0.0,
                                  (previous, current) => previous + 1,
                                )
                                .toStringAsFixed(0)
                            : (historyProvider.selectedTanggal == 'Hari ini')
                                ? history!
                                    .onDay(historyProvider.selectedTanggal)
                                    .fold(
                                      0.0,
                                      (previous, current) => previous + 1,
                                    )
                                    .toStringAsFixed(0)
                                : (historyProvider.selectedTanggal == 'Kemarin')
                                    ? history!
                                        .filterByDate(
                                            historyProvider.selectedTanggal)
                                        .fold(
                                          0.0,
                                          (previous, current) => previous + 1,
                                        )
                                        .toStringAsFixed(0)
                                    : (historyProvider.selectedTanggal ==
                                            '30 Hari Terakhir')
                                        ? history!
                                            .filterLast30Days()
                                            .fold(
                                              0.0,
                                              (previous, current) =>
                                                  previous + 1,
                                            )
                                            .toStringAsFixed(0)
                                        : history!.totalWPDA.toString(),
                        color: MyColor.colorGreen,
                        onTap: () {},
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: CardHeaderHistoryWpda(
                        title: 'NILAI',
                        totalWpda: (historyProvider.selectedTanggal ==
                                    '7 Hari Terakhir' ||
                                historyProvider.selectedTanggal == 'Kemarin' ||
                                (historyProvider.selectedTanggal ==
                                        'Hari ini' ||
                                    historyProvider.selectedTanggal == 'Semua'))
                            ? '-'
                            : history.grade,
                        color: MyColor.colorLightBlue,
                        onTap: () {
                          if (historyProvider.selectedTanggal == 'Semua') {
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return FilterScreen();
                            // }));
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: CardHeaderHistoryWpda(
                        title: 'HARI TERLEWAT',
                        totalWpda: (historyProvider.selectedTanggal ==
                                    'Kemarin' ||
                                (historyProvider.selectedTanggal == 'Hari ini'))
                            ? '-'
                            : (historyProvider.selectedTanggal ==
                                    '7 Hari Terakhir')
                                ? history.missedDaysLast7Days.toString()
                                : (historyProvider.selectedTanggal ==
                                        '30 Hari Terakhir')
                                    ? history.missedDaysLast30Days.toString()
                                    : history.missedDaysTotal.toString(),
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

class HeaderMonthlyReport extends StatelessWidget {
  MonthlyReport? monthlyReport;

  HeaderMonthlyReport({
    super.key,
    this.monthlyReport,
  });

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    var now = DateTime.now();
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            'Perhitungan catatan WPDA dibawah ini adalah terhitung sejak anda mendaftar. Untuk nilai dihitung setiap bulan.',
                            style: MyFonts.customTextStyle(
                              12,
                              FontWeight.w500,
                              MyColor.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return DetailHistoryWPDA();
                    }));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: MyColor.primaryColor,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${monthlyReport!.month}',
                        style: MyFonts.customTextStyle(
                          15,
                          FontWeight.bold,
                          MyColor.primaryColor,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          indent: 10,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16),
                FilterDateDropdown(),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CardHeaderHistoryWpda(
                        title: 'TOTAL WPDA',
                        totalWpda: monthlyReport!.totalWpda.toString(),
                        color: MyColor.colorGreen,
                        onTap: () {},
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: CardHeaderHistoryWpda(
                        title: 'NILAI',
                        totalWpda: monthlyReport!.grade,
                        color: MyColor.colorLightBlue,
                        onTap: () {
                          if (historyProvider.selectedTanggal == 'Semua') {
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return FilterScreen();
                            // }));
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: CardHeaderHistoryWpda(
                        title: 'HARI TERLEWAT',
                        totalWpda:
                            monthlyReport!.missedDaysTotalThisMonth.toString(),
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
