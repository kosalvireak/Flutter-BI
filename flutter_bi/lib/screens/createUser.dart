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
  var _obscureText = false;

  final _form = GlobalKey<FormState>();
  var _enterdName = '';
  var _enterdEmail = '';
  var _enterPassword = '';
  var _isSendingRequest = false;

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

        var response = await http.post(Uri.parse(registration),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(reqBody));

        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status']) {
          _showScaffold(jsonResponse['msg']);
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
      appBar: AppBar(
        title: const Text('Create User'),
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
                margin: const EdgeInsets.all(50),
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
                            obscureText: !_obscureText,
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
