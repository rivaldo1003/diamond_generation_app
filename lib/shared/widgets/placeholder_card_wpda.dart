import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlaceholderCardWpda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
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
                      // border: Border.all(color: MyColor.greyText),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
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
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                height: 18,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Container(
                                height: 18,
                                // width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
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
                        SizedBox(height: 12),
                        Container(
                          height: 16,
                          // width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 4);
        },
        itemCount: 10);
  }
}
