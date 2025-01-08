import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/LoadingScreen.dart';
import 'package:pets/core/dimensions.dart';

import '../../../core/Responsive_text.dart';
import '../../../utils/colors.dart';
import '../../auth/controller/auth_repo_controller.dart';

class AllOrders extends ConsumerStatefulWidget {
  const AllOrders({super.key});

  @override
  ConsumerState<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends ConsumerState<AllOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryLightColor,
        centerTitle: true,
        title: const ResponsiveText(
          text: "My Pending Requests",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding:
                EdgeInsets.only(top: 18.0, bottom: 15, right: 20, left: 20),
            child: Center(
              child: Text(
                  style: TextStyle(color: Colors.green),
                  "Requests that are below are under review others are rejected."),
            ),
          ),
          Expanded(
            child: ref.watch(getAllOrdersFutureProvider).when(
              data: (data) {
                if (MediaQuery.of(context).size.width > 600) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.0, // Adjust as needed
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final pet = data[index];
                      return pet.requesterUID ==
                              ref
                                  .watch(authControllerProvider.notifier)
                                  .userData
                                  ?.uid
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: heights(context, 200),
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: secondaryLightColor4,
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(pet.images.first),
                                  ),
                                ),
                              ),
                            )
                          : Container();
                    },
                  );
                } else {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final pet = data[index];
                      return pet.requesterUID ==
                              ref
                                  .watch(authControllerProvider.notifier)
                                  .userData
                                  ?.uid
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: heights(context, 200),
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: secondaryLightColor4,
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(pet.images.first),
                                  ),
                                ),
                              ),
                            )
                          : Container();
                    },
                  );
                }
              },
              error: (Object error, StackTrace stackTrace) {
                return Container();
              },
              loading: () {
                return const LoadingScreen();
              },
            ),
          ),
        ],
      ),
    );
  }
}
