import 'package:diamond_generation_app/features/profile/widgets/profile_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ProfilePlaceholder(), // Gantilah dengan placeholder yang sesuai
    );
  }
}
