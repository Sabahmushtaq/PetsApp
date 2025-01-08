import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/custom_textfield.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/utils/colors.dart';

class CategoriesValues extends ConsumerStatefulWidget {
  const CategoriesValues({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoriesValuesState();
}

class _CategoriesValuesState extends ConsumerState<CategoriesValues> {
  final name = TextEditingController();
  final image = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const ResponsiveText(
          text: "Categories",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
      body: ref.watch(getAllCategoriesFutureProvider).when(
          data: (data) {
            if (data != []) {
              return ListView.builder(
                  itemCount: data?.length,
                  itemBuilder: (context, index) {
                    return Container(
                      alignment: Alignment.center,
                      height: heights(context, 130),
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          top: 10, right: 20, left: 20, bottom: 10),
                      decoration: BoxDecoration(
                          color: secondaryAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CachedNetworkImage(
                            imageUrl: data![index]['image'],
                            width: 60,
                            height: 60,
                          ),
                          ResponsiveText(
                            text: data[index]['name'],
                            style: const TextStyle(
                                color: Colors.black, fontSize: 24),
                          ),
                          IconButton(
                              onPressed: () {
                                ref
                                    .read(authControllerProvider.notifier)
                                    .deleteCategory(data[index]['name'], ref);
                              },
                              icon: const Icon(Icons.delete))
                        ],
                      ),
                    );
                  });
            } else {
              return Container(
                alignment: Alignment.center,
                child: const Text("No Items"),
              );
            }
          },
          error: (error, st) {
            return null;
          },
          loading: () => const Center(
                child: CircularProgressIndicator(
                  color: primaryAccent,
                ),
              )),
      floatingActionButton: FloatingActionButton(
          backgroundColor: secondaryLightColor,
          onPressed: () async {
            name.clear();
            image.clear();
            await showModalBottomSheet(
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
                              a: 10000,
                              hintText: "Name",
                              icon: Icons.person,
                              onChanged: (value) {},
                              con: name),
                          CustomTextField(
                              a: 10000,
                              hintText: "Image URL",
                              icon: Icons.category_rounded,
                              onChanged: (value) {},
                              con: image),
                          const SizedBox(
                            height: 10,
                          ),
                          name.text.isNotEmpty && image.text.isNotEmpty
                              ? InkWell(
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    final params = {
                                      'name': name.text.toLowerCase(),
                                      'image': image.text
                                    };
                                    ref
                                        .read(authControllerProvider.notifier)
                                        .addCategory(params, context, ref);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: primaryBgcolor),
                                      alignment: Alignment.center,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              hei(context, 50),
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.only(
                                          right: 20, left: 20, top: 7),
                                      child: const ResponsiveText(
                                        text: "Create Category",
                                        style: TextStyle(
                                            fontFamily: "SF",
                                            color: Colors.white,
                                            fontSize: 16.5),
                                      )),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  );
                });
          },
          child: const Icon(
            Icons.add,
          )),
    );
  }
}
