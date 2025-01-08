import 'package:flutter/material.dart';
import 'package:pets/core/dimensions.dart';
import 'package:pets/utils/colors.dart';
import 'package:string_validator/string_validator.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    this.conf = "",
    this.a = 50, //25,
    this.color = secondaryLightColor,
    this.keyboard = TextInputType.text,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    required this.onChanged,
    required this.con,
    Key? key,
  }) : super(key: key);
  final String conf;
  final int a;
  final TextInputType keyboard;
  final String hintText;
  final Color color;
  final IconData icon;
  final bool obscureText;
  final Function(String) onChanged;
  final TextEditingController con;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width / wid(context, 25),
          left: MediaQuery.of(context).size.width / wid(context, 25),
          bottom: MediaQuery.of(context).size.height / hei(context, 15)),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This Field is requried";
          }
          if (hintText == "Confirm Password") {
            if (value != conf) {
              return "Password didn't match";
            }
          }
          if (hintText == "Email") {
            if (!value.contains("@") && !value.contains(".com")) {
              return "Invalid Email";
            }
          }
          if (hintText == "Password") {
            if (value.length < 6) {
              return "Password should contain atleast 6 characters";
            }
          }

          if (hintText == "Price") {
            if (value.isAlphanumeric) {
              return "Price Field is badly formatted";
            }
          }
          return null;
        },
        maxLength: a,
        keyboardType: keyboard,
        controller: con,
        obscureText: obscureText,
        style: const TextStyle(
          fontFamily: "SF",
          color: primaryBgcolor,
          fontSize: 15.0,
        ),
        decoration: InputDecoration(
          counterText: "",
          contentPadding: const EdgeInsets.all(18.0),
          filled: true,
          fillColor: color,
          prefixIcon: Icon(
            icon,
            size: 24.0,
            color: Colors.black45,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: "SF",
            color: Colors.black45,
            fontSize: 15.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide(color: Colors.orange.shade100),
          ),
          errorStyle: const TextStyle(fontFamily: "SF"),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide(color: Colors.red.shade100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: const BorderSide(color: primaryBgcolor),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class CustomTextFieldUpload extends StatelessWidget {
  final TextEditingController textController;
  final IconData icon;
  const CustomTextFieldUpload({
    required this.textController,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width / wid(context, 25),
          left: MediaQuery.of(context).size.width / wid(context, 25),
          bottom: MediaQuery.of(context).size.height / hei(context, 15)),
      child: TextFormField(
        enabled: false,
        keyboardType: TextInputType.text,
        controller: textController,
        style: const TextStyle(
          fontFamily: "SF",
          color: primaryBgcolor,
          fontSize: 15.0,
        ),
        decoration: InputDecoration(
          counterText: "",
          contentPadding: const EdgeInsets.all(20.0),
          filled: true,
          fillColor: secondaryLightColor,
          prefixIcon: Icon(
            icon,
            size: 24.0,
            color: Colors.black45,
          ),
          hintStyle: const TextStyle(
            fontFamily: "SF",
            color: Colors.black45,
            fontSize: 15.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide(color: Colors.orange.shade100),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          errorStyle: const TextStyle(fontFamily: "SF"),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide(color: Colors.red.shade100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: const BorderSide(color: primaryBgcolor),
          ),
        ),
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    this.conf = "",
    this.a = 50,
    this.keyboard = TextInputType.text,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    required this.onChanged,
    required this.con,
    Key? key,
  }) : super(key: key);
  final String conf;
  final int a;
  final TextInputType keyboard;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Function(String) onChanged;
  final TextEditingController con;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width / wid(context, 25),
          left: MediaQuery.of(context).size.width / wid(context, 25),
          bottom: MediaQuery.of(context).size.height / hei(context, 15)),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This Field is requried";
          }
          if (hintText == "Confirm Password") {
            if (value != conf) {
              return "Password didn't match";
            }
          }
          if (hintText == "Email") {
            if (!value.contains("@") && !value.contains(".com")) {
              return "Invalid Email";
            }
          }
          if (hintText == "Password") {
            if (value.length < 6) {
              return "Password should contain atleast 6 characters";
            }
          }

          if (hintText == "Price") {
            if (value.isAlphanumeric) {
              return "Price Field is badly formatted";
            }
          }
          return null;
        },
        maxLength: a,
        keyboardType: keyboard,
        controller: con,
        obscureText: obscureText,
        style: const TextStyle(
          fontFamily: "SF",
          color: primaryBgcolor,
          fontSize: 15.0,
        ),
        decoration: InputDecoration(
          counterText: "",
          contentPadding: const EdgeInsets.all(18.0),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Hero(
            tag: "search",
            child: Icon(
              icon,
              size: 24.0,
              color: Colors.black45,
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: "SF",
            color: Colors.black45,
            fontSize: 15.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          errorStyle: const TextStyle(fontFamily: "SF"),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide(color: Colors.red.shade100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: const BorderSide(color: primaryBgcolor),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
