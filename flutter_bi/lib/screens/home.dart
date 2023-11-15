import 'package:flutter/material.dart';
import 'package:flutter_bi/screens/allUsers.dart';
import 'package:flutter_bi/screens/auth.dart';
import 'package:flutter_bi/screens/createUser.dart';
import 'package:flutter_bi/widget/main_drawer.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.token});

  final token;

  @override
  State<StatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<HomeScreen> {
  int _selectedPageIndex = 0;
  var imageUrl;
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    imageUrl = jwtDecodedToken['image'];
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'createusers') {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const CreateUserScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = AllUsers(token: widget.token);
    var activePageTitle = 'All Users';
    if (_selectedPageIndex == 1) {
      activePage = const CreateUserScreen();
      activePageTitle = 'Create new User.';
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 39, 72),
      appBar: AppBar(
        title: Text(activePageTitle),
        backgroundColor: const Color.fromARGB(255, 14, 47, 85),
        actions: [
          GestureDetector(
            onTap: () {
              print("User Profile Click!");
            },
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(3), // Border radius
                child: ClipOval(child: Image.network(imageUrl)),
              ),
            ),
          ),
        ],
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
        token: widget.token,
      ),
      body: activePage,
    );
  }
}
