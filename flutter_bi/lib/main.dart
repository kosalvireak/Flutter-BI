import 'package:flutter_bi/screens/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bi/screens/home.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    App(
      token: prefs.getString('token'),
    ),
  );
}

class App extends StatelessWidget {
  App({super.key, required this.token});

  var token;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter BI',
      home: (JwtDecoder.isExpired(token) == false)
          ? HomeScreen(token: token)
          : const AuthScreen(),
    );
  }
}
