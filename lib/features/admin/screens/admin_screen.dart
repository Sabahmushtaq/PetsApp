import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/features/Home/screens/BuyRequestPage.dart';
import 'package:pets/features/admin/screens/All_Posts.dart';
import 'package:pets/features/admin/screens/categories.dart';
import 'package:pets/features/admin/screens/posted.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/utils/colors.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            ref.read(authControllerProvider.notifier).signOut(context);
          },
        ),
        centerTitle: true,
        title: const ResponsiveText(
          text: "Admin",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AllPosts()));
              },
              child: Container(
                alignment: Alignment.center,
                height: heights(context, 200),
                width: widths(context, 200),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: secondaryLightColor),
                child: const ResponsiveText(
                  text: "All Requests",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CategoriesValues()));
              },
              child: Container(
                alignment: Alignment.center,
                height: heights(context, 200),
                width: widths(context, 200),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: secondaryLightColor),
                child: const ResponsiveText(
                  text: "Categories",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BuyRequest()));
              },
              child: Container(
                alignment: Alignment.center,
                height: heights(context, 200),
                width: widths(context, 200),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: secondaryLightColor),
                child: const ResponsiveText(
                  text: "All Orders",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PostedPage()));
              },
              child: Container(
                alignment: Alignment.center,
                height: heights(context, 200),
                width: widths(context, 200),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: secondaryLightColor),
                child: const ResponsiveText(
                  text: "Posted Animals",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
