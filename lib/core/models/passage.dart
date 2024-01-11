class BibleBook {
  final int no;
  final String abbr;
  final String name;
  final int chapter;

  BibleBook({
    required this.no,
    required this.abbr,
    required this.name,
    required this.chapter,
  });

  factory BibleBook.fromJson(Map<String, dynamic> json) {
    return BibleBook(
      no: json['no'] as int,
      abbr: json['abbr'] as String,
      name: json['name'] as String,
      chapter: json['chapter'] as int,
    );
  }
}

class BibleApiResponse {
  final List<BibleBook> data;

  BibleApiResponse({
    required this.data,
  });

  factory BibleApiResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> bookList = json['data'];
    List<BibleBook> books =
        bookList.map((book) => BibleBook.fromJson(book)).toList();
    return BibleApiResponse(
      data: books,
    );
  }
}
