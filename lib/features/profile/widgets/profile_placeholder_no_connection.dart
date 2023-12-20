import 'package:diamond_generation_app/features/profile/widgets/container_skeleton.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePlaceholderNoConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ContainerSkeleton(
                  height: 16,
                  width: 180,
                  borderRadius: 8,
                ),
                SizedBox(width: 8),
                Row(
                  children: [
                    ContainerSkeleton(
                      height: 16,
                      width: 100,
                      borderRadius: 8,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              DetailSkeletonCard(),
              DetailSkeletonCard(),
              DetailSkeletonCard(),
              DetailSkeletonCard(),
              DetailSkeletonCard(),
              DetailSkeletonCard(),
              DetailSkeletonCard(),
            ],
          ),
        ],
      ),
    );
  }

  Padding DetailSkeletonCard() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Card(
          color: MyColor.colorBlackBg,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[800]!, // Warna base untuk dark theme
            highlightColor: Colors.grey[700]!,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          height: 14,
                          // width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Flexible(
                        child: Container(
                          height: 14,
                          // width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
