import 'package:flutter/material.dart';

void showNoInternetPopUp(BuildContext context, Widget popUp) {
  showDialog(
    context: context,
    builder: (_) => popUp,
  );
}
