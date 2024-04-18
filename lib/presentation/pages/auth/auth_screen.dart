// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:chat_app/configs/translate/text.dart';
import 'package:chat_app/utils/image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  bool _isLogin = true;

  var enteredEmailAddress = "";
  var enteredPassword = "";

  void _submit() async {
    var isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    debugPrint(enteredEmailAddress);
    debugPrint(enteredPassword);

    try {
      if (_isLogin) {
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: enteredEmailAddress,
          password: enteredPassword,
        );
        print(userCredential);
      } else {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: enteredEmailAddress,
          password: enteredPassword,
        );
        print(userCredential);
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Authentication Failed."),
        ),
      );
      // if (e.code == 'weak-password') {
      //   debugPrint('The password provided is too weak.');
      // } else if (e.code == 'email-already-in-use') {
      //   debugPrint('The account already exists for that email.');
      // }
    }
    // catch (e) {
    //   ScaffoldMessenger.of(context).clearSnackBars();
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(e.toString() ?? "Authentication Failed."),
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  right: 20,
                  bottom: 20,
                  left: 20,
                ),
                width: 200,
                child: Image.asset(ConstantsImages().kChatImg),
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
                            decoration: InputDecoration(
                              labelText: ConstantsText().kEmailAddress,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return ConstantsText().kInvalidAddress;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              enteredEmailAddress = value!;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: ConstantsText().kPassword,
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return ConstantsText().kInvalidPassword;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              enteredPassword = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: Text(_isLogin
                                ? ConstantsText().kLogin
                                : ConstantsText().kSignup),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() => _isLogin = !_isLogin);
                            },
                            child: Text(
                              _isLogin
                                  ? ConstantsText().kCreateAccount
                                  : ConstantsText().kAlreadyAccount,
                            ),
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
