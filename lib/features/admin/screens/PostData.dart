import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/LoadingScreen.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/custom_textfield.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/models/UploadDataModel.dart';
import 'package:pets/utils/colors.dart';

class PostData extends ConsumerStatefulWidget {
  final UploadDataModel petData;
  const PostData({super.key, required this.petData});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostDataState();
}

class _PostDataState extends ConsumerState<PostData> {
  late UploadDataModel model;
  Timer? timer;

  final name = TextEditingController();
  final breed = TextEditingController();
  final category = TextEditingController();
  final price = TextEditingController();
  final vaccinated = TextEditingController();
  final uid = TextEditingController();
  final reasonController = TextEditingController();
  @override
  void initState() {
    final pet = widget.petData;
    name.text = pet.name;
    category.text = pet.category;
    breed.text = pet.breed;
    price.text = pet.price.toString();
    vaccinated.text = pet.vaccinated ? "Vaccinated" : "Not Vaccinated";
    uid.text = pet.uid;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.petData;
    return Scaffold(
      appBar: AppBar(
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
                      showDialog(
                        context: context,
                        builder: (ctx) => SingleChildScrollView(
                          child: AlertDialog(
                            actions: <Widget>[Image.network(toElement)],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: secondaryLightColor,
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: NetworkImage(toElement),
                              fit: BoxFit.fill)),
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
            SizedBox(
              height: heights(context, 10),
            ),
            ref.watch(getPetDetailStreamProvider(widget.petData.id)).when(
                data: (data) {
                  if (data != null) {
                    return (data.rejected == false && data.verified == false)
                        ? Column(
                            children: [
                              InkWell(
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  ref
                                      .read(authControllerProvider.notifier)
                                      .adminVerify(pet, context, ref);
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
                                      right: 40, left: 40, top: 7),
                                  child: ref.watch(authControllerProvider)
                                      ? const LoadingScreen()
                                      : const ResponsiveText(
                                          text: "Accept",
                                          style: TextStyle(
                                              fontFamily: "SF",
                                              color: Colors.white,
                                              fontSize: 16.5),
                                        ),
                                ),
                              ),
                              InkWell(
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              CustomTextField(
                                                  a: 100,
                                                  keyboard: TextInputType.text,
                                                  hintText: "Reason",
                                                  icon: Icons.description,
                                                  onChanged: (value) {},
                                                  con: reasonController),
                                              reasonController.text.isNotEmpty
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
                                                            .adminReject(
                                                                pet,
                                                                context,
                                                                ref,
                                                                reasonController
                                                                    .text);
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color:
                                                                primaryBgcolor),
                                                        alignment:
                                                            Alignment.center,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            hei(context, 50),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        margin: const EdgeInsets
                                                            .only(
                                                            right: 40,
                                                            left: 40,
                                                            top: 7),
                                                        child: ref.watch(
                                                                authControllerProvider)
                                                            ? const LoadingScreen()
                                                            : const ResponsiveText(
                                                                text: "Reject",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "SF",
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16.5),
                                                              ),
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.red),
                                  alignment: Alignment.center,
                                  height: MediaQuery.of(context).size.height /
                                      hei(context, 50),
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(
                                      right: 40, left: 40, top: 7),
                                  child: ref.watch(authControllerProvider)
                                      ? const LoadingScreen()
                                      : const ResponsiveText(
                                          text: "Reject",
                                          style: TextStyle(
                                              fontFamily: "SF",
                                              color: Colors.white,
                                              fontSize: 16.5),
                                        ),
                                ),
                              ),
                            ],
                          )
                        : Container();
                  } else {
                    return Container();
                  }
                },
                error: (e, st) {
                  return Container();
                },
                loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: primaryAccent,
                      ),
                    )),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
