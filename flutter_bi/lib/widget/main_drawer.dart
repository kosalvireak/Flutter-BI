import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                onSelectScreen('allusers');
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
                onSelectScreen('createusers');
              }),
        ],
      ),
    );
  }
}
