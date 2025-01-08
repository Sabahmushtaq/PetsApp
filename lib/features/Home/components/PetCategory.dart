import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets/core/Responsive_text.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/features/Home/screens/category_items.dart';

class Petcategory extends ConsumerStatefulWidget {
  final String animal;
  const Petcategory({super.key, required this.animal});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PetcategoryState();
}

class _PetcategoryState extends ConsumerState<Petcategory> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryItems(category: widget.animal)));
      },
      child: Container(
        margin: EdgeInsets.all(heights(context, 10)),
        // height: heights(context, 100), //127
        width: widths(context, 80),

        ///110
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Image.asset('assets/images/${widget.animal}.png'),
                ResponsiveText(
                  text: widget.animal,
                  style: const TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                )
              ],
            )),
      ),
    );
  }
}
