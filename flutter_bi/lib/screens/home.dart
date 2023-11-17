import 'package:flutter/material.dart';
import 'package:flutter_bi/screens/allUsers.dart';
import 'package:flutter_bi/model/User.dart';
import 'package:flutter_bi/screens/userDetail.dart';
import 'package:flutter_bi/screens/createUser.dart';
import 'package:flutter_bi/widget/main_drawer.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.token});

  final String? token;

  @override
  State<StatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<HomeScreen> {
  final _selectedPageIndex = 0;
  String? imageUrl;
  late User user;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token!);
    user = User(
      id: jwtDecodedToken['id'],
      image: jwtDecodedToken['image'],
      name: jwtDecodedToken['name'],
      email: jwtDecodedToken['email'],
    );

    imageUrl = jwtDecodedToken['image'].toString();
  }

  void _selectUser(BuildContext context, User user) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => UserDetailScreen(user: user)));
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
    Widget activePage = AllUsers(token: widget.token!);
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
              _selectUser(context, user);
            },
            child: CircleAvatar(
              radius: 40,
              backgroundColor: const Color.fromARGB(255, 14, 47, 85),
              child: ClipOval(
                child: Image.network(
                  imageUrl!,
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // child: Container(
            //   margin: const EdgeInsets.only(
            //     top: 5,
            //     bottom: 5,
            //   ),
            //   alignment: Alignment.bottomCenter,
            //   height: 50,
            //   child: CircleAvatar(
            //     radius: 90,
            //     backgroundColor: Colors.white,
            //     child: Padding(
            //       padding: const EdgeInsets.all(3), // Border radius
            //       child: ClipOval(
            //         child: Image.network(
            //           imageUrl,
            //           width: 47,
            //           height: 47,
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ),
        ],
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
        token: widget.token!,
      ),
      body: activePage,
    );
  }
}
