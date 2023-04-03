import 'package:dio/dio.dart';
import 'package:flitter_api/screens/signIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/url.dart';
import '../models/user.dart';
import '../screens/signIn.dart';
import '../interceptors/authInterceptor.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  Dio DIO = Dio();

  Future<void> register() async {
    try {
      String userName = controllerUsername.text;
      String email = controllerEmail.text;
      String password = controllerPassword.text;

      DIO.interceptors.add(AuthInterceptor());
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SignInScreen()));
      await DIO.put(URL.token.value,
          data: User(userName: userName, email: email, password: password));
    } on DioError {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Данный логин уже занят', textAlign: TextAlign.center)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 152, 137, 185),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
              child: Center(
                child: Form(
                  key: key,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controllerUsername,
                        validator: ((value) {
                          if (value == null || value.isEmpty) {
                            return "Логин не должен быть пустым";
                          }
                          if (value.length < 8 || value.length >= 16) {
                            return "Логин должен быть от 8 до 16 символов";
                          }
                          return null;
                        }),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: "Логин",
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.fromLTRB(25, 5, 25, 20)),
                      TextFormField(
                        controller: controllerEmail,
                        validator: ((value) {
                          if (value == null || value.isEmpty) {
                            return "Email не должен быть пустым";
                          }
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return "Email введен неправильно";
                          }
                          return null;
                        }),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: "Email",
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.fromLTRB(25, 5, 25, 20)),
                      TextFormField(
                        controller: controllerPassword,
                        validator: ((value) {
                          if (value == null || value.isEmpty) {
                            return "Пароль не должен быть пустым";
                          }
                          if (value.length < 8 || value.length >= 16) {
                            return "Пароль должен быть от 8 до 16 символов";
                          }
                          return null;
                        }),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: "Пароль",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 5, 25, 10),
              child: Center(
                child: Column(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              const Color.fromARGB(255, 152, 137, 185),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          if (!key.currentState!.validate()) return;
                          register();
                        },
                        child: const Text("Зарегистрироваться")),
                    const Padding(padding: EdgeInsets.fromLTRB(25, 5, 25, 5)),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              const Color.fromARGB(255, 152, 137, 185),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()));
                        },
                        child: const Text("Назад")),
                    Container(
                      margin: const EdgeInsets.only(top: 43.0),
                    ),
                    SvgPicture.asset("assets/p2.svg", width: 500, height: 500),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
