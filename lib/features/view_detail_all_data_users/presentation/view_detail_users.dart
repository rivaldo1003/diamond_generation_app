import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/features/view_detail_all_data_users/presentation/wpda_user_screen.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:diamond_generation_app/shared/widgets/card_detail_profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewAllDataUsers extends StatelessWidget {
  final AllUsers userData;

  const ViewAllDataUsers({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    String registrationDate = userData.registration_date.split(' ').first;
    String formatDate = DateFormat('dd MMMM yyyy', 'id')
        .format(DateTime.parse(userData.registration_date));
    return Scaffold(
      appBar: AppBarWidget(title: 'Detail User'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 16,
                    bottom: 18,
                  ),
                  height: 120,
                  width: 120,
                  child: CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/profile_empty.jpg'),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 5.0,
                    ),
                  ),
                ),
                Text(
                  userData.fullName,
                  style: MyFonts.customTextStyle(
                    18,
                    FontWeight.bold,
                    MyColor.whiteColor,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Divider(),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: 24,
                      width: 70,
                      decoration: BoxDecoration(
                        color: MyColor.colorLightBlue,
                        // border: Border.all(
                        //   color: MyColor.primaryColor,
                        // ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          userData.role,
                          style: MyFonts.customTextStyle(
                            14,
                            FontWeight.bold,
                            MyColor.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Active since - ${formatDate}',
                  style: MyFonts.customTextStyle(
                    14,
                    FontWeight.w500,
                    MyColor.greyText,
                  ),
                ),
                SizedBox(height: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Personal Information',
                        style: MyFonts.customTextStyle(
                          14,
                          FontWeight.w500,
                          MyColor.whiteColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    CardDetailProfile(
                      iconData: Icons.numbers,
                      title: 'Account Number',
                      value: userData.account_number,
                    ),
                    SizedBox(height: 4),
                    CardDetailProfile(
                      iconData: Icons.email,
                      title: 'Email',
                      value: userData.email,
                    ),
                    SizedBox(height: 4),
                    CardDetailProfile(
                      iconData: Icons.home_rounded,
                      title: 'Address',
                      value: userData.address,
                    ),
                    SizedBox(height: 4),
                    CardDetailProfile(
                      iconData: Icons.phone,
                      title: 'Phone',
                      value: userData.phoneNumber,
                    ),
                    SizedBox(height: 4),
                    CardDetailProfile(
                      iconData: Icons.person,
                      title: 'Gender',
                      value: userData.gender,
                    ),
                    SizedBox(height: 4),
                    CardDetailProfile(
                      iconData: Icons.add_location_alt,
                      title: 'Place and Date of Birth',
                      value: '${userData.birthPlace}' +
                          ', ' +
                          '${userData.birthDate}',
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ],
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ButtonWidget(
              title: 'Lihat WPDA',
              color: MyColor.primaryColor,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return WpdaUserScreen(
                    allUsers: userData,
                    totalWpda: userData.dataWpda.length.toString(),
                  );
                }));
              },
            ),
          ),
        ],
      ),
    );
  }
}
