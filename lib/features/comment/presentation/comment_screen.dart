import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  double _containerHeight = 300.0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        // Deteksi perubahan dalam pergerakan scroll
        if (notification.scrollDelta! > 0) {
          // Scroll ke bawah, atur tinggi menjadi 700
          setState(() {
            _containerHeight = MediaQuery.of(context).size.height / 1.1;
          });
        } else if (notification.scrollDelta! < 0) {
          // Scroll ke atas, atur tinggi menjadi 300
          setState(() {
            _containerHeight = 300.0;
          });
        }
        return true;
      },
      child: Container(
        height: _containerHeight,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              // color: MyColor.colorGreen,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 4,
                    width: 35,
                    decoration: BoxDecoration(
                      color: MyColor.greyText,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Komentar',
                    style: MyFonts.customTextStyle(
                      12,
                      FontWeight.bold,
                      MyColor.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 20, // Ganti dengan jumlah komentar yang sesuai
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        Text(
                          'Rivaldo Siregar',
                          style: MyFonts.customTextStyle(
                            10,
                            FontWeight.w500,
                            MyColor.whiteColor,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '35m',
                          style: MyFonts.customTextStyle(
                            10,
                            FontWeight.w400,
                            MyColor.greyText,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      'Amen.',
                      style: MyFonts.customTextStyle(
                        12,
                        FontWeight.w500,
                        MyColor.whiteColor,
                      ),
                    ),
                    leading: CircleAvatar(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
