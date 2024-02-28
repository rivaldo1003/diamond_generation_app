import 'package:diamond_generation_app/core.dart';
import 'package:flutter/material.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Tiket'),
      body: Center(
        child: Text(
          'Halaman Tiket',
          style: MyFonts.customTextStyle(
            16,
            FontWeight.w500,
            MyColor.whiteColor,
          ),
        ),
      ),
    );
  }
}
