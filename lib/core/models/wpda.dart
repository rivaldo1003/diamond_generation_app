class WPDA {
  final String id;
  final String user_id;
  final String reading_book;
  final String verse_content;
  final String message_of_god;
  final String application_in_life;
  final String created_at;
  final Writer writer;

  WPDA({
    required this.id,
    required this.user_id,
    required this.reading_book,
    required this.verse_content,
    required this.message_of_god,
    required this.application_in_life,
    required this.created_at,
    required this.writer,
  });

  factory WPDA.fromJson(Map<String, dynamic> json) {
    return WPDA(
      id: json['id'].toString(),
      user_id: json['user_id'].toString(),
      reading_book: json['reading_book'],
      verse_content: json['verse_content'],
      message_of_god: json['message_of_god'],
      application_in_life: json['application_in_life'],
      created_at: json['created_at'],
      writer: Writer.fromJson(json['writer']),
    );
  }
}

class Writer {
  final String id;
  final String full_name;
  final String email;
  final String profile_picture;

  Writer({
    required this.id,
    required this.full_name,
    required this.email,
    required this.profile_picture,
  });

  factory Writer.fromJson(Map<String, dynamic> json) {
    return Writer(
      id: json['id'].toString(),
      full_name: json['full_name'],
      email: json['email'],
      profile_picture: json['profile_picture'] ?? '',
    );
  }
}
