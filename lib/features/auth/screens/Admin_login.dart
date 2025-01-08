import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/features/auth/screens/Forgot_password.dart';

import '../../../core/LoadingScreen.dart';
import '../../../core/custom_textfield.dart';
import '../../../core/dimensions.dart';
import '../../../utils/colors.dart';

class AdminLogin extends ConsumerStatefulWidget {
  final String role;
  const AdminLogin({super.key, required this.role});

  @override
  ConsumerState<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends ConsumerState<AdminLogin> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height / hei(context, 200),
                width: MediaQuery.of(context).size.width,
                child: SvgPicture.asset('assets/images/Admin_Login.svg'),
              ),
              SizedBox(
                  height:
                      MediaQuery.of(context).size.height / hei(context, 10)),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResponsiveText(
                    text: "Admin ",
                    style: TextStyle(
                        fontFamily: "Future",
                        fontSize: 30,
                        color: Colors.black),
                  ),
                  ResponsiveText(
                    text: "Login",
                    style: TextStyle(
                        fontFamily: "Future",
                        fontSize: 30,
                        color: primaryAccent),
                  ),
                ],
              ),
              SizedBox(
                  height:
                      MediaQuery.of(context).size.height / hei(context, 20)),
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
                        fontFamily: "SF", fontSize: 14, color: primaryAccent),
                  ),
                ),
              ),
              InkWell(
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  ref.read(authControllerProvider.notifier).loginEmail(
                      email: email.text,
                      password: password.text,
                      context: context,
                      role: widget.role);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primaryBgcolor),
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / hei(context, 50),
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(right: 20, left: 20, top: 7),
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
                  height:
                      MediaQuery.of(context).size.height / hei(context, 10)),
            ],
          ),
        ),
      ),
    );
  }
}
