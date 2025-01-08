import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/providers.dart';
import 'package:pets/features/Home/screens/pet_details.dart';
import 'package:pets/features/Sell/controller/Sell_Page_Controller.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/utils/colors.dart';

class PostedPage extends ConsumerStatefulWidget {
  const PostedPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostedPageState();
}

class _PostedPageState extends ConsumerState<PostedPage> {
  @override
  void initState() {
    super.initState();
    ref.read(imagePickerControllerProvider.notifier).getSellData();
    getCats();
  }

  void getCats() async {
    final result =
        await ref.read(authControllerProvider.notifier).getCategories();

    for (var i in result ?? []) {
      if (!categoryValues.contains(i['name'])) {
        categoryValues.add(i['name']);
        firebaseValues.addAll({i['name']: i['image']});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: secondaryLightColor,
          title: const ResponsiveText(
            text: "Sell your Pet Here",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  // ignore: unused_result
                  ref.refresh(futureSellDataProvider.future);
                },
                icon: const Icon(Icons.refresh))
          ],
          centerTitle: true,
        ),
        body: RefreshIndicator(
            onRefresh: () => ref.refresh(futureSellDataProvider.future),
            child: ref.watch(futureSellDataProvider).when(
                data: (data) {
                  if (data!.isNotEmpty) {
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final i = data[index];

                          return InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Select an option"),
                                  actions: <Widget>[
                                    Column(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            ref
                                                .read(
                                                    imagePickerControllerProvider
                                                        .notifier)
                                                .removeItem(i.id, ref);
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.black,
                                            ),
                                            padding: const EdgeInsets.all(14),
                                            child: const Center(
                                              child: Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PetDetails(
                                                            petData: i)));
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.black,
                                            ),
                                            padding: const EdgeInsets.all(14),
                                            child: const Center(
                                              child: Text(
                                                "Animal Details",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(15),
                              //height: heights(context, 80),
                              decoration: BoxDecoration(
                                  color: secondaryLightColor4,
                                  borderRadius: BorderRadius.circular(15)),
                              width: MediaQuery.of(context).size.width - 60,
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    [
                                      'Cat',
                                      'Dog',
                                      'Fish',
                                      'Birds',
                                      'cow',
                                      'sheep',
                                      'horse',
                                      'others'
                                    ].contains(i.category)
                                        ? Image.asset(
                                            "assets/images/${i.category}.png",
                                            height: 60,
                                            width: 60,
                                          )
                                        : Image.network(
                                            firebaseValues[i.category]),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ResponsiveText(
                                              text: i.name.toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16)),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                  Icons.currency_rupee_rounded),
                                              Text(i.price.toString())
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
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
                error: (e, st) {
                  return Container();
                },
                loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: primaryAccent,
                      ),
                    ))));
  }
}
