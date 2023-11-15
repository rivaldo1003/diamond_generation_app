import 'package:diamond_generation_app/core/models/user.dart';
import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDataProvider extends ChangeNotifier {
  late List<User> _users;
  late List<User> _fiteredUser;
  late bool _isSortedByName;

  UserDataProvider(BuildContext context, String urlApi) {
    _users = [];
    _fiteredUser = [];
    _isSortedByName = false;
    fetchData(context, urlApi);
  }

  List<User> get users => _users;
  List<User> get fiteredUser => _fiteredUser;
  bool get isSortedByName => _isSortedByName;

  void fetchData(BuildContext context, String urlApi) async {
    final getUserUsecase = Provider.of<GetUserUsecase>(context, listen: false);
    try {
      List<User> users = await getUserUsecase.execute(urlApi);
      _users = users;
      _fiteredUser = users;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void sortUser() {
    if (_isSortedByName) {
      _users.sort((a, b) => a.id.compareTo(b.id));
    } else {
      _users.sort((a, b) => a.fullName.compareTo(b.fullName));
    }
    _isSortedByName = !_isSortedByName;
    notifyListeners();
  }

  void searchUser(String query) {
    List<User> filteredUsers = _users
        .where(
            (user) => user.fullName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    _fiteredUser = filteredUsers;
    notifyListeners();
  }
}
