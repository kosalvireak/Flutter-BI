import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key, required this.token});
  final String token;

  @override
  State<StatefulWidget> createState() {
    return _AllUsersState();
  }
}

class _AllUsersState extends State<AllUsers> {
  late String email;
  late String user;

  void _getUsers() {
    setState(() {
      user = "";
    });
  }

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    print("jwtDecodedToken ${jwtDecodedToken}");
    email = jwtDecodedToken['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Text(email);
  }
}
