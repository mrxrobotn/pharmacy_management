import 'package:flutter/material.dart';
import 'package:pharmacy_management/views/pharmacien/pharmacien_help.dart';
import 'package:pharmacy_management/views/pharmacien/pharmacien_orders.dart';
import 'package:pharmacy_management/views/common/settings_page.dart';
import 'package:pharmacy_management/views/pharmacien/pharmacien_stock.dart';
import '../../constants.dart';
import '../../models/navbar_model.dart';
import 'chat_pharmacien_list.dart';
import '../widgets/custom_paint.dart';

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
    const PharmacienChatList(),
    const PharmacienHelp(),
    const SettingsPage(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlue,
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

  AnimatedContainer navigationBar() {
    return AnimatedContainer(
      height: 70.0,
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_selectedIndex == 0 ? 0.0 : 20.0),
          topRight:
          Radius.circular(_selectedIndex == pharmacienNavBar.length - 1 ? 0.0 : 20.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < pharmacienNavBar.length; i++)
            GestureDetector(
              onTap: () => setState(() => _selectedIndex = i),
              child: iconBtn(i),
            ),
        ],
      ),
    );
  }

  SizedBox iconBtn(int i) {
    bool isActive = _selectedIndex == i ? true : false;
    var height = isActive ? 60.0 : 0.0;
    var width = isActive ? 50.0 : 0.0;
    return SizedBox(
      width: 75.0,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedContainer(
              height: height,
              width: width,
              duration: const Duration(milliseconds: 600),
              child: isActive
                  ? CustomPaint(
                painter: ButtonNotch(),
              )
                  : const SizedBox(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              pharmacienNavBar[i].imagePath,
              color: isActive ? kBlue : kGrey,
              scale: 2,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              pharmacienNavBar[i].name,
              style: isActive ? const TextStyle(
                color: kGrey,
                fontWeight: FontWeight.w500,
              ).copyWith(color: kBlue) : const TextStyle(
                color: kGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}
