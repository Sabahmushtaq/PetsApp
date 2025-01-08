/*import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/core/providers.dart';
import 'package:pets/features/Sell/controller/Sell_Page_Controller.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/utils/colors.dart';

class BuyRequest extends ConsumerStatefulWidget {
  const BuyRequest({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BuyRequestState();
}

class _BuyRequestState extends ConsumerState<BuyRequest> {
  @override
  void initState() {
    super.initState();
    ref.read(imagePickerControllerProvider.notifier).getAllBuyRequests();
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: secondaryLightColor,
        title: const ResponsiveText(
          text: "Requests for Buying",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(top: 18.0, bottom: 15, right: 20, left: 20),
              child: Center(
                child: Flexible(
                  child: Text(
                      style: TextStyle(color: Colors.green),
                      "After you sell Your Animal, Delete the sell request"),
                ),
              ),
            ),
            ref.watch(getAllBuyRequestsFutureProvider).when(
                data: (data) {
                  if (data!.isNotEmpty) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            radius: 0,
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Select an option"),
                                  actions: <Widget>[
                                    Column(
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            await FlutterPhoneDirectCaller
                                                .callNumber(
                                                    data[index].phoneNumber);
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
                                                "Call this request",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            ref
                                                .read(authControllerProvider
                                                    .notifier)
                                                .updateStock2(
                                                    data[index].petid, context);
                                            ref
                                                .read(
                                                    imagePickerControllerProvider
                                                        .notifier)
                                                .removeItem2(
                                                    ///////change

                                                    data[index].petid +
                                                        data[index].ownersUID,
                                                    ref);
                                            ref.refresh(
                                                getAllBuyRequestsFutureProvider);
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
                                                "Delete This Request",
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
                              margin: const EdgeInsets.all(10),
                              height: heights(context, 80),
                              decoration: BoxDecoration(
                                  color: secondaryLightColor4,
                                  borderRadius: BorderRadius.circular(15)),
                              width: MediaQuery.of(context).size.width - 60,
                              child: ref
                                  .watch(
                                      getItemFutureProvider(data[index].petid))

                                  ///
                                  .when(
                                      data: (values) {
                                        if (values != null) {
                                          return Row(
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
                                              ].contains(values.category)
                                                  ? Image.asset(
                                                      "assets/images/${values.category}.png",
                                                      height: 60,
                                                      width: 60,
                                                    )
                                                  : Image.network(
                                                      firebaseValues[
                                                          values.category]),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ResponsiveText(
                                                      text: values.name,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons
                                                          .currency_rupee_rounded),
                                                      Text(values.price
                                                          .toString())
                                                    ],
                                                  )
                                                ],
                                              ),
                                              ref
                                                  .watch(
                                                      getCustomerInfoFutureProvider(
                                                          data[index]
                                                              .requesterUID))
                                                  .when(
                                                      data: (customer) {
                                                        if (customer != null) {
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ResponsiveText(
                                                                  text: customer
                                                                      .name,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              ResponsiveText(
                                                                  text: data[
                                                                          index]
                                                                      .phoneNumber,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16,
                                                                  ))
                                                            ],
                                                          );
                                                        } else {
                                                          return Container();
                                                        }
                                                      },
                                                      error: (error, st) {
                                                        return Container();
                                                      },
                                                      loading: () =>
                                                          const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              color:
                                                                  primaryAccent,
                                                            ),
                                                          ))
                                            ],
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                      error: (error, st) {
                                        return Container();
                                      },
                                      loading: () => const Center(
                                            child: CircularProgressIndicator(
                                              color: primaryAccent,
                                            ),
                                          )),
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
                    )),
          ],
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/core/providers.dart';
import 'package:pets/features/Sell/controller/Sell_Page_Controller.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/models/BuyRequestModel.dart';
import 'package:pets/utils/colors.dart';

class BuyRequest extends ConsumerStatefulWidget {
  const BuyRequest({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BuyRequestState();
}

class _BuyRequestState extends ConsumerState<BuyRequest> {
  @override
  void initState() {
    super.initState();
    ref.read(imagePickerControllerProvider.notifier).getAllBuyRequests();
    _getCategories();
  }

  void _getCategories() async {
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: secondaryLightColor,
        title: const ResponsiveText(
          text: "Requests for Buying",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(top: 18.0, bottom: 15, right: 20, left: 20),
              child: Center(
                child: Text(
                  "After you sell your animal, delete the sell request.",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
            ref.watch(getAllBuyRequestsFutureProvider).when(
                  data: (data) {
                    if (data!.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () =>
                                _showOptionsDialog(context, data[index]),
                            child: _buildBuyRequestCard(data[index]),
                          );
                        },
                      );
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
                  error: (e, st) =>
                      Center(child: Text("Error: ${e.toString()}")),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: primaryAccent),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuyRequestCard(BuyRequestModel request) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: heights(context, 80),
      decoration: BoxDecoration(
        color: secondaryLightColor4,
        borderRadius: BorderRadius.circular(15),
      ),
      width: MediaQuery.of(context).size.width - 60,
      child: ref.watch(getItemFutureProvider(request.petid)).when(
            data: (values) {
              if (values != null) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      "assets/images/${values.category}.png",
                      height: 60,
                      width: 60,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ResponsiveText(
                          text: values.name,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.currency_rupee_rounded),
                            Text(values.price.toString()),
                          ],
                        ),
                      ],
                    ),
                    ref
                        .watch(
                            getCustomerInfoFutureProvider(request.requesterUID))
                        .when(
                          data: (customer) {
                            if (customer != null) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ResponsiveText(
                                    text: customer.name,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  ResponsiveText(
                                    text: request.phoneNumber,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                          error: (error, st) => Container(),
                          loading: () => const Center(
                            child:
                                CircularProgressIndicator(color: primaryAccent),
                          ),
                        ),
                  ],
                );
              } else {
                return Container();
              }
            },
            error: (error, st) => Container(),
            loading: () => const Center(
              child: CircularProgressIndicator(color: primaryAccent),
            ),
          ),
    );
  }

  void _showOptionsDialog(BuildContext context, BuyRequestModel request) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Select an option"),
        actions: <Widget>[
          Column(
            children: [
              TextButton(
                onPressed: () async {
                  await FlutterPhoneDirectCaller.callNumber(
                      request.phoneNumber);
                  Navigator.of(ctx).pop();
                },
                child: _buildDialogButton("Call this request"),
              ),
              TextButton(
                onPressed: () async {
                  await ref
                      .read(authControllerProvider.notifier)
                      .updateStock2(request.petid, context);
                  await ref
                      .read(imagePickerControllerProvider.notifier)
                      .removeItem2(
                        request.petid + request.ownersUID,
                        ref,
                      );
                  ref.refresh(getAllBuyRequestsFutureProvider);
                  Navigator.of(ctx).pop();
                },
                child: _buildDialogButton("Delete This Request"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDialogButton(String text) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
      padding: const EdgeInsets.all(14),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
