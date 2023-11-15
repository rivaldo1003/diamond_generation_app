import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/card_detail_profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewAllDataUsers extends StatelessWidget {
  final AllUsers allUsers;

  const ViewAllDataUsers({
    super.key,
    required this.allUsers,
  });

  @override
  Widget build(BuildContext context) {
    String registrationDate = allUsers.registration_date.split(' ').first;
    String formatDate = DateFormat('dd MMMM yyyy', 'id')
        .format(DateTime.parse(allUsers.registration_date));
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
                  allUsers.fullName,
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
                          allUsers.role,
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
                      value: allUsers.account_number,
                    ),
                    SizedBox(height: 4),
                    CardDetailProfile(
                      iconData: Icons.email,
                      title: 'Email',
                      value: allUsers.email,
                    ),
                    SizedBox(height: 4),
                    CardDetailProfile(
                      iconData: Icons.home_rounded,
                      title: 'Address',
                      value: allUsers.address,
                    ),
                    SizedBox(height: 4),
                    CardDetailProfile(
                      iconData: Icons.phone,
                      title: 'Phone',
                      value: allUsers.phoneNumber,
                    ),
                    SizedBox(height: 4),
                    CardDetailProfile(
                      iconData: Icons.person,
                      title: 'Gender',
                      value: allUsers.gender,
                    ),
                    SizedBox(height: 4),
                    CardDetailProfile(
                      iconData: Icons.add_location_alt,
                      title: 'Place and Date of Birth',
                      value: '${allUsers.birthPlace}' +
                          ', ' +
                          '${allUsers.birthDate}',
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
