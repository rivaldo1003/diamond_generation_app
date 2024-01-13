class WPDA {
  final String id;
  final String user_id;
  final String reading_book;
  final String verse_content;
  final String message_of_god;
  final String application_in_life;
  final String doaTabernakel;
  final String created_at;
  Writer writer;
  final String likes;
  final List<Comment> comments;

  WPDA({
    required this.id,
    required this.user_id,
    required this.reading_book,
    required this.verse_content,
    required this.message_of_god,
    required this.application_in_life,
    required this.doaTabernakel,
    required this.created_at,
    required this.writer,
    required this.likes,
    required this.comments,
  });

  factory WPDA.fromJson(Map<String, dynamic> json) {
    return WPDA(
      id: json['id'].toString(),
      user_id: json['user_id'].toString(),
      reading_book: json['reading_book'],
      verse_content: json['verse_content'],
      message_of_god: json['message_of_god'],
      application_in_life: json['application_in_life'],
      doaTabernakel: json['doa_tabernakel'],
      created_at: json['created_at'],
      writer: Writer.fromJson(json['writer']),
      comments: (json['comments'] as List)
          .map((comment) => Comment.fromJson(comment))
          .toList(),
      likes: json['likes'].toString(),
    );
  }
}

class Writer {
  final String id;
  final String full_name;
  final String email;
  String profile_picture;

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

class Comment {
  final int id;
  final int wpdaId;
  final int userId;
  final String commentsContent;
  final String createdAt;
  final Comentator comentator;
  String? profilePicture;

  Comment({
    required this.id,
    required this.wpdaId,
    required this.userId,
    required this.commentsContent,
    required this.createdAt,
    required this.comentator,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      wpdaId: json['wpda_id'] as int,
      userId: json['user_id'] as int,
      commentsContent: json['comments_content'] as String,
      createdAt: json['created_at'] as String,
      comentator: Comentator.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class Comentator {
  final int id;
  final String fullName;
  final String email;
  String profilePicture;

  Comentator({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profilePicture,
  });

  factory Comentator.fromJson(Map<String, dynamic> json) {
    return Comentator(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      profilePicture: json['profile_picture'] as String,
    );
  }
}
