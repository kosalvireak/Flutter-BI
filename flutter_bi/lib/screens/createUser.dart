import 'dart:convert';
import 'package:flutter_bi/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CreateUserScreenState();
  }
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _form = GlobalKey<FormState>();
  var _enterdName = '';
  var _enterdEmail = '';
  var _enterPassword = '';
  var _isSendingRequest = false;

  void _onCreateNewUser() async {
    try {
      setState(() {
        _isSendingRequest = true;
      });
      final isValid = _form.currentState!.validate();

      if (isValid) {
        _form.currentState!.save();
        var reqBody = {
          "name": _enterdName,
          "email": _enterdEmail,
          "password": _enterPassword
        };
        BuildContext currentContext = context;

        var response = await http.post(Uri.parse(registration),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(reqBody));

        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status']) {
          setState(() {
            _isSendingRequest = false;
          });
          ScaffoldMessenger.of(currentContext).clearSnackBars();
          ScaffoldMessenger.of(currentContext).showSnackBar(
            const SnackBar(
              content: Text('Successfully create new User.'),
            ),
          );
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 39, 72),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'You are creating a new user!',
                style: TextStyle(color: Colors.white, fontSize: 27),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Name'),
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
                            decoration: const InputDecoration(
                                labelText: 'Email Address'),
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
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 8) {
                                return 'Password must be at least 8 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enterPassword = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          if (_isSendingRequest)
                            const CircularProgressIndicator(),
                          if (!_isSendingRequest)
                            ElevatedButton(
                              onPressed: _onCreateNewUser,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer),
                              child: const Text('Create New User.'),
                            ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Go Back!'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
