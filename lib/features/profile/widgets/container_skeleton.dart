import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContainerSkeleton extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  Widget? widget;
  ShapeBorder? shapeBorder;
  ContainerSkeleton({
    super.key,
    required this.height,
    required this.width,
    required this.borderRadius,
    this.widget,
    this.shapeBorder,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: shapeBorder,
      color: MyColor.colorBlackBg,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[800]!, // Warna base untuk dark theme
        highlightColor: Colors.grey[700]!,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
