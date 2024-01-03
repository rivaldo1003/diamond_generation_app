import 'package:diamond_generation_app/features/comment/presentation/comment_screen.dart';
import 'package:flutter/material.dart';

class MyBottomSheet extends StatefulWidget {
  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  double _modalHeight = 300;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (!_expanded) {
          setState(() {
            _modalHeight -= details.primaryDelta!;
            _modalHeight = _modalHeight.clamp(
                100.0, 700.0); // Batasi tinggi menjadi maksimum 700
          });

          // Jika tinggi mencapai 700, tandai sebagai sudah diperluas
          if (_modalHeight == 700.0) {
            _expanded = true;
          }
        }
      },
      child: Container(
        height: _modalHeight,
        child: CommentScreen(),
      ),
    );
  }
}
