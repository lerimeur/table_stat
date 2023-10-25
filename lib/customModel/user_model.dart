class UserModel {
  final String uid;
  final String username;
  final List<String> commanders;

  get getUsername => username;
  get getUid => uid;
  get comanderList => commanders;

  void removeCommander(String commander) {
    commanders.remove(commander);
  }

  void addCommander(String commander) {
    commanders.add(commander);
  }

  UserModel({
    required this.uid,
    required this.username,
    required this.commanders,
  });
}
