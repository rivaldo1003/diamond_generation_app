import 'package:flutter/material.dart';

class LikeProvider extends ChangeNotifier {
  Set<int> likedWpdas = {};

  void toggleLike(int wpdaId) {
    if (likedWpdas.contains(wpdaId)) {
      likedWpdas.remove(wpdaId);
    } else {
      likedWpdas.add(wpdaId);
    }

    notifyListeners();
  }

  bool isLiked(int wpdaId) {
    return likedWpdas.contains(wpdaId);
  }
}
