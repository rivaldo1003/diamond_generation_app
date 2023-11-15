import 'package:diamond_generation_app/core/models/user.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/list_info_user.dart';
import 'package:flutter/material.dart';

class DetailPerson extends StatelessWidget {
  final User user;

  const DetailPerson({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'User Information'),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: MyColor.colorBlackBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        margin: EdgeInsets.all(20),
                        height: 96,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: MyColor.blueContainer,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage('assets/images/title.png'),
                            opacity: 0.5,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -15,
                        left: 20,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  content: Container(
                                    height: 300,
                                    width: 300,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(500),
                                      child: Image.network(
                                        user.images,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 2.0),
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user.images),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName,
                              style: MyFonts.customTextStyle(
                                18,
                                FontWeight.bold,
                                MyColor.whiteColor,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              user.phoneNumber,
                              style: MyFonts.customTextStyle(
                                14,
                                FontWeight.w500,
                                MyColor.greyText,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          user.age + ' Years',
                          style: MyFonts.customTextStyle(
                            16,
                            FontWeight.bold,
                            MyColor.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Divider(
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        Text(
                          'Information',
                          style: MyFonts.customTextStyle(
                            16,
                            FontWeight.bold,
                            MyColor.whiteColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        ListInfoUser(
                          title: 'Sertifikasi',
                          widget: Icon(Icons.check_circle_rounded),
                        ),
                        ListInfoUser(
                          title: 'Percaya',
                          widget: Icon(Icons.check_circle_rounded),
                        ),
                        ListInfoUser(
                          title: 'Berobat',
                          widget: Icon(Icons.check_circle_rounded),
                        ),
                        ListInfoUser(
                          title: 'Lahir Baru',
                          widget: Icon(Icons.check_circle_rounded),
                        ),
                        ListInfoUser(
                          title: 'Baptis Roh Kudus',
                          widget: Icon(Icons.check_circle_rounded),
                        ),
                        ListInfoUser(
                          title: 'Baptis Air',
                          widget: Icon(Icons.check_circle_rounded),
                        ),
                        ListInfoUser(
                          title: 'Doa Tabernakel',
                          widget: Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              color: MyColor.colorGreen,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                'A',
                                style: MyFonts.customTextStyle(
                                  12,
                                  FontWeight.bold,
                                  MyColor.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        ListInfoUser(
                          title: 'WPDA',
                          widget: Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              color: MyColor.colorGreen,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                'A',
                                style: MyFonts.customTextStyle(
                                  12,
                                  FontWeight.bold,
                                  MyColor.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ListInfoUser(
                          title: 'Menginjil',
                          widget: Icon(Icons.check_circle_rounded),
                        ),
                        ListInfoUser(
                          title: 'Memimpin',
                          widget: Icon(Icons.check_circle_rounded),
                        ),
                        ListInfoUser(
                          title: 'Menyembuhkan',
                          widget: Icon(Icons.check_circle_rounded),
                        ),
                        ListInfoUser(
                          title: 'Melepaskan',
                          widget: Icon(Icons.check_circle_rounded),
                        ),
                        ListInfoUser(
                          title: 'Visi',
                          widget: Icon(Icons.arrow_drop_down),
                        ),
                        ListInfoUser(
                          title: 'Misi',
                          widget: Icon(Icons.arrow_drop_down),
                        ),
                        ListInfoUser(
                          title: 'Nilai',
                          widget: Icon(Icons.arrow_drop_down),
                        ),
                        ListInfoUser(
                          title: 'Goal',
                          widget: Icon(Icons.arrow_drop_down),
                        ),
                        ListInfoUser(
                          title: 'Commit',
                          widget: Icon(Icons.arrow_drop_down),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
