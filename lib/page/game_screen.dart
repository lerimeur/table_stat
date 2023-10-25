import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_stat/customModel/user_model.dart';
import 'package:table_stat/customProvider/user_provider.dart';

class GameUsers {
  final String id;
  final String name;
  final String commander;
  final String pv;

  GameUsers({
    required this.id,
    required this.name,
    required this.commander,
    required this.pv,
  });
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late UserProvider userProvider;

  List<dynamic> _playerList = [];

  // TODO(greg):load the gameId store previously in the phone.

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    _initGameData();
  }

  void _initGameData() {
    DatabaseReference gameRef = FirebaseDatabase.instance
        .ref()
        .child('root')
        .child('Games')
        .child("507536")
        .child("Users");

    gameRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      final Map<Object?, Object?> users =
          snapshot.value as Map<Object?, Object?>;

      _playerList.clear();
      users.map((key, value) {
        final elem = value as Map<Object?, Object?>;

        _playerList.add(
          GameUsers(
            id: key.toString(),
            name: elem["name"].toString(),
            commander: elem["commander"].toString(),
            pv: elem["pv"].toString(),
          ),
        );

        return MapEntry(key, value);
      });
      // if (_playerList != null) _playerList.clear();

      // users.map((key, value) {
      //   final Map<Object?, Object?> data = value as Map<Object?, Object?>;
      //   print(data["name"].toString());
      //   _playerList.add(data["name"].toString());
      // });

      // setState(() {});
    });
  }

  // void joinGame(String gameId, UserModel curentUser, String commanderName) {
  //   DatabaseReference gameRef = FirebaseDatabase.instance
  //       .ref()
  //       .child('root')
  //       .child('Games')
  //       .child(gameId)
  //       .child('Users');

  //   gameRef.update({
  //     curentUser.uid: {
  //       "pv": 40,
  //       "name": curentUser.username,
  //       "commander": commanderName,
  //     },
  //   });
  // }

  void _downPv(GameUsers player) {
    DatabaseReference gameRef = FirebaseDatabase.instance
        .ref()
        .child('root')
        .child('Games')
        .child("507536")
        .child("Users")
        .child(player.id);

    gameRef.update({
      "pv": int.parse(player.pv) - 1,
    }).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    _initGameData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Screen'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ..._playerList.map(
                (e) => ListTile(
                  onTap: () => _downPv(e),
                  title: Text(e.name),
                  subtitle: Text(e.commander),
                  trailing: Text(e.pv),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
