import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoaTabernakel extends StatefulWidget {
  @override
  _DoaTabernakelState createState() => _DoaTabernakelState();
}

class _DoaTabernakelState extends State<DoaTabernakel> {
  List<String> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Doa Tabernakel',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Consumer<AddWpdaWProvider>(
          builder: (context, checkBoxState, _) {
            return Container(
              height: 200,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: doaItems.length,
                itemBuilder: (context, index) {
                  String item = doaItems[index];
                  return CheckboxListTile(
                    dense: true,
                    title: Text(
                      item,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    value: !selectedItems.contains('Tidak Berdoa') &&
                        selectedItems.contains(item),
                    onChanged: selectedItems.contains('Tidak Berdoa')
                        ? null
                        : (value) {
                            editSelectedItems(value!, item);
                          },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  void editSelectedItems(bool value, String item) {
    setState(() {
      if (value) {
        selectedItems.clear();
        selectedItems.add(item);
      } else {
        selectedItems.remove(item);
      }
    });
  }
}

class AddWpdaWProvider extends ChangeNotifier {
  // Add your provider logic here
}

final List<String> doaItems = [
  'Mesbah Bakaran',
  'Bejana Pembasuhan',
  'Ruang Kudus',
  'Ruang Maha Kudus',
  'Nilai-Nilai GSJA SK',
  'Tidak Berdoa',
];
