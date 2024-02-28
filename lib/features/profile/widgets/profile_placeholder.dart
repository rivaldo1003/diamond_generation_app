import 'package:diamond_generation_app/features/profile/widgets/container_skeleton.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ContainerSkeleton(
            shapeBorder: CircleBorder(),
            height: 120,
            width: 120,
            borderRadius: 60,
          ),
          SizedBox(height: 8),
          ContainerSkeleton(
            height: 16,
            width: 150,
            borderRadius: 8,
          ),
          SizedBox(height: 4),
          ContainerSkeleton(
            height: 24,
            width: 90,
            borderRadius: 8,
          ),
          SizedBox(height: 4),
          ContainerSkeleton(
            height: 16,
            width: 200,
            borderRadius: 8,
          ),
          SizedBox(height: 4),
          ContainerSkeleton(
            height: 28,
            width: 180,
            borderRadius: 8,
          ),
          SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
}

class DetailSkeletonCard extends StatelessWidget {
  const DetailSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
