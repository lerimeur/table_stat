import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:table_stat/main.dart';
import 'package:table_stat/customProvider/user_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _commanderController = TextEditingController();
  late UserProvider userProvider;

  late DatabaseReference databaseRef;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    print("INIT ${userProvider.user.uid}");

    databaseRef = FirebaseDatabase.instance
        .ref()
        .child('root')
        .child('Users')
        .child(userProvider.user.uid);
  }

  void _removeCommander(String commanderName) {
    userProvider.user.removeCommander(commanderName);

    databaseRef.update({
      "commanders": userProvider.user.commanders,
    });
    setState(() {});
  }

  void _addComander() {
    print(userProvider.user.uid);
    userProvider.user
        .addCommander(_commanderController.text.replaceAll(' ', ''));

    databaseRef.update({
      "commanders": userProvider.user.commanders,
    });

    setState(() {
      _commanderController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _commanderController,
              decoration:
                  const InputDecoration(labelText: 'Enter commander name'),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addComander,
                child: const Text('add comander'),
              ),
            ),
            const Text("Commanders List"),
            ...userProvider.user.commanders.map(
              (e) => Row(
                children: [
                  Text(e),
                  const Spacer(),
                  IconButton(
                    onPressed: () => _removeCommander(e),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
