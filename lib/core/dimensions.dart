import 'package:flutter/material.dart';

double wid(BuildContext context, double w) {
  return MediaQuery.of(context).size.width / w;
}

double hei(BuildContext context, double w) {
  return MediaQuery.of(context).size.height / w;
}

double heights(BuildContext context , double height)
{
  return MediaQuery.of(context).size.height / hei(context, height);
}

double widths(BuildContext context , double width)
{
  return MediaQuery.of(context).size.width / wid(context, width);
}