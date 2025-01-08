import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/providers.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/features/auth/screens/Forgot_Password.dart';
import 'package:pets/features/auth/screens/Register_page.dart';

import '../../../core/LoadingScreen.dart';
import '../../../core/custom_textfield.dart';
import '../../../core/dimensions.dart';
import '../../../utils/colors.dart';

class UserLogin extends ConsumerStatefulWidget {
  final String role;
  const UserLogin({super.key, required this.role});

  @override
  ConsumerState<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends ConsumerState<UserLogin> {
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height:
                        MediaQuery.of(context).size.height / hei(context, 200),
                    width: MediaQuery.of(context).size.width,
                    child: SvgPicture.asset('assets/images/Login.svg'),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height /
                          hei(context, 10)),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ResponsiveText(
                        text: "Sign ",
                        style: TextStyle(
                            fontFamily: "Future",
                            fontSize: 30,
                            color: Colors.black),
                      ),
                      ResponsiveText(
                        text: "In",
                        style: TextStyle(
                            fontFamily: "Future",
                            fontSize: 30,
                            color: primaryAccent),
                      ),
                    ],
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height /
                          hei(context, 20)),
                  CustomTextField(
                      hintText: "Email",
                      icon: Icons.mail,
                      color: secondaryBgcolor,
                      onChanged: (value) {},
                      con: email),
                  CustomTextField(
                      obscureText: true,
                      hintText: "Password",
                      color: secondaryBgcolor,
                      icon: Icons.password,
                      onChanged: (value) {},
                      con: password),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(right: 25, bottom: 5),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword()));
                      },
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: const ResponsiveText(
                        textAlign: TextAlign.center,
                        text: "Forgot password ?",
                        style: TextStyle(
                            fontFamily: "SF",
                            fontSize: 14,
                            color: primaryAccent),
                      ),
                    ),
                  ),
                  InkWell(
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      await FirebaseAuth.instance.currentUser?.reload();
                      ref.read(verificationProvider.notifier).state =
                          ref.watch(authProvider).currentUser?.emailVerified;

                      ref.read(authControllerProvider.notifier).loginEmail(
                          email: email.text.replaceAll(" ", ''),
                          password: password.text,
                          context: context,
                          role: widget.role);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: primaryBgcolor),
                      alignment: Alignment.center,
                      height:
                          MediaQuery.of(context).size.height / hei(context, 50),
                      width: MediaQuery.of(context).size.width,
                      margin:
                          const EdgeInsets.only(right: 20, left: 20, top: 7),
                      child: ref.watch(authControllerProvider)
                          ? const LoadingScreen()
                          : const ResponsiveText(
                              text: "Login",
                              style: TextStyle(
                                  fontFamily: "SF",
                                  color: Colors.white,
                                  fontSize: 16.5),
                            ),
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height /
                          hei(context, 10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ResponsiveText(
                        textAlign: TextAlign.center,
                        text: "Don't have an Account ?",
                        style: TextStyle(
                            fontFamily: "SF",
                            fontSize: 15,
                            color: Colors.black),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserRegister(
                                        role: widget.role,
                                      )));
                        },
                        child: const ResponsiveText(
                          textAlign: TextAlign.center,
                          text: " Register",
                          style: TextStyle(
                              fontFamily: "SF",
                              fontSize: 15,
                              color: primaryAccent),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
