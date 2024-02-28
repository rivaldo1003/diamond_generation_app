import 'package:diamond_generation_app/features/history_wpda/data/history_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterDateDropdown extends StatefulWidget {
  String? title;
  FilterDateDropdown({
    this.title,
  });
  @override
  State<FilterDateDropdown> createState() => _FilterDateDropdownState();
}

class _FilterDateDropdownState extends State<FilterDateDropdown> {
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
    final historyProvider = Provider.of<HistoryProvider>(context);

    return Focus(
      focusNode: dropdownFocusNode,
      child: Container(
        decoration: BoxDecoration(
          // color: MyColor.blueContainer,
          border: Border.all(color: MyColor.greyText),
          borderRadius: BorderRadius.circular(12),
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
          value: historyProvider.selectedTanggal,
          onChanged: (String? newValue) {
            if (newValue == '7 Hari Terakhir') {
              historyProvider.updateSelectedTanggal(newValue!);
            } else if (newValue == 'Hari ini') {
              historyProvider.updateSelectedTanggal(newValue!);
            } else if (newValue == 'Kemarin') {
              historyProvider.updateSelectedTanggal(newValue!);
            } else if (newValue == '30 Hari Terakhir') {
              historyProvider.updateSelectedTanggal(newValue!);
            } else if (newValue == 'Bulan ini') {
              historyProvider.updateSelectedTanggal(newValue!);
            } else if (newValue == 'Semua') {
              historyProvider.updateSelectedTanggal(newValue!);
            }
          },
          items: historyProvider.tanggalList
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem(
              value: value,
              child: Padding(
                padding: const EdgeInsets.all(12),
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
