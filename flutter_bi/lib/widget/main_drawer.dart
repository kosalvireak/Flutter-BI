import 'package:flutter/material.dart';
import 'package:flutter_bi/screens/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer(
      {super.key, required this.onSelectScreen, required this.token});

  final void Function(String identifier) onSelectScreen;
  final String? token;

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  void _logOut(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      backgroundColor: const Color.fromARGB(255, 14, 47, 85),
      child: Column(
        children: [
          const DrawerHeader(
            // padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 14, 47, 85),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.add_chart_outlined,
                  size: 40,
                  color: Colors.white,
                ),
                SizedBox(width: 18),
                Text(
                  'BI',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
              leading: const Icon(
                Icons.person,
                size: 26,
                color: Colors.white,
              ),
              title: const Text(
                'Users',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                widget.onSelectScreen('allusers');
              }),
          ListTile(
            leading: const Icon(
              Icons.person_add_alt_1_sharp,
              size: 26,
              color: Colors.white,
            ),
            title: const Text(
              'Create User',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () {
              widget.onSelectScreen('createusers');
            },
          ),
          const SizedBox(height: 380),
          ListTile(
            leading: const Icon(
              Icons.logout,
              size: 26,
              color: Colors.white,
            ),
            title: const Text(
              'Logout!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () {
              _logOut(context);
            },
          ),
        ],
      ),
    );
  }
}
