import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/url.dart';
import '../models/accounting.dart';
import '../cubit/accounting_cubit.dart';
import '../interceptors/authInterceptor.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  TextEditingController controllerNumOperation = TextEditingController();
  TextEditingController controllernameOperation = TextEditingController();
  TextEditingController controllerCategory = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerAmount = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  SharedPreferences? sharedPreferences;
  Dio DIO = Dio();
  List<Accounting> accountings = [];
  int deleted = 0;

  Future<void> initSharedPreferences() async =>
      sharedPreferences = await SharedPreferences.getInstance();

  void clearSharedPreferences() async => await sharedPreferences!.clear();

  String getTokenSharedPreferences() {
    return sharedPreferences!.getString('token')!;
  }

  Future<void> getAccounting(int deleted, String search) async {
    try {
      Response response = await DIO.get(URL.accounting.value,
          queryParameters: {'deleted': deleted, 'search': search});
      // print(response.data['message']);
      if (response.data['message'] != null &&
          response.data['message'] == 'Учеты не найдены') {
        context.read<AccountingCubit>().clearAccounting();
        return;
      }

      accountings = (response.data['data'] as List)
          .map((x) => Accounting.fromJson(x))
          .toList();
      //
      // accountings = parsedListJson.map<Accounting>((dynamic i) => Accounting.fromJson(i)).toList();

      context.read<AccountingCubit>().setAccounting(accountings);
    } on DioError {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка', textAlign: TextAlign.center)));
    }
  }

  Future<void> createAccounting() async {
    try {
      int? number = int.tryParse(controllerNumOperation.text);
      String name = controllernameOperation.text;
      String category = controllerCategory.text;
      String description = controllerDescription.text;
      int? amount = int.tryParse(controllerAmount.text);

      await DIO.post(URL.accounting.value,
          data: Accounting(
              numberOperation: number,
              nameOperation: name,
              description: description,
              category: category,
              transactionAmount: amount));
    } on DioError {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка', textAlign: TextAlign.center)));
    }
  }

  Future<void> updateAccounting(int number) async {
    try {
      int? number = int.tryParse(controllerNumOperation.text);
      String name = controllernameOperation.text;
      String category = controllerCategory.text;
      String description = controllerDescription.text;
      int? amount = int.tryParse(controllerAmount.text);

      await DIO.put('${URL.accounting.value}/$number',
          data: Accounting(
              numberOperation: number,
              nameOperation: name,
              description: description,
              category: category,
              transactionAmount: amount));
    } on DioError {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка', textAlign: TextAlign.center)));
    }
  }

  Future<void> deleteAccounting(int number) async {
    try {
      await DIO.delete('${URL.accounting.value}/$number');
    } on DioError {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка', textAlign: TextAlign.center)));
    }
  }

  @override
  void initState() {
    super.initState();
    initSharedPreferences().then((value) async {
      String token = getTokenSharedPreferences();
      print(token);
      DIO.options.headers['Authorization'] = "Bearer $token";
      DIO.interceptors.add(AuthInterceptor());
      getAccounting(deleted, '');
    });
  }

  void showAccountingDialog(Accounting? accounting) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 255, 204, 204),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: SizedBox(
            width: 700,
            height: 854,
            child: Column(
              children: [
                Center(
                  child: Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Form(
                    key: key,
                    child: Column(
                      children: [
                        
                        TextFormField(
                          controller: controllernameOperation,
                          validator: ((value) {
                            if (value == null || value.isEmpty) {
                              return "Наименование не должно быть пустым";
                            }
                            return null;
                          }),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 135, 133, 162),
                          ),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color.fromARGB(255, 135, 133, 162),
                            )),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color.fromARGB(255, 85, 83, 102),
                            )),
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 135, 133, 162),
                            ),
                            labelText: "Наименование",
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.fromLTRB(25, 5, 25, 5)),
                        TextFormField(
                          controller: controllerDescription,
                          validator: ((value) {
                            if (value == null || value.isEmpty) {
                              return "Описание не должно быть пустым";
                            }
                            return null;
                          }),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 135, 133, 162),
                          ),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color.fromARGB(255, 135, 133, 162),
                            )),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color.fromARGB(255, 85, 83, 102),
                            )),
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 135, 133, 162),
                            ),
                            labelText: "Описание",
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.fromLTRB(25, 5, 25, 5)),
                        TextFormField(
                          controller: controllerCategory,
                          validator: ((value) {
                            if (value == null || value.isEmpty) {
                              return "Категория не должна быть пустой";
                            }
                            return null;
                          }),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 135, 133, 162),
                          ),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color.fromARGB(255, 135, 133, 162),
                            )),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color.fromARGB(255, 85, 83, 102),
                            )),
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 135, 133, 162),
                            ),
                            labelText: "Категория",
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.fromLTRB(25, 5, 25, 5)),
                        TextFormField(
                          controller: controllerAmount,
                          validator: ((value) {
                            if (value == null || value.isEmpty) {
                              return "Сумма не должна быть пустой";
                            }
                            return null;
                          }),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 135, 133, 162),
                          ),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color.fromARGB(255, 135, 133, 162),
                            )),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color.fromARGB(255, 85, 83, 102),
                            )),
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 135, 133, 162),
                            ),
                            labelText: "Сумма",
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                  
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(255, 135, 133, 162),
                          ),
                          onPressed: () async {
                            if (!key.currentState!.validate()) return;
                            if (accounting == null) {
                              await createAccounting();
                            } else {
                              await updateAccounting(
                                  accounting.numberOperation!);
                            }
                            getAccounting(deleted, '');
                            controllerNumOperation.text = '';
                            controllernameOperation.text = '';
                            controllerCategory.text = '';
                            Navigator.of(context).pop();
                          },
                          child: const Text("Сохранить"),
                        ),
                        const Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(255, 135, 133, 162),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Отмена"),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                        ),
                        SvgPicture.asset("assets/p4.svg",
                            width: 500, height: 500),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 135, 133, 162),
        foregroundColor: const Color.fromARGB(255, 249, 249, 249),
        title: SizedBox(
          width: double.infinity,
          height: 40,
          child: Center(
            child: TextField(
              onSubmitted: (value) => getAccounting(deleted, value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                suffixIcon: PopupMenuButton(
                  tooltip: "Сортировка",
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text("Не удаленный"),
                      onTap: () {
                        deleted = 1;
                        getAccounting(deleted, '');
                      },
                    ),
                    PopupMenuItem(
                      child: const Text("Удаленный"),
                      onTap: () {
                        deleted = 0;
                        getAccounting(deleted, '');
                      },
                    ),
                  ],
                  icon: const Icon(Icons.filter_alt, color: Colors.white),
                ),
                hintText: 'Поиск',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 204, 204),
      body: Center(
        child: BlocBuilder<AccountingCubit, AccountingState>(
          builder: (context, state) {
            if (state is UpdateAccounting) {
              return ListView.builder(
                itemCount: state.accounting.length,
                itemBuilder: (context, index) => Card(
                  color: const Color.fromARGB(255, 135, 133, 162),
                  child: ListTile(
                    textColor: Colors.white,
                    // leading: CircleAvatar(
                    //   backgroundColor:Color.fromARGB(255, 255, 255, 255),
                    //   child: Text(
                    //       (state.accounting.elementAt(index).numberOperation)
                    //           .toString()),
                    // ),
                    leading: const Icon(Icons.account_balance),
                    title: Text(
                        (state.accounting.elementAt(index).nameOperation)
                            .toString()),
                    subtitle: Text(
                        (state.accounting.elementAt(index).dateOfOperation)
                            .toString()),

                    trailing: PopupMenuButton(
                      tooltip: "Действия",
                      itemBuilder: (context) => [
                        if (state.accounting.elementAt(index).deleted != true)
                          PopupMenuItem(
                            child: const Text("Изменить"),
                            onTap: () {
                              Accounting accounting =
                                  state.accounting.elementAt(index);
                              controllerNumOperation.text =
                                  (accounting.numberOperation).toString();
                              controllernameOperation.text =
                                  (accounting.nameOperation).toString();
                              controllerCategory.text =
                                  (accounting.category).toString();
                              controllerDescription.text =
                                  (accounting.description).toString();
                              controllerAmount.text =
                                  (accounting.transactionAmount).toString();
                              Future.delayed(const Duration(seconds: 0),
                                  () => showAccountingDialog(accounting));
                            },
                          ),
                        PopupMenuItem(
                          child: const Text("Удалить"),
                          onTap: () async {
                            deleteAccounting(state.accounting
                                .elementAt(index)
                                .numberOperation!);
                            context
                                .read<AccountingCubit>()
                                .deleteAccounting(index);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const CircularProgressIndicator(
                color: const Color.fromARGB(255, 247, 107, 156));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAccountingDialog(null),
        backgroundColor: const Color.fromARGB(255, 135, 133, 162),
        child: const Icon(Icons.auto_awesome),
      ),
    );
  }
}
