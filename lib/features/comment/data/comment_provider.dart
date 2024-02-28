import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:flutter/material.dart';

class CommentProvider extends ChangeNotifier {
  List<Comment> _comments = [];

  List<Comment> get comments => _comments;

  void addComment(Comment comment) {
    _comments.add(comment);
    notifyListeners();
  }

  int getCommentLength() {
    return _comments.length;
  }

  void updateComments(List<Comment> newComments) {
    _comments = newComments;
    notifyListeners();
  }
}

class CommentWpdaModel {
  final String id;
  final String fullName;
  final String commentsContent;
  final String profilePicture;

  CommentWpdaModel({
    required this.id,
    required this.fullName,
    required this.commentsContent,
    required this.profilePicture,
  });
}
