import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/url.dart';
import '../models/user.dart';
import '../screens/signIn.dart';
import '../interceptors/authInterceptor.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerNewPass = TextEditingController();
  TextEditingController controllerOldPass = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  GlobalKey<FormState> key1 = GlobalKey();
  SharedPreferences? sharedPreferences;
  Dio DIO = Dio();

  Future<void> initSharedPreferences() async =>
      sharedPreferences = await SharedPreferences.getInstance();

  void clearSharedPreferences() async => await sharedPreferences!.clear();

  String getTokenSharedPreferences() {
    return sharedPreferences!.getString('token')!;
  }

  Future<void> updateProfile() async {
    String updateStatus = "Успешное обновление";
    try {
      String userName = controllerUsername.text;
      String email = controllerEmail.text;

      await DIO.post(URL.user.value,
          data: User(userName: userName, email: email));
    } on DioError {
      updateStatus = "Данный логин уже занят";
    }
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(updateStatus, textAlign: TextAlign.center)));
  }

  Future<void> updatePassword() async {
    String updateStatus = "Успешное обновление пароля";
    try {
      String oldPass = controllerOldPass.text;
      String newPass = controllerNewPass.text;

      Response response = await DIO.put(URL.user.value,
          queryParameters: {'newPassword': newPass, 'oldPassword': oldPass});
      print(response);
    } on DioError {
      updateStatus = "Неверный пароль";
    }
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(updateStatus, textAlign: TextAlign.center)));
  }

  @override
  void initState() {
    super.initState();
    initSharedPreferences().then((value) async {
      String token = getTokenSharedPreferences();
      DIO.options.headers['Authorization'] = "Bearer $token";
      DIO.interceptors.add(AuthInterceptor());
      Response response = await DIO.get(URL.user.value);
      controllerEmail.text = response.data['data']['email'];
      controllerUsername.text = response.data['data']['userName'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 196, 227, 203),
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
                        style: const TextStyle(
                            color: Color.fromARGB(255, 104, 133, 110)),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 104, 133, 110))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 74, 97, 78))),
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 104, 133, 110)),
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
                        style: const TextStyle(
                            color: Color.fromARGB(255, 104, 133, 110)),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 104, 133, 110))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 74, 97, 78))),
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 104, 133, 110)),
                          labelText: "Email",
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

                    IconButton(
                     onPressed: () async {
                        updateProfile();
                      },
                      icon: const Icon(Icons.auto_awesome),
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(25, 5, 25, 5)),
                    IconButton(
                      onPressed: () {
                        clearSharedPreferences();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
                      },
                      icon: const Icon(Icons.exit_to_app),
                    ),

                     Container(
                      margin: const EdgeInsets.only(top: 100.0),
                    ),
                    SvgPicture.asset("assets/p5.svg",
                        width: 500, height: 500),
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     foregroundColor: Colors.white,
                    //     backgroundColor:
                    //         const Color.fromARGB(255, 196, 227, 203),
                    //   ),
                    //   onPressed: () {
                    //     clearSharedPreferences();
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => const SignInScreen()));
                    //   },
                    //   child: const Text("Выйти"),
                    // ),
                    // Form(
                    //   key: key1,
                    //   child: Column(
                    //     children: [
                    //       TextFormField(
                    //         controller: controllerOldPass,
                    //         validator: ((value) {
                    //           if (value == null || value.isEmpty) {
                    //             return "пароль не должен быть пустым";
                    //           }
                    //           if (value.length < 8 || value.length >= 16) {
                    //             return "пароль должен быть от 8 до 16 символов";
                    //           }
                    //           return null;
                    //         }),
                    //         style: const TextStyle(color: Colors.black),
                    //         decoration: const InputDecoration(
                    //           enabledBorder: OutlineInputBorder(
                    //               borderSide: BorderSide(color: Colors.grey)),
                    //           focusedBorder: OutlineInputBorder(
                    //               borderSide: BorderSide(color: Colors.black)),
                    //           labelStyle: TextStyle(color: Colors.black),
                    //           labelText: "Старый пароль",
                    //         ),
                    //       ),
                    //       const Padding(
                    //           padding: EdgeInsets.fromLTRB(25, 5, 25, 20)),
                    //       TextFormField(
                    //         controller: controllerNewPass,
                    //         validator: ((value) {
                    //           if (value == null || value.isEmpty) {
                    //             return "пароль не должен быть пустым";
                    //           }
                    //           if (value.length < 8 || value.length >= 16) {
                    //             return "пароль должен быть от 8 до 16 символов";
                    //           }
                    //           return null;
                    //         }),
                    //         style: const TextStyle(color: Colors.black),
                    //         decoration: const InputDecoration(
                    //           enabledBorder: OutlineInputBorder(
                    //               borderSide: BorderSide(color: Colors.grey)),
                    //           focusedBorder: OutlineInputBorder(
                    //               borderSide: BorderSide(color: Colors.black)),
                    //           labelStyle: TextStyle(color: Colors.black),
                    //           labelText: "Новый пароль",
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     foregroundColor: Colors.white,
                    //     backgroundColor: Colors.black,
                    //   ),
                    //   onPressed: () async {
                    //     updatePassword();
                    //   },
                    //   child: const Text("Изменить пароль"),
                    // ),
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
