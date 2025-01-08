/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/LoadingScreen.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/custom_textfield.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/core/providers.dart';
import 'package:pets/features/Home/screens/pet_details.dart';
import 'package:pets/features/Sell/controller/Sell_Page_Controller.dart';
import 'package:pets/models/UploadDataModel.dart';
import 'package:pets/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPageIcon extends ConsumerStatefulWidget {
  const SearchPageIcon({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageIconState();
}

class _SearchPageIconState extends ConsumerState<SearchPageIcon> {
  final searchController = TextEditingController();
  final costRangeProvider = StateProvider<RangeValues>((ref) {
    return const RangeValues(0, 8000); // Initial range
  }); // Example initial range
  List<UploadDataModel> filteredData = [];
  List<UploadDataModel> dataList = [];
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    final costRange = ref.watch(costRangeProvider); // Get current RangeValues
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: Column(children: [
        SearchTextField(
            hintText: "Search animal",
            icon: Icons.search,
            onChanged: (value) {
              setState(() {});
            },
            con: searchController),
        RangeSlider(
          activeColor: primaryBgcolor,
          values: costRange,
          min: 0,
          max: 20000,
          divisions: 100,
          labels: RangeLabels(
            costRange.start.round().toString(),
            costRange.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            ref.read(costRangeProvider.notifier).state = values;
          },
        ),
        InkWell(
          child: const Text(
            'Apply Filter',
            style: TextStyle(color: Colors.blueAccent),
          ),
          onTap: () {
            applyFilter();
          },
        ),
        searchController.text.isNotEmpty
            ? Expanded(
                child: ref
                    .watch(getSearchItemFutureProvider(
                        searchController.text.toLowerCase()))
                    .when(
                        data: (data) {
                          if (data != null) {
                            dataList = isClicked ? filteredData : data;
                            isClicked = false;
                            // costRange = const RangeValues(100, 8000);
                            return dataList.isNotEmpty
                                ? ListView.builder(
                                    itemCount: dataList.length,
                                    itemBuilder: (context, index) {
                                      final pet = dataList[index];

                                      return Container(
                                        height: heights(context, 200),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.only(
                                            top: 10,
                                            right: 20,
                                            left: 20,
                                            bottom: 20),
                                        decoration: BoxDecoration(
                                            color: secondaryLightColor4,
                                            border:
                                                Border.all(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: InkWell(
                                          radius: 0,
                                          onTap: () async {
                                            final shared =
                                                await SharedPreferences
                                                    .getInstance();

                                            ref
                                                .read(queryValue.notifier)
                                                .state = pet.category;
                                            shared.setString(
                                                'query', pet.category);

                                            if (context.mounted) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PetDetails(
                                                              petData: pet)));
                                            }
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            // margin: const EdgeInsets.all(25),
                                            decoration: BoxDecoration(
                                              color: secondaryLightColor4,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                    pet.images.first),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                : Container(
                                    alignment: Alignment.center,
                                    child: const ResponsiveText(
                                      text: "No items",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 22),
                                    ),
                                  );
                          } else {
                            return Container(
                              alignment: Alignment.center,
                              child: const ResponsiveText(
                                text: "No items",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 22),
                              ),
                            );
                          }
                        },
                        error: (error, st) {
                          return Container();
                        },
                        loading: () => const Center(child: LoadingScreen())),
              )
            : Container()
      ]),
    );
  }

  // Function to apply the filter
  void applyFilter() {
    final costRange = ref.read(costRangeProvider); // Access costRange here
    filteredData.clear();
    if (dataList.isNotEmpty && searchController.text.isNotEmpty) {
      isClicked = true;
      setState(() {
        // Check if no filters are applied

        filteredData = dataList
            .where((animal) =>
                animal.price >= costRange.start &&
                animal.price <= costRange.end)
            .toList();
      });
      print(filteredData);
    }
  }
}*/
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/LoadingScreen.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/custom_textfield.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/core/providers.dart';
import 'package:pets/features/Home/screens/pet_details.dart';
import 'package:pets/features/Sell/controller/Sell_Page_Controller.dart';
import 'package:pets/models/UploadDataModel.dart';
import 'package:pets/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPageIcon extends ConsumerStatefulWidget {
  const SearchPageIcon({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageIconState();
}

class _SearchPageIconState extends ConsumerState<SearchPageIcon> {
  final searchController = TextEditingController();
  final costRangeProvider = StateProvider<RangeValues>((ref) {
    return const RangeValues(0, 8000);
  });
  List<UploadDataModel> filteredData = [];
  List<UploadDataModel> dataList = [];
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    final costRange = ref.watch(costRangeProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          // Search TextField
          SearchTextField(
            hintText: "Search animal",
            icon: Icons.search,
            onChanged: (value) {
              setState(() {});
            },
            con: searchController,
          ),
          // RangeSlider for cost range
          RangeSlider(
            activeColor: primaryBgcolor,
            values: costRange,
            min: 0,
            max: 50000,
            divisions: 100,
            labels: RangeLabels(
              costRange.start.round().toString(),
              costRange.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              ref.read(costRangeProvider.notifier).state = values;
            },
          ),
          // Apply Filter Button
          InkWell(
            child: const Text(
              'Apply Price Filter',
              style: TextStyle(color: Colors.blueAccent),
            ),
            onTap: () {
              applyFilter();
            },
          ),
          // Results
          searchController.text.isNotEmpty
              ? Expanded(
                  child: ref
                      .watch(getSearchItemFutureProvider(
                          searchController.text.toLowerCase()))
                      .when(
                        data: (data) {
                          if (data != null) {
                            dataList = isClicked ? filteredData : data;
                            isClicked = false;

                            if (dataList.isEmpty) {
                              return const Center(
                                child: ResponsiveText(
                                  text: "No items",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 22),
                                ),
                              );
                            }

                            // Use GridView.builder for larger screens, ListView.builder for smaller screens
                            if (MediaQuery.of(context).size.width > 600) {
                              return GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1.0, // Adjust as needed
                                ),
                                itemCount: dataList.length,
                                itemBuilder: (context, index) {
                                  final pet = dataList[index];
                                  return buildPetCard(context, pet);
                                },
                              );
                            } else {
                              return ListView.builder(
                                itemCount: dataList.length,
                                itemBuilder: (context, index) {
                                  final pet = dataList[index];
                                  return buildPetCard(context, pet);
                                },
                              );
                            }
                          } else {
                            return const Center(
                              child: ResponsiveText(
                                text: "No items",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 22),
                              ),
                            );
                          }
                        },
                        error: (error, st) {
                          return Container();
                        },
                        loading: () => const Center(child: LoadingScreen()),
                      ),
                )
              : Container(),
        ],
      ),
    );
  }

  // Build the pet card
  Widget buildPetCard(BuildContext context, UploadDataModel pet) {
    return Container(
      height: heights(context, 200),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 20),
      decoration: BoxDecoration(
        color: secondaryLightColor4,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        radius: 0,
        onTap: () async {
          final shared = await SharedPreferences.getInstance();
          ref.read(queryValue.notifier).state = pet.category;
          shared.setString('query', pet.category);
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PetDetails(petData: pet),
              ),
            );
          }
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

  // Apply the filter
  void applyFilter() {
    final costRange = ref.read(costRangeProvider);
    filteredData.clear();
    if (dataList.isNotEmpty && searchController.text.isNotEmpty) {
      isClicked = true;
      setState(() {
        filteredData = dataList
            .where((animal) =>
                animal.price >= costRange.start &&
                animal.price <= costRange.end)
            .toList();
      });
    }
  }
}
