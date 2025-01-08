import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/Get_date.dart';
import 'package:pets/core/LoadingScreen.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/custom_textfield.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/core/providers.dart';
import 'package:pets/features/Sell/controller/Sell_Page_Controller.dart';
import 'package:pets/features/admin/screens/PostData.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/models/UploadDataModel.dart';
import 'package:pets/utils/colors.dart';
import 'package:uuid/uuid.dart';

class AllPosts extends ConsumerStatefulWidget {
  const AllPosts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllPostsState();
}

class _AllPostsState extends ConsumerState<AllPosts> {
  final name = TextEditingController();
  final breed = TextEditingController();
  final price = TextEditingController();
  final color = TextEditingController();
  String? vaccinated;
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const ResponsiveText(
          text: "All Post Requests",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
      body: ref.watch(getAllRequestsStreamProvider).when(
          data: (data) {
            if (data.isNotEmpty) {
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final pet = data[index];
                    return pet.checked == false && pet.rejected == false
                        ? Container(
                            height: heights(context, 130),
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(
                                top: 10, right: 20, left: 20, bottom: 10),
                            decoration: BoxDecoration(
                                color: secondaryLightColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: InkWell(
                              radius: 0,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PostData(petData: pet)));
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.all(25),
                                  child: ResponsiveText(
                                    text: pet.name,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  )),
                            ),
                          )
                        : Container();
                  });
            } else {
              return Container();
            }
          },
          error: (error, st) {
            return null;
          },
          loading: () => const Center(child: LoadingScreen())),
      floatingActionButton: FloatingActionButton(
          backgroundColor: secondaryLightColor4,
          child: const Icon(Icons.add),
          onPressed: () async {
            name.text = "";
            breed.text = "";
            color.text = "";
            price.text = "";
            selectedValue = null;
            vaccinated = null;
            ref.read(photosProvider.notifier).state = {};
            return await showModalBottomSheet(
                backgroundColor: Colors.white,
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return FractionallySizedBox(
                    heightFactor: 0.9,
                    child: Container(
                      margin: const EdgeInsets.only(top: 25),
                      child: Column(
                        children: [
                          CustomTextField(
                              hintText: "Name",
                              a: 13,
                              icon: Icons.person,
                              onChanged: (value) {},
                              con: name),
                          CustomTextField(
                              hintText: "Breed e.g -None",
                              a: 10,
                              icon: Icons.category_rounded,
                              onChanged: (value) {},
                              con: breed),
                          CustomTextField(
                              hintText: "Color",
                              a: 10,
                              icon: Icons.color_lens,
                              onChanged: (value) {},
                              con: color),
                          CustomTextField(
                              a: 8,
                              hintText: "Price",
                              icon: Icons.currency_rupee,
                              keyboard: TextInputType.number,
                              onChanged: (value) {},
                              con: price),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    'Category',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: categoryValues
                                      .map((String item) =>
                                          DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedValue,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedValue = value;
                                    });
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    height: 40,
                                    width: 140,
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                  ),
                                ),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    'Vaccinated ?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: ["Yes", "No"]
                                      .map((String item) =>
                                          DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  value: vaccinated,
                                  onChanged: (String? value) {
                                    setState(() {
                                      vaccinated = value;
                                    });
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    height: 40,
                                    width: 140,
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              if (ref.read(photosProvider).isEmpty) {
                                ref
                                    .read(
                                        imagePickerControllerProvider.notifier)
                                    .picker(context);
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      ////
                                      return SingleChildScrollView(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.white,
                                          ),
                                          margin: const EdgeInsets.only(
                                              right: 20,
                                              left: 20,
                                              bottom: 80,
                                              top: 60),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Center(
                                              child: Column(
                                            children: [
                                              for (var i in ref
                                                  .watch(photosProvider)
                                                  .values) ...[
                                                Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Image(
                                                      image: XFileImage(i),
                                                      height: 120,
                                                      width: 120,
                                                    ))
                                              ]
                                            ],
                                          )),
                                        ),
                                      );
                                    });
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              height: heights(context, 40),
                              width: widths(context, 140),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: ref.watch(photosProvider).isEmpty
                                      ? primaryBgcolor
                                      : primaryAccent),
                              child: ResponsiveText(
                                text: ref.watch(photosProvider).isEmpty
                                    ? "Add Images"
                                    : "Preview Images",
                              ),
                            ),
                          ),
                          if (ref.watch(photosProvider).isNotEmpty) ...[
                            InkWell(
                              onTap: () {
                                ref
                                    .read(
                                        imagePickerControllerProvider.notifier)
                                    .picker(context);
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                alignment: Alignment.center,
                                height: heights(context, 40),
                                width: widths(context, 140),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: primaryBgcolor),
                                child: const ResponsiveText(
                                    text: "Upload New Images"),
                              ),
                            )
                          ],
                          if (ref.watch(photosProvider).isNotEmpty &&
                              name.text.isNotEmpty &&
                              breed.text.isNotEmpty &&
                              color.text.isNotEmpty &&
                              price.text.isNotEmpty &&
                              selectedValue != null &&
                              vaccinated != null) ...[
                            InkWell(
                              onTap: () {
                                // print(" here is $uniqueId");

                                if (ref.watch(photosProvider).isEmpty) {
                                  showSnackbar(context,
                                      "Please select at least one photo.");
                                } else if (name.text.isEmpty) {
                                  showSnackbar(
                                      context, "Name cannot be empty.");
                                } else if (!isValidName(name.text)) {
                                  showSnackbar(context,
                                      "Invalid name. Only letters and spaces are allowed.");
                                } else if (breed.text.isEmpty) {
                                  showSnackbar(
                                      context, "Breed cannot be empty.");
                                } else if (!isValidBreed(breed.text)) {
                                  showSnackbar(context,
                                      "Invalid breed. Only letters and spaces are allowed.");
                                } else if (color.text.isEmpty) {
                                  showSnackbar(
                                      context, "Color cannot be empty.");
                                } else if (!isValidName(color.text)) {
                                  showSnackbar(context, "Invalid Color.");
                                } else if (price.text.isEmpty) {
                                  showSnackbar(
                                      context, "Price cannot be empty.");
                                } else if (selectedValue == null) {
                                  showSnackbar(
                                      context, "Please select a category.");
                                } else if (!isNumeric(price.text)) {
                                  showSnackbar(
                                      context, "Please select a valid price.");
                                } else if (vaccinated == null) {
                                  showSnackbar(context,
                                      "Please specify vaccination status.");
                                } else {
                                  ref
                                      .read(imagePickerControllerProvider
                                          .notifier)
                                      .uploadData(
                                          context,
                                          UploadDataModel(
                                              name: name.text,
                                              breed: breed.text,
                                              category: selectedValue ?? '',
                                              color: color.text,
                                              vaccinated:
                                                  vaccinated!.contains("Yes")
                                                      ? true
                                                      : false,
                                              price: int.parse(price.text),
                                              stock: 1,
                                              id: const Uuid()
                                                  .v4(), // Generate a unique ID first

                                              images: [],
                                              verified: true,
                                              rejected: false,
                                              checked: true,
                                              date: getCurrentDate(),
                                              uid: ref
                                                  .read(authControllerProvider
                                                      .notifier)
                                                  .userData!
                                                  .uid));
                                }
                              },
                              child: ref.watch(imagePickerControllerProvider)
                                  ? const CircularProgressIndicator(
                                      color: primaryAccent,
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      height: heights(context, 50),
                                      width: widths(context, 160),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: primaryAccent),
                                      child: const ResponsiveText(
                                          text: "Upload Data"),
                                    ),
                            )
                          ]
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }

  bool isValidName(String name) {
    final RegExp nameRegExp =
        RegExp(r"^[a-zA-Z\s]+$"); // Only letters and spaces allowed
    return nameRegExp.hasMatch(name);
  }

  void showSnackbar(BuildContext context, String message) {
    AnimatedSnackBar.material(message, //Display correct error message
            type: AnimatedSnackBarType.warning,
            animationDuration: const Duration(milliseconds: 300),
            mobilePositionSettings:
                const MobilePositionSettings(topOnAppearance: 100))
        .show(context);
  }

  bool isValidBreed(String breed) {
    final RegExp breedRegExp =
        RegExp(r"^[a-zA-Z\s]+$"); // Only letters and spaces allowed
    return breedRegExp.hasMatch(breed);
  }

  bool isNumeric(String input) {
    final numericRegex = RegExp(r'^[0-9]+$');
    return numericRegex.hasMatch(input);
  }
}
