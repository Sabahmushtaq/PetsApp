import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/providers.dart';
import 'package:pets/features/Favourites/screens/favouries.dart';
import 'package:pets/features/Home/screens/ProfilePage.dart';
import 'package:pets/features/Home/screens/aboutus.dart';
import 'package:pets/features/Home/screens/recommendations.dart';
import 'package:pets/features/Orders/screens/AllOrders.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/utils/colors.dart';

class Drawerscreen extends ConsumerStatefulWidget {
  const Drawerscreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DrawerscreenState();
}

class _DrawerscreenState extends ConsumerState<Drawerscreen> {
  String name = "";
  String uid = "";
  String email = "";

  @override
  void initState() {
    final user = ref.read(authControllerProvider.notifier).userData;
    name = user?.name ?? "";
    email = user?.email ?? "";
    uid = user?.uid ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider.notifier).userData;
    return Scaffold(
      backgroundColor: secondaryLightColor4,
      appBar: AppBar(
        backgroundColor: secondaryLightColor4,
      ),
      body: SingleChildScrollView(
        child: Container(
          //  height: MediaQuery.of(context).size.height,
          //width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 10, left: 10),
          color: secondaryLightColor4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 100,
                      child: Image.asset("assets/images/animal.png"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            constraints: const BoxConstraints(
                              maxWidth: 200, // Set a maximum width constraint
                            ),
                            child: Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontFamily: "SF",
                                color: secondaryLightColor3,
                                fontSize: 28.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            email,
                            style: const TextStyle(
                              fontFamily: "SF",
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllOrders(),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          color: secondaryLightColor3,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            "My Buy Pending Requests ",
                            style: TextStyle(
                              fontFamily: "SF",
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavouritesScreen(),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: secondaryLightColor3,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            "Favourites",
                            style: TextStyle(
                              fontFamily: "SF",
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  InkWell(
                    onTap: () {
                      if (ref.watch(queryValue) != '') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Suggestions(),
                          ),
                        );
                      } else {
                        AnimatedSnackBar.material(
                                "No Suggestions Yet, Please search",
                                type: AnimatedSnackBarType.warning,
                                animationDuration:
                                    const Duration(milliseconds: 500),
                                mobilePositionSettings:
                                    const MobilePositionSettings(
                                        topOnAppearance: 100))
                            .show(context);
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.recommend,
                          color: secondaryLightColor3,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            "Recommendations",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: "SF",
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Aboutus(),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.people,
                          color: secondaryLightColor3,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            "About Us",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: "SF",
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 11,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 10.0, bottom: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.settings,
                        color: secondaryLightColor3,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Settings",
                        style: TextStyle(
                          fontFamily: "SF",
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
