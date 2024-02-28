import 'package:diamond_generation_app/shared/widgets/placeholder_card_wpda.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[300]!,
      child: PlaceholderCardWpda(), // Gantilah dengan placeholder yang sesuai
    );
  }
}
