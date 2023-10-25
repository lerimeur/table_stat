import 'package:table_stat/customModel/user_model.dart';

class UserProvider {
  UserModel _user = UserModel(uid: '', username: 'test', commanders: []);

  UserModel get user => _user;

  void setUser(UserModel user) {
    _user = user;
  }

  void clearUser() {
    _user = UserModel(uid: '', username: '', commanders: []);
  }
}
