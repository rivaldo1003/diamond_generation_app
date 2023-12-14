import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class KlasmenWpdaScreen extends StatelessWidget {
  const KlasmenWpdaScreen({Key? key});

  // Fungsi untuk mendapatkan data dari API, gantilah ini sesuai dengan logika Anda
  List<Map<String, dynamic>> fetchDataFromAPI() {
    // Proses pengambilan data dari API dilakukan di sini
    // Contoh sederhana:
    return [
      {
        'id': 1,
        'name': 'John Doe',
        'grade': 'A',
        'total_wpda': 322,
      },
      {
        'id': 2,
        'name': 'Jane Smith',
        'grade': 'B',
        'total_wpda': 289,
      },
      {
        'id': 3,
        'name': 'Jane Smith',
        'grade': 'B',
        'total_wpda': 289,
      },
      {
        'id': 4,
        'name': 'Jane Smith',
        'grade': 'B',
        'total_wpda': 289,
      },
      // ... tambahkan data lainnya dari API di sini
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = fetchDataFromAPI();

    // Mengonversi data dari API ke dalam widget DataRow
    List<DataRow> rows = data.map((item) {
      return DataRow(
        cells: <DataCell>[
          DataCell(
            Text(
              item['id'].toString(),
              textAlign: TextAlign.center,
            ),
          ),
          DataCell(
            Text(
              item['name'],
              textAlign: TextAlign.center,
            ),
          ),
          DataCell(
            Text(
              item['grade'],
              textAlign: TextAlign.center,
            ),
          ),
          DataCell(
            Text(
              item['total_wpda'].toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        color: MaterialStateColor.resolveWith(
          (states) {
            data.map((item) => item[0]).toList();

            return MyColor.colorBlackBg;
          },
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBarWidget(title: 'Klasmen WPDA'),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columnSpacing: 10,
          horizontalMargin: 16,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          columns: <DataColumn>[
            DataColumn(
              label: Text(
                'No',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.bold,
                  MyColor.whiteColor,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Name',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.bold,
                  MyColor.whiteColor,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Grade',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.bold,
                  MyColor.whiteColor,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Total WPDA',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.bold,
                  MyColor.whiteColor,
                ),
              ),
            ),
          ],
          headingRowColor:
              MaterialStateColor.resolveWith((states) => MyColor.primaryColor),
          rows: rows, // Menggunakan data row yang telah dibuat
        ),
      ),
    );
  }
}
