import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/features/Home/screens/userInfoPage.dart';
import 'package:pets/features/Sell/controller/Sell_Page_Controller.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/utils/colors.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryLightColor4,
      appBar: AppBar(
        backgroundColor: secondaryLightColor,
        centerTitle: true,
        title: const ResponsiveText(
          text: "Settings",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: secondaryLightColor4,
          child: Column(
            children: [
              SizedBox(
                height: heights(context, 10),
              ),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  height: heights(context, 150),
                  width: widths(context, 150),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white),
                  child: Image.asset("assets/images/animal.png"),
                ),
              ),
              SizedBox(
                height: heights(context, 20),
              ),
              InkWell(
                radius: 0,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserInfoPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: primaryBgcolor),
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / hei(context, 50),
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(right: 60, left: 60, top: 7),
                  child: const ResponsiveText(
                    text: "User Info",
                    style: TextStyle(
                        fontFamily: "SF", color: Colors.white, fontSize: 16.5),
                  ),
                ),
              ),
              SizedBox(
                height: heights(context, 15),
              ),
              InkWell(
                radius: 0,
                onTap: () {
                  ref.read(authControllerProvider.notifier).forgotEmailProfile(
                      ref
                              .read(authControllerProvider.notifier)
                              .userData
                              ?.email ??
                          "",
                      context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: primaryBgcolor),
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / hei(context, 50),
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(right: 60, left: 60, top: 7),
                  child: const ResponsiveText(
                    text: "Forgot Password",
                    style: TextStyle(
                        fontFamily: "SF", color: Colors.white, fontSize: 16.5),
                  ),
                ),
              ),
              SizedBox(
                height: heights(context, 15),
              ),
              InkWell(
                radius: 0,
                onTap: () {
                  ref.invalidate(authControllerProvider);
                  ref.invalidate(imagePickerControllerProvider);
                  ref.read(authControllerProvider.notifier).signOut(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: primaryAccent),
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / hei(context, 50),
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(right: 60, left: 60, top: 7),
                  child: const ResponsiveText(
                    text: "Sign Out",
                    style: TextStyle(
                        fontFamily: "SF", color: Colors.white, fontSize: 16.5),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
