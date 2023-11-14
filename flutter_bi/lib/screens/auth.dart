import 'package:flutter/material.dart';
import 'package:flutter_bi/screens/createUser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bi/config.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  var _enterdEmail = '';
  var _enterPassword = '';
  var _isSendingRequest = false;

  void _onlogin() async {
    try {
      setState(() {
        _isSendingRequest = true;
      });
      final isValid = _form.currentState!.validate();

      if (isValid) {
        _form.currentState!.save();
        var reqBody = {"email": _enterdEmail, "password": _enterPassword};
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
          Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const CreateUserScreen()));
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
                'Business Intelligence',
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
                              onPressed: _onlogin,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer),
                              child: Text(_isLogin ? 'Login' : 'Signup'),
                            ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(_isLogin
                                ? 'Create an account.'
                                : 'Already have an account? Login!'),
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
