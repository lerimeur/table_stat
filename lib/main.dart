import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_stat/customProvider/user_provider.dart';
import 'package:table_stat/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:table_stat/page/create_game.dart';
import 'package:table_stat/page/dashboard_page.dart';
import 'package:table_stat/page/game_screen.dart';
import 'package:table_stat/page/join_game.dart';
import 'package:table_stat/page/login_page.dart';
import 'package:table_stat/page/profile_page.dart';
import 'package:table_stat/page/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    Provider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => DashboardScreen(),
        '/createGame': (context) => CreateGameScreen(),
        '/joinGame': (context) => JoinGameScreen(),
        '/profile': (context) => ProfilePage(),
        '/gameScreen': (context) => GameScreen(),
      },
    );
  }
}
