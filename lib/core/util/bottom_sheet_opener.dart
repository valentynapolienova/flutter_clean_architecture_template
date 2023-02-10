import 'package:flutter/material.dart';

void showCustomBottomSheet(BuildContext context, Widget bottomSheet) {
  showModalBottomSheet(
    barrierColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    context: context,
    builder: (_) => bottomSheet,
  );
}
