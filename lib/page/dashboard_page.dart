import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'dart:math';

String generateGameId() {
  var rng = Random();
  var code = '';
  for (var i = 0; i < 6; i++) {
    code += rng.nextInt(10).toString();
  }
  return code;
}

class DashboardScreen extends StatelessWidget {
  // void joinGame(String gameId, String playerData) {
  //   DatabaseReference gameRef =
  //       FirebaseDatabase.instance.ref().child('root').child(gameId);
  //   gameRef.update({
  //     playerData: '{"score": 0, "name": "alan"}',
  //   });
  // }

  // void createGame({isCreator = false}) {
  //   final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  //   String gameId = generateGameId();
  //   databaseReference.child("root").child(gameId).set({});
  // }

  // void fetchDataRealtime() {
  //   final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  //   databaseReference.onValue.listen((event) {
  //     DataSnapshot snapshot = event.snapshot;
  //     print('Data : ${snapshot.value}');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/joinGame'),
              child: Text('Join Game'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/createGame'),
              child: Text('Create Game'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              child: Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
