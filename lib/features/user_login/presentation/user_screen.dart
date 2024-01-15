import 'package:diamond_generation_app/features/loading_diamond/cool_loading.dart';
import 'package:diamond_generation_app/features/login/presentation/login_screen.dart';
import 'package:diamond_generation_app/features/profile/data/providers/profile_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: AppBarWidget(title: 'User Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Anda login sebagai user'),
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Logout confirmation',
                          style: MyFonts.customTextStyle(
                            16,
                            FontWeight.bold,
                            MyColor.whiteColor,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to logout?',
                          style: MyFonts.customTextStyle(
                            14,
                            FontWeight.w500,
                            MyColor.whiteColor,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: MyFonts.customTextStyle(
                                15,
                                FontWeight.bold,
                                Colors.lightBlue,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              profileProvider.clearAllData().then((value) {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: CoolLoading(),
                                      );
                                    });
                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return LoginScreen();
                                    }),
                                    (route) => false,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Logout successful!',
                                        style: MyFonts.customTextStyle(
                                          15,
                                          FontWeight.w500,
                                          MyColor.colorRed,
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              });
                            },
                            child: Text(
                              'Logout',
                              style: MyFonts.customTextStyle(
                                15,
                                FontWeight.bold,
                                Colors.lightBlue,
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
