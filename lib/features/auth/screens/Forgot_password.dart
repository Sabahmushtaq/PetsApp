import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pets/core/LoadingScreen.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/utils/colors.dart';

import '../../../core/custom_textfield.dart';
import '../../../core/dimensions.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  static final GlobalKey<FormState> form =
      GlobalKey<FormState>(debugLabel: "key2");
  final email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: form,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height:
                        MediaQuery.of(context).size.height / hei(context, 200),
                    width: MediaQuery.of(context).size.width,
                    child: SvgPicture.asset('assets/images/forgot.svg'),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height /
                          hei(context, 10)),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ResponsiveText(
                        text: "Forgot ",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Future",
                            fontSize: 30,
                            fontWeight: FontWeight.w500),
                      ),
                      ResponsiveText(
                        text: "Password",
                        style: TextStyle(
                            color: primaryAccent,
                            fontFamily: "Future",
                            fontSize: 30,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 7),
                    alignment: Alignment.center,
                    child: const ResponsiveText(
                      text: "Enter the Registered Email",
                      style: TextStyle(color: Colors.black54, fontFamily: "SF"),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                      hintText: "Email",
                      icon: Icons.email,
                      color: secondaryBgcolor,
                      onChanged: (value) {},
                      con: email),
                  InkWell(
                    onTap: () async {
                      if (form.currentState!.validate()) {
                        ref
                            .read(authControllerProvider.notifier)
                            .forgotEmail(email.text, context);
                      }
                    },
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width /
                            wid(context, 25),
                        left: MediaQuery.of(context).size.width /
                            wid(context, 25),
                        top: MediaQuery.of(context).size.height /
                            hei(context, 15),
                      ),
                      height:
                          MediaQuery.of(context).size.height / hei(context, 50),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: primaryBgcolor,
                          borderRadius: BorderRadius.circular(18)),
                      child: ref.watch(authControllerProvider)
                          ? const LoadingScreen()
                          : const ResponsiveText(
                              text: "Reset Password",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "SF",
                                  fontSize: 15),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
