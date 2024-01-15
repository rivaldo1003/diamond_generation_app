import 'dart:convert';
import 'package:diamond_generation_app/features/wpda/data/providers/wpda_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class BibleProvider extends ChangeNotifier {
  String selectedBook = 'Kejadian';
  int selectedChapter = 1;
  int selectedVerse = 1;
  Map<String, dynamic> selectedVerseData = {};
  TextEditingController startVerseController = TextEditingController();
  TextEditingController endVerseController = TextEditingController();
  List<String> allBooks = [
    'Kejadian',
    'Keluaran',
    'Imamat',
    'Bilangan',
    'Ulangan',
    'Yosua',
    'Hakim-hakim',
    'Rut',
    '1 Samuel',
    '2 Samuel',
    '1 Raja-Raja',
    '2 Raja-Raja',
    '1 Tawarikh',
    '2 Tawarikh',
    'Ezra',
    'Nehemia',
    'Ester',
    'Ayub',
    'Mazmur',
    'Amsal',
    'Pengkhotbah',
    'Kidung Agung',
    'Yesaya',
    'Yeremia',
    'Ratapan',
    'Yehezkiel',
    'Daniel',
    'Hosea',
    'Yoel',
    'Amos',
    'Obaja',
    'Yunus',
    'Mikha',
    'Nahum',
    'Habakuk',
    'Zefanya',
    'Hagai',
    'Zakharia',
    'Maleakhi',
    'Matius',
    'Markus',
    'Lukas',
    'Yohanes',
    'Kisah Para Rasul',
    'Roma',
    '1 Korintus',
    '2 Korintus',
    'Galatia',
    'Efesus',
    'Filipi',
    'Kolose',
    '1 Tesalonika',
    '2 Tesalonika',
    '1 Timotius',
    '2 Timotius',
    'Titus',
    'Filemon',
    'Ibrani',
    'Yakobus',
    '1 Petrus',
    '2 Petrus',
    '1 Yohanes',
    '2 Yohanes',
    '3 Yohanes',
    'Yudas',
    'Wahyu',
  ];

  Future<int> getTotalChapters(String book) async {
    try {
      final response = await http.get(
        Uri.parse('https://beeble.vercel.app/api/v1/passage/list'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> bookList = json.decode(response.body)['data'];

        // Find the book in the list
        final bookInfo = bookList.firstWhere(
          (item) => item['name'] == book,
          orElse: () => null,
        );

        if (bookInfo != null) {
          // Extract and return the total chapters for the specified book
          return bookInfo['chapter'] as int;
        } else {
          print('Book not found: $book');
          return 0;
        }
      } else {
        print('Failed to get book list. Status code: ${response.statusCode}');
        return 0;
      }
    } catch (error) {
      print('Error fetching book list: $error');
      return 0;
    }
  }

  Future<int> getTotalVerses(String book, int chapter) async {
    try {
      final response = await http.get(
        Uri.parse('https://beeble.vercel.app/api/v1/passage/$book/$chapter'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Map<String, dynamic>> verses =
            List<Map<String, dynamic>>.from(data['data']['verses']);

        // Filter verses where verse number is not 0
        final List<Map<String, dynamic>> validVerses =
            verses.where((verse) => verse['verse'] != 0).toList();

        print('Data panjang ayat : ${validVerses.length}');
        return validVerses.length;
      } else {
        print(
            'Failed to get total verses. Status code: ${response.statusCode}');
        return 0;
      }
    } catch (error) {
      print('Error fetching total verses: $error');
      return 0;
    }
  }

  Future<void> fetchVerse(
      BuildContext context, String startVerse, String endVerse) async {
    final wpdaProvider = Provider.of<WpdaProvider>(context, listen: false);
    final bibleProvider = Provider.of<BibleProvider>(context, listen: false);

    try {
      int parsedStartVerse = int.parse(startVerse);
      int parsedEndVerse =
          endVerse.isNotEmpty ? int.parse(endVerse) : parsedStartVerse;

      if (parsedStartVerse > parsedEndVerse) {
        parsedEndVerse = parsedStartVerse;
      }

      int totalChapter = await getTotalChapters(bibleProvider.selectedBook);
      int totalVerses = await getTotalVerses(
          bibleProvider.selectedBook, bibleProvider.selectedChapter);

      print('Selected Book: ${bibleProvider.selectedBook}');
      print('Selected Chapter: ${bibleProvider.selectedChapter}');
      print('Total Chapters: $totalChapter');
      print('Total Verses: $totalVerses');
      print('Parsed Start Verse: $parsedStartVerse');
      print('Parsed End Verse: $parsedEndVerse');

      if (selectedChapter > totalChapter) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: MyColor.colorRed,
            content: Text(
              'Gagal memuat data.',
              style: MyFonts.customTextStyle(
                14,
                FontWeight.w500,
                MyColor.whiteColor,
              ),
            ),
          ),
        );
        return;
      }

      if (parsedStartVerse < 1 ||
          parsedStartVerse > totalVerses ||
          parsedEndVerse > totalVerses) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: MyColor.colorRed,
            content: Text(
              'Ayat tidak ditemukan.',
              style: MyFonts.customTextStyle(
                14,
                FontWeight.w500,
                MyColor.whiteColor,
              ),
            ),
          ),
        );
        return;
      }

      final response = await http.get(
        Uri.parse(
          'https://beeble.vercel.app/api/v1/passage/$selectedBook/$selectedChapter:$parsedStartVerse-$parsedEndVerse?ver=tb',
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> verses =
            List<Map<String, dynamic>>.from(data['data']['verses']);
        String formattedText = verses
            .where((verse) => verse['type'] == 'content')
            .map((verse) => '(${verse['verse']}) ${verse['content']}')
            .join(' ');

        print(formattedText);

        print('Start Verse: $parsedStartVerse');
        print('Start Verse: $parsedStartVerse');
        if (parsedStartVerse > parsedEndVerse) {
          print('End Verse:  $parsedEndVerse');
        }

        wpdaProvider.readingBookController.text = (endVerse.isNotEmpty)
            ? (parsedStartVerse == parsedEndVerse)
                ? '${bibleProvider.selectedBook} ${bibleProvider.selectedChapter} : $parsedEndVerse'
                : (parsedEndVerse > totalVerses)
                    ? '${bibleProvider.selectedBook} ${bibleProvider.selectedChapter} : $parsedEndVerse'
                    : '${bibleProvider.selectedBook} ${bibleProvider.selectedChapter} : $parsedStartVerse-$parsedEndVerse'
            : '${bibleProvider.selectedBook} ${bibleProvider.selectedChapter} : $parsedStartVerse';

        wpdaProvider.verseContentController.text = formattedText;
        print(
            'Reading Book Controller Text: ${wpdaProvider.readingBookController.text}');

        notifyListeners();
      } else {
        print('Response : ${response.statusCode}');
        throw Exception('Failed to load verse');
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: MyColor.colorRed,
          content: Text(
            'Gagal memuat data.  Pastikan ayat awal tidak kosong',
            style: MyFonts.customTextStyle(
              14,
              FontWeight.w500,
              MyColor.whiteColor,
            ),
          ),
        ),
      );
    }
  }

  void updateSelectedBook(String newValue) {
    selectedBook = newValue;
    notifyListeners();
  }

  void updateSelectedChapter(String value) {
    selectedChapter = int.tryParse(value) ?? 1;
    notifyListeners();
  }

  void updateSelectedVerse(String value) {
    selectedVerse = int.tryParse(value) ?? 1;
    notifyListeners();
  }
}
