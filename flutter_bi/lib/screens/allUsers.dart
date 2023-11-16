import 'package:flutter/material.dart';
import 'package:flutter_bi/screens/userDetail.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_bi/model/User.dart';
import 'package:flutter_bi/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key, required this.token});
  final String? token;

  @override
  State<StatefulWidget> createState() {
    return _AllUsersState();
  }
}

class _AllUsersState extends State<AllUsers> {
  late String email;
  List? users = [];

  void _getUsers() async {
    var reqBody = {"email": email};

    var response = await http.post(Uri.parse(getUsers),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));
    var jsonResponse = jsonDecode(response.body);
    users = jsonResponse['users'];
    setState(() {});
  }

  bool _isOwner(shownUser) {
    return email == shownUser;
  }

  void _selectUser(BuildContext context, User user) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => UserDetailScreen(user: user)));
  }

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token!);
    // ignore: avoid_print
    email = jwtDecodedToken['email'].toString();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: users!.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            tileColor: _isOwner(users![index]['email'])
                ? const Color.fromARGB(255, 255, 255, 255)
                : const Color.fromARGB(134, 169, 165, 165),
            leading: const Icon(Icons.person_sharp),
            title: Text(users![index]['name']),
            trailing: Text(users![index]['email']),
            textColor: const Color.fromARGB(255, 14, 47, 85),
            iconColor: const Color.fromARGB(255, 14, 47, 85),
            onTap: () {
              var user = User.fromJson(users![index]);
              _selectUser(context, user);
            },
          ),
        ),
      ),
    );
    if (users == null) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Uh ho... Nothing here!',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Try selecting a different category!',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            )
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: content),
      ],
    );
  }
}
