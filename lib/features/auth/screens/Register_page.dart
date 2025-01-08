import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pets/core/LoadingScreen.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';

import '../../../core/custom_textfield.dart';
import '../../../core/dimensions.dart';
import '../../../utils/colors.dart';

class UserRegister extends ConsumerStatefulWidget {
  final String role;
  const UserRegister({super.key, required this.role});

  @override
  ConsumerState<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends ConsumerState<UserRegister> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final cPassword = TextEditingController();
  String cPass = "";
  final GlobalKey<FormState> register =
      GlobalKey<FormState>(debugLabel: "registerkey");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: register,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(55, 105, 55, 15),
              ),
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height / hei(context, 200),
                width: MediaQuery.of(context).size.width,
                child: SvgPicture.asset('assets/images/Register.svg'),
              ),
              SizedBox(
                  height:
                      MediaQuery.of(context).size.height / hei(context, 10)),
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
                    text: "Up",
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
                  hintText: "Name",
                  icon: Icons.person,
                  color: secondaryBgcolor,
                  onChanged: (value) {},
                  con: name),
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
                  onChanged: (value) {
                    setState(() {
                      cPass = value;
                    });
                  },
                  con: password),
              CustomTextField(
                  obscureText: true,
                  conf: cPass,
                  color: secondaryBgcolor,
                  hintText: "Confirm Password",
                  icon: Icons.password_rounded,
                  onChanged: (value) {},
                  con: cPassword),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  if (register.currentState!.validate()) {
                    ref.read(authControllerProvider.notifier).register(
                        email: email.text,
                        password: password.text,
                        name: name.text,
                        role: widget.role,
                        context: context);
                  }
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
                          text: "Register",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ResponsiveText(
                    textAlign: TextAlign.center,
                    text: "Already have an Account ?",
                    style: TextStyle(
                        fontFamily: "SF", fontSize: 15, color: Colors.black),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const ResponsiveText(
                      textAlign: TextAlign.center,
                      text: " Login",
                      style: TextStyle(
                          fontFamily: "SF", fontSize: 15, color: primaryAccent),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
