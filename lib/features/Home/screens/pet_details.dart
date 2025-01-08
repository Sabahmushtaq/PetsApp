import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/LoadingScreen.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/custom_textfield.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/models/BuyRequestModel.dart';
import 'package:pets/models/UploadDataModel.dart';
import 'package:pets/utils/colors.dart';

class PetDetails extends ConsumerStatefulWidget {
  final UploadDataModel petData;
  const PetDetails({super.key, required this.petData});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PetDetailsState();
}

class _PetDetailsState extends ConsumerState<PetDetails> {
  final name = TextEditingController();
  final breed = TextEditingController();
  final category = TextEditingController();
  final price = TextEditingController();
  final vaccinated = TextEditingController();
  final uid = TextEditingController();
  final date = TextEditingController();
  final phoneController = TextEditingController();
  bool heart = false;
  @override
  void initState() {
    final pet = widget.petData;
    name.text = "NAME : ${pet.name}";
    category.text = pet.category;
    breed.text = "BREED : ${pet.breed}";
    price.text = pet.price.toString();
    vaccinated.text = pet.vaccinated ? "Vaccinated" : "Not Vaccinated";
    uid.text = pet.uid;
    date.text = pet.date;
    checkFavourite(pet.id);
    super.initState();
  }

  void checkFavourite(String petId) async {
    final result = await ref
        .read(authControllerProvider.notifier)
        .checkFavourite(
            petId, ref.read(authControllerProvider.notifier).userData!.uid);
    if (result) {
      setState(() {
        heart = true;
      });
    } else {
      setState(() {
        heart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UploadDataModel pet = widget.petData;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryLightColor,
        centerTitle: true,
        title: ResponsiveText(
          text: pet.name,
          style: const TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
                items: pet.images.map((toElement) {
                  return InkWell(
                    onTap: () {
                      if (!kIsWeb) {
                        showDialog(
                          context: context,
                          builder: (ctx) => SingleChildScrollView(
                            child: AlertDialog(
                              actions: <Widget>[
                                Image.network(
                                  fit: BoxFit.fill,
                                  toElement,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: MediaQuery.of(context).size.width > 600
                          ? const EdgeInsets.all(40)
                          : const EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: secondaryLightColor,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(toElement))),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(autoPlay: true)),
            CustomTextFieldUpload(textController: name, icon: Icons.pets),
            CustomTextFieldUpload(
                textController: category, icon: Icons.category),
            CustomTextFieldUpload(
                textController: breed, icon: Icons.type_specimen),
            CustomTextFieldUpload(
                textController: price, icon: Icons.currency_rupee_rounded),
            CustomTextFieldUpload(
                textController: vaccinated, icon: Icons.health_and_safety),
            CustomTextFieldUpload(textController: uid, icon: Icons.verified),
            CustomTextFieldUpload(textController: date, icon: Icons.date_range),
            SizedBox(height: heights(context, 10)),
            widget.petData.uid !=
                    ref.watch(authControllerProvider.notifier).userData?.uid
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: secondaryLightColor,
                          border: Border.all(
                            color: Colors.black, // Black border color
                            // Border width
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: MediaQuery.of(context).size.width,
                        margin:
                            const EdgeInsets.only(right: 20, left: 20, top: 7),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                heart = !heart;
                              });
                              if (heart) {
                                ref
                                    .read(authControllerProvider.notifier)
                                    .setFavourite(
                                        widget.petData.id,
                                        ref
                                            .read(
                                                authControllerProvider.notifier)
                                            .userData!
                                            .uid,
                                        context);
                              } else {
                                ref
                                    .read(authControllerProvider.notifier)
                                    .removeFavourite(
                                        widget.petData.id,
                                        ref
                                            .read(
                                                authControllerProvider.notifier)
                                            .userData!
                                            .uid,
                                        context);
                              }
                            },
                            icon: heart
                                ? Image.asset(
                                    'assets/images/clicked.png',
                                    height: 40,
                                    width: 50,
                                  )
                                : Image.asset(
                                    'assets/images/unclicked.png',
                                    height: 40,
                                    width: 50,
                                  )),
                      ),
                      InkWell(
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          final result = await ref
                              .read(authControllerProvider.notifier)
                              .checkRequest(
                                  pet.id + pet.uid,
                                  ref
                                      .read(authControllerProvider.notifier)
                                      .userData!
                                      .uid);
                          pet = (await ref
                              .read(authControllerProvider.notifier)
                              .fetchPetData(widget.petData.id))!;
                          if (pet.stock > 0) {
                            if (result && context.mounted) {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      padding: const EdgeInsets.only(top: 20),
                                      height:
                                          MediaQuery.of(context).size.height,
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          CustomTextField(
                                              a: 10,
                                              keyboard: TextInputType.number,
                                              hintText: "Phone Number",
                                              icon: Icons.numbers,
                                              onChanged: (value) {},
                                              con: phoneController),
                                          phoneController.text.length == 10
                                              ? InkWell(
                                                  focusColor:
                                                      Colors.transparent,
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () {
                                                    ref
                                                        .read(
                                                            authControllerProvider
                                                                .notifier)
                                                        .addBuyRequest(
                                                            BuyRequestModel(
                                                                requesterUID: ref
                                                                        .read(authControllerProvider
                                                                            .notifier)
                                                                        .userData
                                                                        ?.uid ??
                                                                    "",
                                                                ownersUID:
                                                                    pet.uid,
                                                                petid: pet
                                                                    .id, /////add
                                                                phoneNumber:
                                                                    phoneController
                                                                        .text,
                                                                name: pet.name,
                                                                images:
                                                                    pet.images),
                                                            context);
                                                    decrementStock();
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: primaryBgcolor),
                                                    alignment: Alignment.center,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            hei(context, 50),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 40,
                                                            left: 40,
                                                            top: 7),
                                                    child: ref.watch(
                                                            authControllerProvider)
                                                        ? const LoadingScreen()
                                                        : const ResponsiveText(
                                                            text:
                                                                "Request to Buy",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "SF",
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16.5),
                                                          ),
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    );
                                  });
                            }
                          } else {
                            // Stock is 0 or less, show out of stock message
                            if (result) {
                              AnimatedSnackBar.material("Out of Stock",
                                      type: AnimatedSnackBarType.error,
                                      animationDuration:
                                          const Duration(milliseconds: 500),
                                      mobilePositionSettings:
                                          const MobilePositionSettings(
                                              topOnAppearance: 100))
                                  .show(context);
                            }

                            if (context.mounted && !result) {
                              AnimatedSnackBar.material("Already Requested",
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
                          height: MediaQuery.of(context).size.height /
                              hei(context, 50),
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(
                              right: 20, left: 20, top: 7),
                          child: const ResponsiveText(
                            text: "Request to Buy",
                            style: TextStyle(
                                fontFamily: "SF",
                                color: Colors.white,
                                fontSize: 16.5),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
            SizedBox(
              height: heights(context, 10),
            ),
          ],
        ),
      ),
    );
  }

  void decrementStock() {
    ref
        .read(authControllerProvider.notifier)
        .updateStock(widget.petData, context); // Decrement stock by 1
  }
}
