import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/wpda_provider.dart';
import 'package:diamond_generation_app/features/wpda/presentation/add_wpda.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/card_wpda.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WPDAScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wpda = Provider.of<GetUserUsecase>(context);
    final wpdaProvider = Provider.of<WpdaProvider>(context);
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
          color: MyColor.blackColor,
        ),
      ),
      appBar: AppBarWidget(title: 'WPDA'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
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
          Expanded(
            child: FutureBuilder<List<WPDA>>(
              future: wpda.getAllWpda(),
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
                        child: Text('WPDA data is empty'),
                      );
                    } else {
                      return Consumer<LoginProvider>(
                          builder: (context, value, _) {
                        if (value.userId == null) {
                          value.loadUserId();
                          return CircularProgressIndicator();
                        } else {
                          data = data!.reversed.toList();
                          data!.sort((a, b) {
                            if (a.userId == value.userId &&
                                b.userId != value.userId) {
                              return -1;
                            } else if (a.userId != value.userId &&
                                b.userId == value.userId) {
                              return 1;
                            } else {
                              return 0;
                            }
                          });
                          return RefreshIndicator(
                            onRefresh: () async {
                              await wpdaProvider.refreshAllUsers();
                            },
                            child: ListView.builder(
                              itemCount: data!.length,
                              itemBuilder: (context, index) {
                                var wpda = data![index];
                                return CardWpda(
                                  wpda: wpda,
                                );
                              },
                            ),
                          );
                        }
                      });
                    }
                  } else {
                    return Center(
                      child: Text(
                        'WPDA Data is empty',
                        style: MyFonts.customTextStyle(
                          14,
                          FontWeight.w500,
                          MyColor.whiteColor,
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
