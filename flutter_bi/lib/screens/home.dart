import 'package:flutter/material.dart';
import 'package:flutter_bi/screens/allUsers.dart';
import 'package:flutter_bi/screens/createUser.dart';
import 'package:flutter_bi/widget/main_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<HomeScreen> {
  int _selectedPageIndex = 0;

  void _selectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
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
    Widget activePage = const AllUsers();
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
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
    );
  }
}
