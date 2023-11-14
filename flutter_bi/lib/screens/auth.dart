import 'package:flutter/material.dart';
import 'package:flutter_bi/screens/createUser.dart';
import 'package:flutter_bi/screens/home.dart';
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
  var _obscureText = false;

  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  var _enterdEmail = '';
  var _enterPassword = '';
  var _isSendingRequest = false;

  void _onlogin() async {
    // try {
    setState(() {
      _isSendingRequest = true;
    });
    //   final isValid = _form.currentState!.validate();

    //   if (isValid) {
    //     _form.currentState!.save();
    //     var reqBody = {"email": _enterdEmail, "password": _enterPassword};
    //     BuildContext currentContext = context;

    //     var response = await http.post(Uri.parse(registration),
    //         headers: {"Content-Type": "application/json"},
    //         body: jsonEncode(reqBody));

    //     var jsonResponse = jsonDecode(response.body);

    //     if (jsonResponse['status']) {
    //       setState(() {
    //         _isSendingRequest = false;
    //       });
    //       ScaffoldMessenger.of(currentContext).clearSnackBars();
    //       ScaffoldMessenger.of(currentContext).showSnackBar(
    //         const SnackBar(
    //           content: Text('Successfully create new User.'),
    //         ),
    //       );
    setState(() {
      _isSendingRequest = false;
    });
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const HomeScreen()));

    //     }
    //   }
    // } catch (error) {
    //   ScaffoldMessenger.of(context).clearSnackBars();
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Something went wrong.'),
    //     ),
    //   );
    // }
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
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w500),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 24),
                          const Text(
                            'Log in to your account',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 12),
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
                            title: const Text(
                              "Show Password",
                              style: TextStyle(
                                color: Colors.black,
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
                          const SizedBox(height: 24),
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
                              onPressed: _onlogin,
                              child: const Text(
                                'Login as Admin',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          const SizedBox(height: 24),
                          // TextButton(
                          //   onPressed: () {
                          //     setState(() {
                          //       _isLogin = !_isLogin;
                          //     });
                          //   },
                          //   child: Text('Login!'),
                          // ),
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
