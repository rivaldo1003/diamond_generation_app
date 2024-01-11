// import 'package:diamond_generation_app/features/wpda/data/providers/bible_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class BibleApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => BibleProvider(),
//       child: MaterialApp(
//         home: BibleScreen(),
//       ),
//     );
//   }
// }

// class BibleScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Baca Alkitab'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Consumer<BibleProvider>(
//               builder: (context, bibleProvider, child) {
//                 return DropdownButton<String>(
//                   value: bibleProvider.selectedBook,
//                   items: bibleProvider.allBooks.map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     bibleProvider.updateSelectedBook(newValue!);
//                   },
//                 );
//               },
//             ),
//             SizedBox(height: 16),
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Pasal'),
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 Provider.of<BibleProvider>(context, listen: false)
//                     .updateSelectedChapter(value);
//               },
//             ),
//             SizedBox(height: 16),
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Ayat'),
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 Provider.of<BibleProvider>(context, listen: false)
//                     .updateSelectedVerse(value);
//               },
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () async {
//                 await Provider.of<BibleProvider>(context, listen: false)
//                     .fetchVerse(context);
//                 // Tampilkan hasil pembacaan ayat di sini
//                 if (Provider.of<BibleProvider>(context, listen: false)
//                     .selectedVerseData
//                     .isNotEmpty) {
//                   print(
//                       'Baca Ayat ${Provider.of<BibleProvider>(context, listen: false).selectedBook} ${Provider.of<BibleProvider>(context, listen: false).selectedChapter}:${Provider.of<BibleProvider>(context, listen: false).selectedVerse}');
//                   print(
//                       '${Provider.of<BibleProvider>(context, listen: false).selectedVerseData["verse"]} - ${Provider.of<BibleProvider>(context, listen: false).selectedVerseData["content"]}');
//                 }
//               },
//               child: Text('Baca Ayat'),
//             ),
//             SizedBox(height: 16),
//             Consumer<BibleProvider>(
//               builder: (context, bibleProvider, child) {
//                 if (bibleProvider.selectedVerseData.isNotEmpty) {
//                   return ListTile(
//                     title: Text(
//                       '${bibleProvider.selectedVerseData["verse"]} - ${bibleProvider.selectedVerseData["content"]}',
//                     ),
//                   );
//                 } else {
//                   return Container();
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
