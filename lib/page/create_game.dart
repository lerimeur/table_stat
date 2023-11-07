import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:table_stat/customModel/user_model.dart';
import 'package:table_stat/customProvider/user_provider.dart';
import 'package:table_stat/main.dart';

class CreateGameScreen extends StatefulWidget {
  @override
  _CreateGameScreenState createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  String gameId = "";
  late UserProvider userProvider;

  final List<Map<String, String>> _playerList = [];
  late StreamSubscription<dynamic> _subscription;

  final numberOfPlayerController = TextEditingController();
  String commanderName = "";

  String generateGameId() {
    var rng = Random();
    var code = '';
    for (var i = 0; i < 6; i++) {
      code += rng.nextInt(10).toString();
    }
    return code;
  }

  void createGame() {
    gameId = generateGameId();
    userProvider.setGameId(gameId);

    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child("root")
        .child('Games')
        .child(gameId)
        .child('listenableData');

    databaseReference.set({
      "turn": '0',
      "nbPlayer": numberOfPlayerController.text,
      "status": "waiting",
    });

    joinGame(gameId, userProvider.user, commanderName);

    _subscription = databaseReference.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      final Map<Object?, Object?> users =
          snapshot.child("Users").value as Map<Object?, Object?>;

      _playerList.clear();

      users.map((key, value) {
        final Map<Object?, Object?> data = value as Map<Object?, Object?>;

        _playerList.add({
          "name": data["name"].toString(),
          "commander": data["commander"].toString(),
        });

        return MapEntry(key, value);
      });

      if (mounted) setState(() {});
      if (_playerList.isNotEmpty &&
          _playerList.length == int.parse(numberOfPlayerController.text)) {
        _updateStatus();
        Navigator.pushReplacementNamed(context, '/gameScreen');
      }
    });

    setState(() {});
  }

  void joinGame(String gameId, UserModel curentUser, String commanderName) {
    DatabaseReference gameRef = FirebaseDatabase.instance
        .ref()
        .child('root')
        .child('Games')
        .child(gameId)
        .child('listenableData')
        .child('Users');
    gameRef.update({
      curentUser.uid: {
        "pv": 40,
        "name": curentUser.username,
        "commander": commanderName,
      },
    });
  }

  void _updateStatus() {
    DatabaseReference gameRef = FirebaseDatabase.instance
        .ref()
        .child('root')
        .child('Games')
        .child(gameId)
        .child('listenableData');

    gameRef.update({
      "status": "playing",
    });
  }

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Game'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: numberOfPlayerController,
                decoration: InputDecoration(labelText: 'Number of player'),
              ),
              const SizedBox(height: 20),
              DropdownMenu(
                onSelected: (e) => setState(() {
                  commanderName = e.toString();
                }),
                dropdownMenuEntries: userProvider.user.commanders
                    .map((e) => DropdownMenuEntry(value: e, label: e))
                    .toList(),
              ),
              Spacer(),
              Text("Your Game ID: $gameId"),
              if (_playerList.isNotEmpty)
                ..._playerList.map(
                  (e) => ListTile(
                      title: Text(e["name"].toString()),
                      subtitle: Text(e["commander"].toString()),
                      trailing: IconButton(
                        onPressed: () => {},
                        icon: Icon(Icons.delete),
                      )),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => createGame(),
                child: Text('Create Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
