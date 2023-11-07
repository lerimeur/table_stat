import 'dart:convert';
import 'dart:developer';

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

class GameData {
  GameData({
    required this.turn,
  });

  final turn;
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late UserProvider userProvider;

  List<dynamic> _playerList = [];

  late GameData _gameData;

  int _value = 0;
  bool _isPressedIncrement = false;
  bool _isPressedDecrement = false;

  // TODO(greg):load the gameId store previously in the phone.

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    Future.delayed(const Duration(seconds: 1), () => _initGameData());
  }

  // void _listenGameStatus() {
  //   // DatabaseReference gameRef = FirebaseDatabase.instance
  //   //     .ref()
  //   //     .child('root')
  //   //     .child('Games')
  //   //     .child(userProvider.gameId)
  //   //     .child("Users");
  // }

  // void _initUserTab() {
  // DatabaseReference gameRef = FirebaseDatabase.instance
  //     .ref()
  //     .child('root')
  //     .child('Games')
  //     .child(userProvider.gameId)
  //     .child("Users");

  // gameRef.onValue.listen((event) {
  // DataSnapshot snapshot = event.snapshot;
  // final Map<Object?, Object?> users = snapshot.value as Map<Object?, Object?>;

  // _playerList.clear();
  // users.map((key, value) {
  //   final elem = value as Map<Object?, Object?>;

  //   _playerList.add(
  //     GameUsers(
  //       id: key.toString(),
  //       name: elem["name"].toString(),
  //       commander: elem["commander"].toString(),
  //       pv: elem["pv"].toString(),
  //     ),
  //   );

  //   return MapEntry(key, value);
  // });

  // setState(() {});
  // });
  // }

  void _buildUserList(Map<Object?, Object?> users) {
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

    // setState(() {});
  }

  void _initGameData() {
    DatabaseReference gameRef = FirebaseDatabase.instance
        .ref()
        .child('root')
        .child('Games')
        .child(userProvider.gameId)
        .child("listenableData");

    gameRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      final Map<Object?, Object?> listenedData =
          snapshot.value as Map<Object?, Object?>;

      inspect(listenedData);

      //! BUILD GAME OBJECTS
      _buildUserList(listenedData["Users"] as Map<Object?, Object?>);

      // final Map<Object?, Object?> users =
      //     snapshot.value as Map<Object?, Object?>;

      // _gameData = GameData(turn: listenedData["turn"].toString());

      setState(() {});
    });
  }

  // void _downTurn(GameUsers player) {
  //   DatabaseReference gameRef = FirebaseDatabase.instance
  //       .ref()
  //       .child('root')
  //       .child('Games')
  //       .child(userProvider.gameId);

  //   gameRef.update({
  //     "turn": int.parse(player.pv) - 1,
  //   }).then((value) => setState(() {}));
  // }

  void _downPv(GameUsers player) {
    DatabaseReference gameRef = FirebaseDatabase.instance
        .ref()
        .child('root')
        .child('Games')
        .child(userProvider.gameId)
        .child("listenableData")
        .child("Users")
        .child(player.id);

    gameRef.update({
      "pv": int.parse(player.pv) - 1,
    }).then((value) => setState(() {}));
  }

  void _increment() {
    setState(() {
      _value++;
    });
  }

  void _decrement() {
    setState(() {
      _value--;
    });
  }

  void _updateIncrementPressState(bool isPressed) {
    setState(() {
      _isPressedIncrement = isPressed;
    });
  }

  void _updateDecrementPressState(bool isPressed) {
    setState(() {
      _isPressedDecrement = isPressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
      ),
      body: SafeArea(
        child: _playerList.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _LifeRow(
                    playerList: _playerList,
                    buttonClick: _downPv,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTapDown: (_) => _updateDecrementPressState(true),
                            onTapUp: (_) {
                              _updateDecrementPressState(false);
                              _decrement();
                            },
                            onTapCancel: () =>
                                _updateDecrementPressState(false),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 100),
                              width: 100,
                              height: 50,
                              decoration: BoxDecoration(
                                color: _isPressedDecrement
                                    ? Colors.red
                                    : Colors.blue,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              child: Center(
                                  child:
                                      Icon(Icons.remove, color: Colors.white)),
                            ),
                          ),
                          GestureDetector(
                            onTapDown: (_) => _updateIncrementPressState(true),
                            onTapUp: (_) {
                              _updateIncrementPressState(false);
                              _increment();
                            },
                            onTapCancel: () =>
                                _updateIncrementPressState(false),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 100),
                              width: 100,
                              height: 50,
                              decoration: BoxDecoration(
                                color: _isPressedIncrement
                                    ? Colors.green
                                    : Colors.blue,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Center(
                                  child: Icon(Icons.add, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        child: Text(
                          '$_value',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Container(),
      ),
    );
  }
}

class _LifeRow extends StatelessWidget {
  _LifeRow({required this.playerList, required this.buttonClick});

  final Function(GameUsers player) buttonClick;
  List<dynamic> playerList;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...playerList.map(
          (e) => Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(3),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                onPressed: () => buttonClick(e),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [Text(e.name), Text(e.pv)],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
