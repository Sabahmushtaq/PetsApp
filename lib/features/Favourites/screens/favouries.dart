import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/LoadingScreen.dart';
import 'package:pets/features/Favourites/FavouriteModels/FavouriteModel.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/models/UploadDataModel.dart';

import '../../../core/Responsive_text.dart';
import '../../../core/dimensions.dart';
import '../../../utils/colors.dart';
import '../../Home/screens/pet_details.dart';

class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  ConsumerState<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(authControllerProvider.notifier).getFavourites();
    return Scaffold(
      backgroundColor: secondaryLightColor4,
      appBar: AppBar(
        backgroundColor: secondaryLightColor,
        centerTitle: true,
        title: const ResponsiveText(
          text: 'Favourites',
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
      body: ref.watch(getAllFavouritesFutureProvider).when(
          data: (data) {
            return ref.watch(getAllRequestsFutureProvider).when(
                data: (info) {
                  final userUid =
                      ref.watch(authControllerProvider.notifier).userData?.uid;
                  List<UploadDataModel> matchedItems = [];

                  for (UploadDataModel i in info ?? []) {
                    for (Fmodel fav in data) {
                      // Split the value into petId and userUid parts
                      List<String> valueParts = fav.value.split(' ');

                      if (valueParts.length == 2) {
                        String petId = valueParts[0];
                        String favUserUid = valueParts[1];

                        // Check if the current user's UID matches and the pet ID matches
                        if (favUserUid == userUid && petId == i.id) {
                          matchedItems.add(i); // Collect the matched items
                        }
                      }
                    }
                  }
                  if (matchedItems.isEmpty) {
                    return Container(
                      alignment: Alignment.center,
                      child: const ResponsiveText(
                        text: "No items",
                        style: TextStyle(color: Colors.black, fontSize: 22),
                      ),
                    );
                  }
                  return MediaQuery.of(context).size.width < 600
                      ? ListView.builder(
                          itemCount: matchedItems.length, //data.length,
                          itemBuilder: (context, index) {
                            UploadDataModel item = matchedItems[index];
                            return //item != null ?
                                Container(
                              height: heights(context, 200),
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(
                                  top: 10, right: 20, left: 20, bottom: 10),
                              decoration: BoxDecoration(
                                  color: secondaryLightColor4,
                                  borderRadius: BorderRadius.circular(20)),
                              child: InkWell(
                                radius: 0,
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PetDetails(petData: item)))
                                      .whenComplete(() => ref.refresh(
                                          getAllFavouritesFutureProvider));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  // margin: const EdgeInsets.all(25),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    color: secondaryLightColor4,
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(item.images.first),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                      : GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // 2 items per row
                                  mainAxisSpacing: 10, // Space between rows
                                  crossAxisSpacing: 10, // Space between columns
                                  childAspectRatio: 2 / 1.5
                                  // Adjust aspect ratio to control the height of grid items
                                  ),
                          itemCount: matchedItems.length,
                          itemBuilder: (context, index) {
                            UploadDataModel item = matchedItems[index];
                            return //item != null ?
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PetDetails(petData: item),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            // height: 500,
                                            margin: EdgeInsets.only(top: 20),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              color: secondaryLightColor4,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                    item.images.first),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                          });
                },
                error: (err, st) {
                  return Container();
                },
                loading: () => const LoadingScreen());
          },
          error: (err, st) {
            return Container();
          },
          loading: () => const LoadingScreen()),
    );
  }
}
