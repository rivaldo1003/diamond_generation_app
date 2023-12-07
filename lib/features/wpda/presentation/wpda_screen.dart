import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/core/usecases/get_wpda_usecase.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/wpda_provider.dart';
import 'package:diamond_generation_app/features/wpda/presentation/add_wpda.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/card_wpda.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WPDAScreen extends StatelessWidget {
  Future<bool> checkIfWPDAUploadedTodayForUser(
      String userId, List<WPDA>? data) async {
    var currentDate = DateTime.now();
    var formatDate = DateFormat('yy MMM dd').format(currentDate);

    for (var wpda in data!) {
      if (wpda.userId == userId) {
        var dateUploaded =
            DateFormat('yy MMM dd').format(DateTime.parse(wpda.createdAt));
        if (dateUploaded == formatDate) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final getWpdaUsecase = Provider.of<GetWpdaUsecase>(context);
    final wpdaProvider = Provider.of<WpdaProvider>(context);
    var today = DateTime.now();
    var formatDateResult = DateFormat('EEEE, d MMMM y', 'id').format(today);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddWPDAForm();
          }));
        },
        backgroundColor: MyColor.primaryColor,
        child: Icon(
          Icons.add,
          color: MyColor.whiteColor,
        ),
      ),
      appBar: AppBarWidget(
        title: 'WPDA',
        // action: [
        //   IconButton(
        //     onPressed: () {
        //       wpdaProvider.refreshApp(context);
        //     },
        //     icon: Icon(Icons.refresh),
        //   ),
        // ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await wpdaProvider.refreshAllUsers();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<LoginProvider>(builder: (context, value, _) {
                          if (value.fullName == null) {
                            value.loadFullName();
                            return CircularProgressIndicator();
                          } else {
                            List<String> dataFullName =
                                value.fullName!.split(' ');
                            String firstName =
                                dataFullName.isNotEmpty ? dataFullName[0] : '';
                            return Text(
                              'Hello, ${firstName}👋',
                              style: MyFonts.brownText(
                                20,
                                FontWeight.bold,
                              ),
                            );
                          }
                        }),
                        Text(
                          'Ayo, jadikan semua bangsa muridmu.',
                          style: MyFonts.brownText(
                            14,
                            FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    child: Image.asset(
                      'assets/images/profile.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<WPDA>>(
                future: getWpdaUsecase.getAllWpda(),
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
                            child: Image.asset('assets/images/emoji.png'));
                      } else {
                        return Consumer<LoginProvider>(
                            builder: (context, value, _) {
                          if (value.userId == null) {
                            value.loadUserId();
                            return CircularProgressIndicator();
                          } else {
                            var currentDate = DateTime.now();
                            var formatDate =
                                DateFormat('yy MMM dd').format(currentDate);

                            data = data!.reversed.toList();
                            data!.sort((a, b) {
                              var dateA = DateFormat('yy MMM dd')
                                  .format(DateTime.parse(a.createdAt));
                              var dateB = DateFormat('yy MMM dd')
                                  .format(DateTime.parse(b.createdAt));

                              if (a.userId == value.userId &&
                                  b.userId != value.userId &&
                                  dateA == formatDate) {
                                return -1;
                              } else if (a.userId != value.userId &&
                                  b.userId == value.userId &&
                                  dateB == formatDate) {
                                return 1;
                              } else {
                                return 0;
                              }
                            });
                            return Column(
                              children: [
                                FutureBuilder<bool>(
                                  future: checkIfWPDAUploadedTodayForUser(
                                      value.userId!, data),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return SizedBox(); // Show nothing while waiting for the future result
                                    } else if (snapshot.hasData &&
                                        snapshot.data == false) {
                                      return Container(
                                        padding: EdgeInsets.all(8),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: MyColor.colorRed,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.info,
                                                color: MyColor.whiteColor),
                                            SizedBox(width: 8),
                                            Text(
                                              'Anda belum WPDA hari ini.',
                                              style: MyFonts.customTextStyle(
                                                14,
                                                FontWeight.w500,
                                                MyColor.whiteColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        padding: EdgeInsets.all(8),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: MyColor.colorGreen,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.emoji_emotions,
                                                color: MyColor.whiteColor),
                                            SizedBox(width: 8),
                                            Text(
                                              'Anda sudah WPDA hari ini.',
                                              style: MyFonts.customTextStyle(
                                                14,
                                                FontWeight.w500,
                                                MyColor.whiteColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: 12),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Today : ',
                                        style: MyFonts.customTextStyle(
                                          12,
                                          FontWeight.w500,
                                          MyColor.greyText,
                                        ),
                                      ),
                                      Text(
                                        formatDateResult,
                                        style: MyFonts.customTextStyle(
                                          12,
                                          FontWeight.bold,
                                          MyColor.whiteColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: data!.length,
                                    itemBuilder: (context, index) {
                                      var wpda = data![index];
                                      return CardWpda(
                                        wpda: wpda,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                        });
                      }
                    } else {
                      return Column(
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
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
