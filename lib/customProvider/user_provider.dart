import 'package:table_stat/customModel/user_model.dart';

class UserProvider {
  UserModel _user = UserModel(uid: '', username: 'test', commanders: []);

  String _gameId = "0";
  UserModel get user => _user;
  String get gameId => _gameId;

  void setGameId(String gameId) {
    _gameId = gameId;
  }

  void setUser(UserModel user) {
    _user = user;
  }

  void clearUser() {
    _user = UserModel(uid: '', username: '', commanders: []);
  }
}
