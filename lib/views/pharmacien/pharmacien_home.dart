import 'package:flutter/material.dart';
import 'package:pharmacy_management/views/pharmacien/pharmacien_orders.dart';
import 'package:pharmacy_management/views/pharmacien/pharmacien_stock.dart';

import '../../constants.dart';
import '../../controllers/user_controller.dart';
import '../../models/navbar_model.dart';
import '../../models/user_model.dart';

class PharmacienHome extends StatefulWidget {
  const PharmacienHome({super.key});

  @override
  State<PharmacienHome> createState() => _PharmacienHomeState();
}

class _PharmacienHomeState extends State<PharmacienHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const PharmacienStock(),
    const PharmacienOrders(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
  ];

  final UserController _userController = UserController();
  UserModel? _currentUser;
  @override

  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    UserModel? user = await _userController.getUserData();
    setState(() {
      _currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlue,
      appBar: AppBar(
        title: Text("Bienvenue"),
      ),
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: navigationBar(),
          ),
        ],
      ),
    );
  }

  Widget navigationBar() {
    return BottomNavigationBar(
      backgroundColor: kWhite,
      selectedItemColor: kBlue,
      unselectedItemColor: kGrey,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: navBtn
          .map(
            (btn) => BottomNavigationBarItem(
          icon: Image.asset(
            btn.imagePath,
            scale: 2,
          ),
          label: btn.name,
        ),
      )
          .toList(),
    );
  }
}
