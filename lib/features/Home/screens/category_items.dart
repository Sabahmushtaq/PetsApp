/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/LoadingScreen.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/features/Home/screens/pet_details.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/utils/colors.dart';

class CategoryItems extends ConsumerStatefulWidget {
  final String category;
  const CategoryItems({super.key, required this.category});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryItemsState();
}

class _CategoryItemsState extends ConsumerState<CategoryItems> {
  bool noItems = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ResponsiveText(
          text: widget.category,
          style: const TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
      body: ref.watch(getAllRequestsFutureProvider).when(
          data: (data) {
            if (data != null) {
              for (var value in data) {
                if (value.category.contains(widget.category)) {
                  noItems = false;
                }
              }
              return noItems
                  ? Container(
                      alignment: Alignment.center,
                      child: const ResponsiveText(
                        text: "No items",
                        style: TextStyle(color: Colors.black, fontSize: 22),
                      ),
                    )
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final pet = data[index];

                        return (pet.category.contains(widget.category) &&
                                pet.verified == true)
                            ? Container(
                                height: MediaQuery.of(context).size.width < 600
                                    ? heights(context, 180)
                                    : heights(context, 300),
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                    top: 10, right: 20, left: 20, bottom: 10),
                                decoration: BoxDecoration(
                                    color: secondaryAccent,
                                    borderRadius: BorderRadius.circular(20)),
                                child: InkWell(
                                  radius: 0,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PetDetails(petData: pet)));
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    // margin: const EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                      color: secondaryLightColor4,
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(pet.images.first),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container();
                      });
            } else {
              return Container(
                alignment: Alignment.center,
                child: const ResponsiveText(
                  text: "No items",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              );
            }
          },
          error: (error, st) {
            return null;
          },
          loading: () => const Center(child: LoadingScreen())),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/LoadingScreen.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/features/Home/screens/pet_details.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/utils/colors.dart';

class CategoryItems extends ConsumerStatefulWidget {
  final String category;
  const CategoryItems({super.key, required this.category});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryItemsState();
}

class _CategoryItemsState extends ConsumerState<CategoryItems> {
  bool noItems = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ResponsiveText(
          text: widget.category,
          style: const TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
      body: ref.watch(getAllRequestsFutureProvider).when(
          data: (data) {
            if (data != null) {
              List filteredPets = data
                  .where((pet) =>
                      pet.category.contains(widget.category) &&
                      pet.verified == true)
                  .toList();

              if (filteredPets.isEmpty) {
                return const Center(
                  child: ResponsiveText(
                    text: "No items",
                    style: TextStyle(color: Colors.black, fontSize: 22),
                  ),
                );
              }

              return screenWidth > 600
                  ? GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth > 600 ? 2 : 1,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: screenWidth > 600 ? 1.5 : 1,
                      ),
                      itemCount: filteredPets.length,
                      itemBuilder: (context, index) {
                        final pet = filteredPets[index];
                        return _buildPetItem(context, pet);
                      },
                    )
                  : ListView.builder(
                      itemCount: filteredPets.length,
                      itemBuilder: (context, index) {
                        final pet = filteredPets[index];
                        return _buildPetItem(context, pet);
                      },
                    );
            } else {
              return Center(
                child: const ResponsiveText(
                  text: "No items",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              );
            }
          },
          error: (error, st) {
            return Center(
              child: Text('Error: $error'),
            );
          },
          loading: () => const Center(child: LoadingScreen())),
    );
  }

  Widget _buildPetItem(BuildContext context, var pet) {
    return Container(
      height: MediaQuery.of(context).size.width < 600
          ? heights(context, 180)
          : heights(context, 300),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
      decoration: BoxDecoration(
        color: secondaryAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        radius: 0,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PetDetails(petData: pet)));
        },
        child: Container(
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
      ),
    );
  }
}
