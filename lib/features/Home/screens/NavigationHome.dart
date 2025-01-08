import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/core/providers.dart';
import 'package:pets/features/Home/screens/BuyRequestPage.dart';
import 'package:pets/features/Home/screens/HomePage.dart';
import 'package:pets/features/Home/screens/ProfilePage.dart';
import 'package:pets/features/Sell/screens/sellPage.dart';
import 'package:pets/features/emailVerification/screens/Verification_Screen.dart';
import 'package:pets/utils/colors.dart';

class NavigatorHome extends ConsumerStatefulWidget {
  const NavigatorHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavigatorHomeState();
}

class _NavigatorHomeState extends ConsumerState<NavigatorHome> {
  List<Widget> ui = const [
    HomePage(),
    SellPage(),
    BuyRequest(),
    //FavouritesScreen(),
    // AllOrders(),
    ProfilePage()
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ref.watch(verificationProvider) ?? false
        ? Scaffold(
            body: ui[currentIndex],
            bottomNavigationBar: Container(
              color: secondaryLightColor4,
              height: MediaQuery.of(context).size.height / hei(context, 100),
              child: DotNavigationBar(
                  backgroundColor: primaryBgcolor,
                  currentIndex: currentIndex,
                  margin: const EdgeInsets.all(20),
                  marginR: const EdgeInsets.only(
                      top: 5, bottom: 10, left: 2, right: 2),
                  selectedItemColor: secondaryLightColor3,
                  unselectedItemColor: primaryBgcolor,
                  onTap: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  items: [
                    DotNavigationBarItem(
                        unselectedColor: Colors.white,
                        icon: const Icon(Icons.home)),
                    DotNavigationBarItem(
                        unselectedColor: Colors.white,
                        icon: const Icon(Icons.add)),
                    DotNavigationBarItem(
                        unselectedColor: Colors.white,
                        icon: const Icon(Icons.person)),
                    //  DotNavigationBarItem(icon: const Icon(Icons.favorite)),
                    // DotNavigationBarItem(
                    //   icon: const Icon(Icons.star_border_sharp)),
                    DotNavigationBarItem(
                        unselectedColor: Colors.white,
                        icon: const Icon(Icons.account_circle_rounded))
                  ]),
            ))
        : const VerificationScreen();
  }
}
