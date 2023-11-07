import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:table_stat/customModel/user_model.dart';
import 'package:table_stat/customProvider/user_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print("User logged in");

      final DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref();

      databaseReference
          .child('root/Users/${userCredential.user!.uid}')
          .onValue
          .listen((event) {
        DataSnapshot snapshot = event.snapshot;

        if (mounted) {
          UserProvider userProvider = Provider.of<UserProvider>(
            context,
            listen: false,
          );
          final List<Object?> comanderMap =
              snapshot.child("commanders").value as List<Object?>;

          userProvider.setUser(UserModel(
            uid: userCredential.user!.uid,
            username: snapshot.child("username").value.toString(),
            commanders: List.generate(
              comanderMap.length,
              (index) => comanderMap[index].toString(),
            ),
          ));
        }
      });

      if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      print("Error: $e");
    }
  }

  void _goRegister() async {
    try {
      Navigator.pushReplacementNamed(context, '/register');
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: _goRegister,
              child: Text('go register'),
            ),
          ],
        ),
      ),
    );
  }
}
