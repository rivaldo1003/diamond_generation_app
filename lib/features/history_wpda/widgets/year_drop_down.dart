import 'package:diamond_generation_app/features/history_wpda/data/detail_history_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YearDropDown extends StatefulWidget {
  String? title;
  YearDropDown({
    this.title,
  });
  @override
  State<YearDropDown> createState() => _YearDropDownState();
}

class _YearDropDownState extends State<YearDropDown> {
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
    final detailHistoryProvider = Provider.of<DetailHistoryProvider>(context);
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
          value: detailHistoryProvider.selectedYear,
          onChanged: (String? newValue) {
            detailHistoryProvider.updateSelectedYear(newValue!);
          },
          items: detailHistoryProvider.yearList
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

class MonthConverter {
  static int monthNameToNumber(String monthName) {
    switch (monthName) {
      case 'Januari':
        return 1;
      case 'Februari':
        return 2;
      case 'Maret':
        return 3;
      case 'April':
        return 4;
      case 'Mei':
        return 5;
      case 'Juni':
        return 6;
      case 'Juli':
        return 7;
      case 'Agustus':
        return 8;
      case 'September':
        return 9;
      case 'Oktober':
        return 10;
      case 'November':
        return 11;
      case 'Desember':
        return 12;
      default:
        return -1; // Menandakan bahwa nama bulan tidak valid
    }
  }
}
