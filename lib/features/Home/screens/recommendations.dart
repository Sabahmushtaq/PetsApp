import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/core/providers.dart';
import 'package:pets/features/Home/screens/pet_details.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Suggestions extends ConsumerStatefulWidget {
  const Suggestions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SuggestionsPageState();
}

class _SuggestionsPageState extends ConsumerState<Suggestions> {
  @override
  void initState() {
    getQuery();
    super.initState();
  }

  void getQuery() async {
    final user = await SharedPreferences.getInstance();
    ref.read(queryValue.notifier).state = user.getString('query') ?? '';
  }

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryLightColor4,
      appBar: AppBar(
        backgroundColor: secondaryLightColor,
        centerTitle: true,
        title: const ResponsiveText(
          text: "Recommendations",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Container(
          color: secondaryLightColor4,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: heights(context, 10),
              ),
              ref.watch(queryValue) != ''
                  ? Container(
                      height: heights(context, 50),
                      // width: widths(context, 150),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        //  color: secondaryLightColor
                      ),
                      child: const ResponsiveText(
                        text: "Our Suggestions for you -",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 24,
                            color: Colors.black),
                      ))
                  : Container(
                      color: secondaryLightColor4,
                    ),
              Container(
                color: secondaryLightColor4,
                child: ref.watch(queryValue) != ''
                    ? Container(
                        color: secondaryLightColor4,
                        child: ref
                            .watch(getSuggestionBannersFutureProvider(
                                ref.watch(queryValue)))
                            .when(
                                data: (data) {
                                  if (data != null) {
                                    return /*CarouselSlider(
                                        items: data.map((pet) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PetDetails(
                                                              petData: pet)));
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.all(20),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  color: secondaryLightColor,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(
                                                          pet.images.first))),
                                            ),
                                          );
                                        }).toList(),
                                        options:
                                            CarouselOptions(autoPlay: true));*/

                                        MediaQuery.of(context).size.width < 600
                                            ? ListView.builder(
                                                itemCount: data.length,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                //  padding:
                                                //    const EdgeInsets.all(12),
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PetDetails(
                                                                      petData: data[
                                                                          index])));
                                                    },
                                                    child: Container(
                                                      height:
                                                          heights(context, 180),
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              right: 20,
                                                              left: 20,
                                                              bottom: 10),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black),
                                                          color:
                                                              secondaryLightColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: NetworkImage(
                                                                  data[index]
                                                                      .images
                                                                      .first))),
                                                    ),
                                                  );
                                                })
                                            : GridView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                padding:
                                                    const EdgeInsets.all(20),
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount:
                                                            2, // 2 items per row
                                                        mainAxisSpacing:
                                                            10, // Space between rows
                                                        crossAxisSpacing:
                                                            10, // Space between columns
                                                        childAspectRatio:
                                                            2 / 1.5
                                                        // Adjust aspect ratio to control the height of grid items
                                                        ),
                                                itemCount: data.length,
                                                itemBuilder: (context, index) {
                                                  final pet = data[index];
                                                  return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                PetDetails(
                                                                    petData:
                                                                        pet),
                                                          ),
                                                        );
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              // height: 500,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 20),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black),
                                                                color:
                                                                    secondaryLightColor4,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                image:
                                                                    DecorationImage(
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  image: NetworkImage(
                                                                      pet.images
                                                                          .first),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ));
                                                });
                                  } else {
                                    return Container(
                                      color: secondaryLightColor4,
                                      child: const Text("No items",
                                          style:
                                              TextStyle(color: Colors.black)),
                                    );
                                  }
                                },
                                error: (error, st) {
                                  return Container(
                                    color: secondaryLightColor4,
                                  );
                                },
                                loading: () => Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      width: 500,
                                      color:
                                          secondaryLightColor4, // Same background color during loading
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: primaryAccent,
                                        ),
                                      ),
                                    )),
                      )
                    : Container(
                        color: secondaryLightColor4,
                      ),
              ),
              /* SizedBox(
                      height: heights(context, 5),
                    ),*/
            ],
          ),
        )),
      ),
    );
  }
}
