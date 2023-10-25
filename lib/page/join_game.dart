import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_stat/customModel/user_model.dart';
import 'package:table_stat/customProvider/user_provider.dart';

class JoinGameScreen extends StatefulWidget {
  @override
  _JoinGameScreenState createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  final gameIdController = TextEditingController();
  String commanderName = "";
  late StreamSubscription<dynamic> _subscription;

  late UserProvider userProvider;
  late DatabaseReference gameRef;
  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
  }

  void joinGame(String gameId, UserModel curentUser, String commanderName) {
    gameRef = FirebaseDatabase.instance
        .ref()
        .child('root')
        .child('Games')
        .child(gameId);

    gameRef.child('Users').update({
      curentUser.uid: {
        "pv": 40,
        "name": curentUser.username,
        "commander": commanderName,
      },
    });

    _subscription = gameRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.child("status").value == "playing" && mounted) {
        Navigator.pushReplacementNamed(context, '/gameScreen');
      }
    });
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
        title: const Text('Join Game'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownMenu(
                onSelected: (e) => setState(() {
                  commanderName = e.toString();
                }),
                dropdownMenuEntries: userProvider.user.commanders
                    .map((e) => DropdownMenuEntry(value: e, label: e))
                    .toList(),
              ),
              if (commanderName.isNotEmpty) ...[
                TextField(
                  controller: gameIdController,
                  decoration: const InputDecoration(labelText: 'Game ID'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => joinGame(
                    gameIdController.text,
                    userProvider.user,
                    commanderName,
                  ),
                  child: const Text('Join Game'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// TextField(
//                 controller: numberOfPlayerController,
//                 decoration: InputDecoration(labelText: 'Number of player'),
//               ),
//               const SizedBox(height: 20),
//               DropdownMenu(
//                 onSelected: (e) => setState(() {
//                   commanderName = e.toString();
//                 }),
//                 dropdownMenuEntries: userProvider.user.commanders
//                     .map((e) => DropdownMenuEntry(value: e, label: e))
//                     .toList(),
//               ),
//               Spacer(),
//               Text("Your Game ID: $gameId"),
//               if (_playerList.isNotEmpty)
//                 ..._playerList.map(
//                   (e) => ListTile(
//                       title: Text(e["name"].toString()),
//                       subtitle: Text(e["commander"].toString()),
//                       trailing: IconButton(
//                         onPressed: () => {},
//                         icon: Icon(Icons.delete),
//                       )),
//                 ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => createGame(),
//                 child: Text('Create Game'),
//               ),

// @override
//   void initState() {
//     super.initState();
//     userProvider = Provider.of<UserProvider>(
//       context,
//       listen: false,
//     );
//   }

// String gameId = "";
//   late UserProvider userProvider;

//   final List<Map<String, String>> _playerList = [];

//   final numberOfPlayerController = TextEditingController();
//   String commanderName = "";

//   String generateGameId() {
//     var rng = Random();
//     var code = '';
//     for (var i = 0; i < 6; i++) {
//       code += rng.nextInt(10).toString();
//     }
//     return code;
//   }

//   void createGame() {
//     gameId = generateGameId();

//     DatabaseReference databaseReference = FirebaseDatabase.instance
//         .ref()
//         .child("root")
//         .child('Games')
//         .child(gameId);

//     databaseReference.set({
//       "nbPlayer": numberOfPlayerController.text,
//     });

//     joinGame(gameId, userProvider.user, commanderName);

//     databaseReference.onValue.listen((event) {
//       DataSnapshot snapshot = event.snapshot;
//       final Map<Object?, Object?> users =
//           snapshot.child("Users").value as Map<Object?, Object?>;

//       print(users);
//       if (_playerList != null) _playerList!.clear();

//       users.map((key, value) {
//         final Map<Object?, Object?> data = value as Map<Object?, Object?>;
//         print(data["name"].toString());

//         _playerList.add({
//           "name": data["name"].toString(),
//           "commander": data["commander"].toString(),
//         });

//         return MapEntry(key, value);
//       });

//       print("PLAYER LIST => $_playerList");

//       setState(() {});
//     });

//     setState(() {});
//   }

//   void joinGame(String gameId, UserModel curentUser, String commanderName) {
//     DatabaseReference gameRef = FirebaseDatabase.instance
//         .ref()
//         .child('root')
//         .child('Games')
//         .child(gameId)
//         .child('Users');
//     gameRef.update({
//       curentUser.uid: {
//         "pv": 40,
//         "name": curentUser.username,
//         "commander": commanderName,
//       },
//     });
//   }
