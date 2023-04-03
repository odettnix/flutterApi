import 'package:flutter/material.dart';
import 'dart:io';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/accounting_cubit.dart';
import 'pages/accounting_page.dart';
import '../screens/signIn.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => AccountingCubit(), child: const HistoryPage())],
      child: const MaterialApp(home: SignInScreen(), debugShowCheckedModeBanner: false),
    );
  }
}

