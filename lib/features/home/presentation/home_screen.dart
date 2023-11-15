import 'package:diamond_generation_app/features/detail_community/presentation/detail_community.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/login/data/utils/controller_login.dart';
import 'package:diamond_generation_app/features/view_all_data_users/presentation/view_all_data.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/card_community.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                              String firstName = dataFullName.isNotEmpty
                                  ? dataFullName[0]
                                  : '';
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
                            'Ayo, jadikan semua bangsa muridmu',
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
                SizedBox(height: 10),
                TextFieldWidget(
                  hintText: 'Find your community...',
                  obscureText: false,
                  controller:
                      TextFieldControllerLogin.searchCommunityController,
                  suffixIcon: Icon(
                    Icons.search,
                    color: MyColor.greyText,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 70,
                      child: Image.asset('assets/images/title.png'),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ViewAllData();
                        }));
                      },
                      child: Text(
                        'View all data',
                        style: MyFonts.customTextStyle(
                          14,
                          FontWeight.bold,
                          MyColor.colorLightBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              top: 10,
              left: 20,
              right: 20,
              bottom: 40,
            ),
            children: [
              CardCommunity(
                title: 'New Creation 1',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DetailCommunity(
                      urlApi: ApiConstants.newCreation1Url,
                      title: 'New Creation 1',
                    );
                  }));
                },
              ),
              SizedBox(height: 12),
              CardCommunity(
                title: 'New Creation 2',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DetailCommunity(
                      urlApi: ApiConstants.newCreation2Url,
                      title: 'New Creation 2',
                    );
                  }));
                },
              ),
              SizedBox(height: 12),
              CardCommunity(
                title: 'Light',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DetailCommunity(
                      urlApi: ApiConstants.lightUrl,
                      title: 'Light',
                    );
                  }));
                },
              ),
            ],
          ))
        ],
      ),
    );
  }
}
