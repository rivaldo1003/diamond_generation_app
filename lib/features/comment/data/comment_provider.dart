import 'package:diamond_generation_app/features/comment/presentation/comment_tes.dart';
import 'package:flutter/material.dart';

class CommentProvider extends ChangeNotifier {
  List<Comment> _comments = [];

  List<Comment> get comments => _comments;

  void addComment(String text) {
    _comments.add(Comment(text));
    notifyListeners();
  }
}
