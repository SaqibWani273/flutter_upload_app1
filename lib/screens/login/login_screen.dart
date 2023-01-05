import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/data.dart';
import 'my_text_field.dart';

class LoginScreen extends StatefulWidget {
  final UploadData loginData;
  //final void Function(FirebaseAuthException e) errorCallback;
  const LoginScreen(this.loginData, {Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  MyTextField customTextFormField = MyTextField();
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext contxt) {
    final mediaQueryHeight = MediaQuery.of(context).size.height * 0.9;
    // 90% of device height
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginScreen Page'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('Login Screen'),
            ),
            GestureDetector(
              onTap: widget.loginData.signOut,
              child: ListTile(
                leading: Icon(Icons.logout_outlined),
                title: Text("Logout"),
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: mediaQueryHeight,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MyTextField().getCustomEditTextArea(
                      //MyTextField()=customTextFormField
                      labelValue: 'Email',
                      hintValue: 'Enter Registered Email',
                      controller: email,
                      validationErrorMsg: 'Email not Valid',
                      validation: true,
                    ),
                    const SizedBox(height: 20),
                    customTextFormField.getCustomEditTextArea(
                      labelValue: 'Password',
                      hintValue: 'Enter your Password',
                      controller: password,
                      validationErrorMsg: 'Password not valid',
                      validation: true,
                    ),
                    const SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                            onPressed: widget.loginData.forgotPassword,
                            child: const Text('forgot password?'),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              widget.loginData.signIn(
                                email.text.trim(),
                                password.text.trim(),
                              );
                            },

                            // () {
                            //   // if (formKey.currentState!.validate()) {
                            //   //   widget.appState.signIn(
                            //   //     context,
                            //   //     email.text.trim(),
                            //   //     password.text.trim(),
                            //   //     widget.errorCallback,
                            //   //   );
                            //   // }

                            // },
                            icon: const Icon(Icons.done_outline_rounded),
                            label: const Text('Sign In'),
                          ),
                        ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
