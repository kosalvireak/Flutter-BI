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
      final isValid = _form.currentState!.validate();

      if (isValid) {
        setState(() {
          _isSendingRequest = true;
        });
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
      appBar: AppBar(
        title: const Text('Create New User'),
        backgroundColor: const Color.fromARGB(255, 14, 47, 85),
      ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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
                              onPressed: _onCreateNewUser,
                              child: const Text(
                                'Create New User.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          const SizedBox(height: 24),
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
