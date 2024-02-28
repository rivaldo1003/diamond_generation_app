import 'package:diamond_generation_app/features/history_wpda/data/detail_history_provider.dart';
import 'package:diamond_generation_app/features/history_wpda/data/today_wpda.dart';
import 'package:diamond_generation_app/features/history_wpda/widgets/year_drop_down.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodayDropDown extends StatefulWidget {
  String? title;
  TodayDropDown({
    this.title,
  });
  @override
  State<TodayDropDown> createState() => _TodayDropDownState();
}

class _TodayDropDownState extends State<TodayDropDown> {
  late FocusNode dropdownFocusNode;

  @override
  void initState() {
    super.initState();
    dropdownFocusNode = FocusNode();
  }

  @override
  void dispose() {
    dropdownFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailHistoryProvider = Provider.of<TodayWpdaProvider>(context);
    return Focus(
      focusNode: dropdownFocusNode,
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          // color: MyColor.blueContainer,
          border: Border.all(color: MyColor.greyText),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<String>(
          padding: EdgeInsets.symmetric(horizontal: 12),
          borderRadius: BorderRadius.circular(12),
          icon: Icon(Icons.arrow_drop_down_rounded),
          isExpanded: true,
          enableFeedback: false,
          isDense: false,
          alignment: AlignmentDirectional.center,
          underline: SizedBox(),
          value: detailHistoryProvider.selectedMonth,
          onChanged: (String? newValue) {
            detailHistoryProvider.updateSelectedMonth(newValue!);
            String monthName = newValue;
            int monthNumber = MonthConverter.monthNameToNumber(monthName);
            print(monthNumber);
          },
          items: detailHistoryProvider.monthList
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem(
              value: value,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Row(
                  children: [
                    Text(
                      value,
                      style: MyFonts.customTextStyle(
                        14,
                        FontWeight.w500,
                        MyColor.whiteColor,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${widget.title ?? ''}',
                      style: MyFonts.customTextStyle(
                        14,
                        FontWeight.bold,
                        MyColor.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
