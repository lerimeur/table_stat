import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:table_stat/customModel/user_model.dart';
import 'package:table_stat/customProvider/user_provider.dart';
import 'package:table_stat/main.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();

  void _register() async {
    try {
      // TODO(greg): LOADER.
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print("User registered: ${userCredential.user}");

      DatabaseReference usersRef =
          FirebaseDatabase.instance.ref().child('root').child('Users');
      String uid = userCredential.user!.uid;

      usersRef.child(uid).set({
        'email': _emailController.text,
        'username': _usernamecontroller.text,
      });

      usersRef.child(userCredential.user!.uid).onValue.listen((event) {
        DataSnapshot snapshot = event.snapshot;

        UserProvider userProvider = Provider.of<UserProvider>(
          context,
          listen: false,
        );

        final List<Object?>? comanderMap =
            snapshot.child("commanders").value as List<Object?>?;

        userProvider.setUser(UserModel(
          uid: userCredential.user!.uid,
          username: snapshot.child("username").value.toString(),
          commanders: comanderMap == null
              ? []
              : List.generate(
                  comanderMap.length,
                  (index) => comanderMap[index].toString(),
                ),
        ));
      });

      if (mounted) Navigator.pushNamed(context, '/dashboard');
    } catch (e) {
      print("Error: $e");
    }
  }

  void _goLogin() async {
    try {
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
            TextField(
              controller: _usernamecontroller,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: _goLogin,
              child: Text('go login'),
            ),
          ],
        ),
      ),
    );
  }
}
