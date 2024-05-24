import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/navbar_model.dart';
import '../common/settings_page.dart';
import '../widgets/custom_paint.dart';
import 'fourniseeur_orders.dart';
import 'fournisseur_stocks.dart';

class FournisseurHome extends StatefulWidget {
  const FournisseurHome({super.key});

  @override
  State<FournisseurHome> createState() => _FournisseurHomeState();
}

class _FournisseurHomeState extends State<FournisseurHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const FournisseurOrders(),
    const FournisseurStocks(),
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
          Radius.circular(_selectedIndex == fournisseurNavBar.length - 1 ? 0.0 : 20.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < fournisseurNavBar.length; i++)
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
              fournisseurNavBar[i].imagePath,
              color: isActive ? kBlue : kGrey,
              scale: 2,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              fournisseurNavBar[i].name,
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
