import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final bool isActive;

  Indicator({
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 350),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 27 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey,
        borderRadius:
            isActive ? BorderRadius.circular(20) : BorderRadius.circular(8),
      ),
    );
  }
}
