import 'package:flutter/material.dart';

import '../pages/accounting_page.dart';
import '../pages/profile_page.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  final List<Widget> pages = [const HistoryPage(), const ProfilePage()];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Учеты'),
          BottomNavigationBarItem(icon: Icon(Icons.perm_contact_cal_rounded), label: 'Профиль')
        ],
        backgroundColor: const Color.fromARGB(255, 135, 133, 162),
        selectedItemColor: const Color.fromARGB(255, 75, 74, 90),
        unselectedItemColor: Colors.white,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() => currentIndex = value);
        },
      ),
    );
  }
}