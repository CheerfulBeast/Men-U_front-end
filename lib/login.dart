// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:men_u/BaseApi.dart';
import 'package:men_u/table.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  bool status = false;
  String message = '';
  String token = '';
  String? emailError;
  String? passwordError;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  var loginActions = LoginActions();
  bool errorStatus = false;

  Future<void> login(String email, password) async {
    var response = await loginActions.loginUser(email, password);
    if (response.statusCode == 200) {
      setState(() {
        widget.token = loginActions.token;
        widget.emailError = null;
        widget.passwordError = null;
      });

      //Store Token and logged in state
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('token', widget.token);

      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return TablePick();
      }));

      print('==========Status=========\nLogged in Successfully\nToken: ${widget.token}');
      print('=======Preferences=======\nisLoggedIn: ${prefs.getBool('isLoggedIn')}\nToken: ${prefs.getString('token')}');
    } else {
      setState(() {
        widget.emailError = loginActions.emailError;
        widget.passwordError = loginActions.passwordError;
      });

      print(
          'Status Code = ${response.statusCode}\nlogin failed = ${response.body}}\n==========Errors==========\nEmail: ${loginActions.emailError}\nPassword: ${loginActions.passwordError}');
    }
    setState(() {
      widget.status = loginActions.status;
      widget.message = loginActions.message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  showCursor: true,
                  controller: userController,
                  decoration: InputDecoration(
                    hintText: "Enter",
                    labelText: "Username",
                    errorText: loginActions.hasEmailError() ? widget.emailError : null,
                    suffixIcon: Icon(
                      Icons.verified_user_rounded,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  showCursor: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Password",
                    labelText: "Password",
                    errorText: loginActions.hasPasswordError() ? widget.passwordError : null,
                    suffixIcon: Icon(
                      Icons.password_rounded,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () async {
                    //TODO:: Login Controller
                    login(userController.text, passwordController.text);
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
