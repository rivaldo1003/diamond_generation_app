import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlaceholderAllUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Skeleton();
  }
}

class Skeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[800]!, // Warna base untuk dark theme
                  highlightColor: Colors.grey[700]!,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          // width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 12);
              },
              itemCount: 12,
            ),
          ),
        ],
      ),
    );
  }
}
