import 'package:flutter/material.dart';
import 'package:flutter_bi/config.dart';
import 'package:flutter_bi/model/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  @override
  State<StatefulWidget> createState() {
    return _UserDetailScreenState();
  }
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  var _obscureText = false;

  final _form = GlobalKey<FormState>();

  var _enterdName = '';
  var _enterdEmail = '';
  var _enterNewPassword = '';
  var _isSendingRequest = false;

  @override
  void initState() {
    _assignUser(widget.user);
    super.initState();
  }

  void _assignUser(User user) {
    setState(() {
      _enterdName = widget.user.name;
      _enterdEmail = widget.user.email;
    });
  }

  void _showScaffold(msg) {
    BuildContext currentContext = context;
    ScaffoldMessenger.of(currentContext).clearSnackBars();
    ScaffoldMessenger.of(currentContext).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
    setState(() {
      _isSendingRequest = false;
    });
  }

  void _onResetUser() async {
    try {
      final isValid = _form.currentState!.validate();

      if (isValid) {
        setState(() {
          _isSendingRequest = true;
        });
        _form.currentState!.save();
        var reqBody = {
          "id": widget.user.id,
          "name": _enterdName,
          "email": _enterdEmail,
          "password": _enterNewPassword
        };

        var response = await http.post(Uri.parse(resetUsers),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(reqBody));

        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status']) {
          _showScaffold("Successfull reset User.");
          return;
        } else {
          _showScaffold(jsonResponse['msg']);
        }
      }
    } catch (error) {
      _showScaffold("Something went wrong.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 39, 72),
      appBar: AppBar(
        title: Text(widget.user.name),
        backgroundColor: const Color.fromARGB(255, 14, 47, 85),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 20,
              bottom: 10,
            ),
            alignment: Alignment.bottomCenter,
            height: 150,
            child: CircleAvatar(
              radius: 90,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(3), // Border radius
                child: ClipOval(
                  child: Image.network(
                    widget.user.image,
                    width: 147,
                    height: 147,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 50, right: 50),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          initialValue: widget.user.name,
                          decoration: const InputDecoration(labelText: 'Name'),
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.trim().length < 5) {
                              return 'Name must be over 5 characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enterdName = value!;
                          },
                        ),
                        TextFormField(
                          initialValue: widget.user.email,
                          decoration:
                              const InputDecoration(labelText: 'Email Address'),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enterdEmail = value!;
                          },
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'New Password'),
                          obscureText: !_obscureText,
                          validator: (value) {
                            if (value == null || value.trim().length < 8) {
                              return 'Password must be at least 8 characters long.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enterNewPassword = value!;
                          },
                        ),
                        const SizedBox(height: 12),
                        CheckboxListTile(
                          title: Text(
                            "Show Password",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          value: _obscureText,
                          onChanged: (value) {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                        const SizedBox(height: 36),
                        if (_isSendingRequest)
                          const CircularProgressIndicator(),
                        if (!_isSendingRequest)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 14, 47, 85),
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _onResetUser,
                            child: const Text(
                              'Reset.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
