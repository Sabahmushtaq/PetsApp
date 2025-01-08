import 'dart:async';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/core/providers.dart';
import 'package:pets/utils/colors.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  Timer? timer;
  @override
  void initState() {
    timerFunction();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void timerFunction() {
    timer = Timer.periodic(const Duration(seconds: 1), (timers) async {
      ///////
      await FirebaseAuth.instance.currentUser!.reload();
      final user = FirebaseAuth.instance.currentUser?.emailVerified;
      if (user == true) {
        timers.cancel();
        ref.read(verificationProvider.notifier).state =
            FirebaseAuth.instance.currentUser?.emailVerified;
      }
      ref.read(verificationProvider.notifier).state =
          FirebaseAuth.instance.currentUser?.emailVerified;
    });
  }

  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset("assets/images/Login.svg"),
            Container(
                margin: const EdgeInsets.all(10),
                child: const ResponsiveText(
                  text: "Verify your Email to continue using our App",
                  style: TextStyle(color: Colors.black, fontSize: 24),
                  textAlign: TextAlign.center,
                )),
            const SizedBox(
              height: 20,
            ),
            isClicked == false
                ? InkWell(
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      setState(() {
                        isClicked = true;
                      });
                      try {
                        await FirebaseAuth.instance.currentUser
                            ?.sendEmailVerification();

                        if (context.mounted) {
                          AnimatedSnackBar.material("email sent",
                                  type: AnimatedSnackBarType.success,
                                  animationDuration:
                                      const Duration(milliseconds: 500),
                                  mobilePositionSettings:
                                      const MobilePositionSettings(
                                          topOnAppearance: 100))
                              .show(context);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          AnimatedSnackBar.material(
                                  "Failed to sent Verification Email",
                                  type: AnimatedSnackBarType.warning,
                                  animationDuration:
                                      const Duration(milliseconds: 500),
                                  mobilePositionSettings:
                                      const MobilePositionSettings(
                                          topOnAppearance: 100))
                              .show(context);
                        }
                      }
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
                      child: const ResponsiveText(
                        text: "Send Email Verification Link",
                        style: TextStyle(
                            fontFamily: "SF",
                            color: Colors.white,
                            fontSize: 16.5),
                      ),
                    ),
                  )
                : InkWell(
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      await FirebaseAuth.instance.currentUser!.reload();
                      await FirebaseAuth.instance.currentUser!.reload();

                      ref.read(verificationProvider.notifier).state =
                          FirebaseAuth.instance.currentUser?.emailVerified;
                      // Navigator.pushAndRemoveUntil(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const NavigatorHome(),
                      //     ),
                      //     (route)=> false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: primaryAccent),
                      alignment: Alignment.center,
                      height:
                          MediaQuery.of(context).size.height / hei(context, 50),
                      width: MediaQuery.of(context).size.width,
                      margin:
                          const EdgeInsets.only(right: 20, left: 20, top: 7),
                      child: const ResponsiveText(
                        text: "I have Verified My Email",
                        style: TextStyle(
                            fontFamily: "SF",
                            color: Colors.white,
                            fontSize: 16.5),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
