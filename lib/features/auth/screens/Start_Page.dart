import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/features/auth/screens/Admin_login.dart';
import 'package:pets/features/auth/screens/User_Login.dart';
import 'package:pets/utils/colors.dart';

class StartPage extends ConsumerStatefulWidget {
  const StartPage({super.key});

  @override
  ConsumerState<StartPage> createState() => _StartPageState();
}

class _StartPageState extends ConsumerState<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / hei(context, 250),
              width: MediaQuery.of(context).size.width / wid(context, 250),
              child: SvgPicture.asset('assets/images/start_page.svg'),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / hei(context, 10),
                ),
                alignment: Alignment.center,
                child: const ResponsiveText(
                  text: "Find your forever pet",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: "SF",
                      fontSize: 23),
                )),
            Container(
                margin: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width / wid(context, 25),
                  left: MediaQuery.of(context).size.width / wid(context, 25),
                  top: MediaQuery.of(context).size.height / hei(context, 15),
                  bottom: MediaQuery.of(context).size.height / hei(context, 15),
                ),
                alignment: Alignment.center,
                child: const ResponsiveText(
                  textAlign: TextAlign.center,
                  text:
                      "Connecting pet lovers to their perfect companions, where every tail finds a home and every heart finds a friend.",
                  style: TextStyle(
                      color: Colors.black54, fontFamily: "SF", fontSize: 14),
                )),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminLogin(
                              role: "admin",
                            )));
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              child: Container(
                  margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width / wid(context, 25),
                    left: MediaQuery.of(context).size.width / wid(context, 25),
                    top: MediaQuery.of(context).size.height / hei(context, 15),
                  ),
                  height: MediaQuery.of(context).size.height / hei(context, 50),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: primaryBgcolor,
                      borderRadius: BorderRadius.circular(18)),
                  child: const ResponsiveText(
                    text: "Administrator Login",
                    style: TextStyle(
                        color: Colors.white, fontFamily: "SF", fontSize: 15),
                  )),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserLogin(
                              role: 'user',
                            )));
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              child: Container(
                  margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width / wid(context, 25),
                    left: MediaQuery.of(context).size.width / wid(context, 25),
                    top: MediaQuery.of(context).size.height / hei(context, 15),
                  ),
                  height: MediaQuery.of(context).size.height / hei(context, 50),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: primaryAccentShade2,
                      borderRadius: BorderRadius.circular(18)),
                  child: const ResponsiveText(
                    text: "User Login/SignUp",
                    style: TextStyle(
                        color: Colors.white, fontFamily: "SF", fontSize: 15),
                  )),
            ),
          ],
        ),
      )),
    );
  }
}
