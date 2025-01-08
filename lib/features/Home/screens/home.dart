import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/core/providers.dart';
import 'package:pets/features/Favourites/screens/favouries.dart';
import 'package:pets/features/Home/components/PetCategory.dart';
import 'package:pets/features/Home/screens/drawerScreen.dart';
import 'package:pets/features/Home/screens/pet_details.dart';
import 'package:pets/features/Home/screens/search_Page.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<Home> {
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
    return
        /*  appBar: AppBar(
        toolbarHeight: 80,
        actions: [
          InkWell(
            radius: 0,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchPageIcon()));
            },
            child: Container(
                margin: const EdgeInsets.only(right: 20, left: 20, bottom: 30),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                    color: secondaryLightColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: primaryBgcolor)),
                child: const Hero(tag: "search", child: Icon(Icons.search))),
          )
        ],
      ),*/
        SingleChildScrollView(
      child: Center(
          child: Container(
        color: secondaryLightColor4,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: heights(context, 60),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20, left: 20, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /*  isdrawer
                          ? IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Drawerscreen(),
                                  ),
                                );
                                /* setState(() {
                                  xoffset = 0;
                                  yoffset = 0;
                                  scalefactor = 1;
                                  isdrawer = false;
                                });*/
                              },
                            )
                          :*/
                  IconButton(
                      onPressed: () {
                        /*  setState(() {
                                  double screenWidth =
                                      MediaQuery.of(context).size.width;
                                  double screenHeight =
                                      MediaQuery.of(context).size.height;
        
                                  // Adjust the xoffset and yoffset based on screen width
                                  if (screenWidth < 600) {
                                    // For smaller screens like phones
                                    xoffset = screenWidth * 0.6;
                                    yoffset = screenHeight * 0.4;
                                    scalefactor = 0.8;
                                  } else {
                                    // For larger screens like tablets or desktops
                                    xoffset = screenWidth * 0.5;
                                    yoffset = screenHeight * 0.3;
                                    scalefactor = 0.6;
                                  }
                                  isdrawer = true;
                                });*/
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Drawerscreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.menu)),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const FavouritesScreen()));
                      },
                      icon: const Icon(Icons.favorite)),
                ],
              ),
            ),
            InkWell(
              radius: 0,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchPageIcon()));
              },
              child: Container(
                  margin:
                      const EdgeInsets.only(right: 20, left: 20, bottom: 30),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width - 40,
                  height: heights(context, 60),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: primaryBgcolor)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Hero(tag: "search", child: Icon(Icons.search)),
                      ),
                    ],
                  )),
            ),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Petcategory(animal: 'Cat'),
                  Petcategory(
                    animal: 'Dog',
                  ),
                  Petcategory(
                    animal: 'Birds',
                  ),
                  Petcategory(
                    animal: 'Fish',
                  ),
                  Petcategory(
                    animal: 'cow',
                  ),
                  Petcategory(
                    animal: 'sheep',
                  ),
                  Petcategory(
                    animal: 'horse',
                  ),
                  Petcategory(
                    animal: 'others',
                  ),
                ],
              ),
            ),

            /* Container(
                    height: heights(context, 50),
                    width: widths(context, 150),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: secondaryLightColor),
                    child: const ResponsiveText(
                      text: "All Pets",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black),
                    )),*/
            Container(
              color: secondaryLightColor4,
              child: ref.watch(getAllbannersFutureProvider).when(
                    data: (data) {
                      if (data != null) {
                        /* return CarouselSlider(
                                items: data.map((pet) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PetDetails(petData: pet)));
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.all(20),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: secondaryAccent,
                                          borderRadius: BorderRadius.circular(15),
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(pet.images.first))),
                                    ),
                                  );
                                }).toList(),
                                options: CarouselOptions(autoPlay: true));*/

                        return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(10),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  // MediaQuery.of(context).size.width > 600
                                  //   ? 4
                                  //:
                                  2, // 2 items per row
                              mainAxisSpacing: 10, // Space between rows
                              crossAxisSpacing: 10, // Space between columns
                              childAspectRatio: MediaQuery.of(context)
                                          .size
                                          .width >
                                      600
                                  ? 3 / 2
                                  : 1.1 /
                                      2, // Adjust aspect ratio to control the height of grid items
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
                                            PetDetails(petData: pet),
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
                                            // border:
                                            //   Border.all(color: Colors.black),
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
                                      Image.asset(
                                        "assets/images/${pet.category}.png",
                                        height: 40,
                                        width: 40,
                                      ),
                                    ],
                                  ));
                            });
                      } else {
                        return Container(
                          color: secondaryLightColor4,
                        );
                      }
                    },
                    error: (error, st) {
                      return Container(
                        color: secondaryLightColor4,
                      );
                    },
                    loading: () => Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: 500,
                      color:
                          secondaryLightColor4, // Same background color during loading
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: primaryAccent,
                        ),
                      ),
                    ),
                  ),
            ),
            SizedBox(
              height: heights(context, 20),
            ),
            /* const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Petcategory(animal: 'Cat'),
                      Petcategory(
                        animal: 'Dog',
                      )
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Petcategory(
                        animal: 'Birds',
                      ),
                      Petcategory(
                        animal: 'Fish',
                      )
                    ],
                  ),*/
            SizedBox(
              height: heights(context, 10),
            ),
            /*     ref.watch(queryValue) != ''
                    ? Container(
                        height: heights(context, 50),
                        width: widths(context, 150),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: secondaryLightColor),
                        child: const ResponsiveText(
                          text: "Suggestions",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
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
                                      return CarouselSlider(
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
                                              CarouselOptions(autoPlay: true));
                                    } else {
                                      return Container(
                                        color: secondaryLightColor4,
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
                ),*/
            /* SizedBox(
                    height: heights(context, 5),
                  ),*/
          ],
        ),
      )),
    );
  }
}
