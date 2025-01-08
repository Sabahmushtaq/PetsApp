import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/Get_date.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/custom_textfield.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/core/providers.dart';
import 'package:pets/features/Home/screens/pet_details.dart';
import 'package:pets/features/Sell/controller/Sell_Page_Controller.dart';
import 'package:pets/features/auth/controller/auth_repo_controller.dart';
import 'package:pets/models/UploadDataModel.dart';
import 'package:pets/utils/colors.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:uuid/uuid.dart';

class SellPage extends ConsumerStatefulWidget {
  const SellPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SellPageState();
}

class _SellPageState extends ConsumerState<SellPage> {
  final name = TextEditingController();
  final breed = TextEditingController();
  final price = TextEditingController();
  final color = TextEditingController();
  UploadDataModel? selectedItem;

  String? selectedValue;
  String? vaccinated;
  String? email;
  String? userName;
  @override
  void initState() {
    super.initState();
    ref.read(imagePickerControllerProvider.notifier).getSellData();
    getCats();
    final user = ref.read(authControllerProvider.notifier).userData;

    email = user?.email ?? "";
    userName = user?.name ?? "";
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
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                                      PetDetails(petData: i)));
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                  i.rejected
                                      ? ElevatedButton(
                                          onPressed: () {
                                            String reason = '';
                                            try {
                                              List<String> wordlist =
                                                  i.breed.split(" ");
                                              reason = /*wordlist
                                                  .sublist(1, wordlist.length)
                                                  .join(" ");*/
                                                  i.reason ?? "";
                                            } catch (e) {
                                              reason = 'No reason Provided';
                                            }
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                backgroundColor:
                                                    Colors.blue[50],
                                                title: const Text(
                                                    "Reason of Rejection"),
                                                content: Text(reason),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.black,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              14),
                                                      child: const Text(
                                                        "OK",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: const Text("Rejected"))
                                      : i.verified && i.checked
                                          ? const ResponsiveText(
                                              text: "Verified",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 14,
                                              ),
                                            )
                                          : i.checked && !i.verified
                                              ? ElevatedButton(
                                                  onPressed: () {
                                                    Razorpay razorpay =
                                                        Razorpay();
                                                    double lowerBoundAmount =
                                                        i.price *
                                                            20.roundToDouble();

                                                    selectedItem = i;
                                                    var options = {
                                                      'key':
                                                          'rzp_test_LrECoAPyqNMxTT', //change
                                                      'amount':
                                                          lowerBoundAmount,
                                                      'name': userName,
                                                      'description':
                                                          'payment Recieved',
                                                      'retry': {
                                                        'enabled': true,
                                                        'max_count': 1
                                                      },
                                                      'send_sms_hash': true,
                                                      'prefill': {
                                                        'contact': '00000000',
                                                        'email': email
                                                      },
                                                      'external': {
                                                        'wallets': ['paytm']
                                                      }
                                                    };
                                                    razorpay.on(
                                                        Razorpay
                                                            .EVENT_PAYMENT_ERROR,
                                                        handlePaymentErrorResponse);
                                                    razorpay.on(
                                                        Razorpay
                                                            .EVENT_PAYMENT_SUCCESS,
                                                        handlePaymentSuccessResponse);
                                                    razorpay.on(
                                                        Razorpay
                                                            .EVENT_EXTERNAL_WALLET,
                                                        handleExternalWalletSelected);
                                                    razorpay.open(options);

                                                    // Optionally clear listeners after usage

                                                    // Handle the payment logic here
                                                    //   openCheckout(i);
                                                  },
                                                  child:
                                                      const Text("Do Payment"),
                                                )
                                              : const ResponsiveText(
                                                  text: "Not Verified",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14,
                                                  ),
                                                )
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
                  ))),
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
                      child: SingleChildScrollView(
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
                                      .read(imagePickerControllerProvider
                                          .notifier)
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                      .read(imagePickerControllerProvider
                                          .notifier)
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
                                    showSnackbar(context,
                                        "Please select a valid price.");
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
                                                verified: false,
                                                rejected: false,
                                                checked: false,
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

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    ref.read(authControllerProvider.notifier).paidVerify(
          selectedItem!,
          context,
          ref,
        );
    setState(() {});
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    AnimatedSnackBar.material(
            "Exteral Wallet Selected", //Display correct error message
            type: AnimatedSnackBarType.warning,
            animationDuration: const Duration(milliseconds: 300),
            mobilePositionSettings:
                const MobilePositionSettings(topOnAppearance: 100))
        .show(context);
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    AnimatedSnackBar.material("Payment Failed", //Display correct error message
            type: AnimatedSnackBarType.warning,
            animationDuration: const Duration(milliseconds: 300),
            mobilePositionSettings:
                const MobilePositionSettings(topOnAppearance: 100))
        .show(context);
  }
}
