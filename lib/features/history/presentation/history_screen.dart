import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/card_wpda.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'History WPDA'),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container();
        },
      ),
    );
  }
}
