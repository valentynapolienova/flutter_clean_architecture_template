import 'package:flutter/material.dart';
import 'colors.dart';
import 'border_radiuses.dart';

abstract class COutlineInputBorders {
  static const activeTextField = OutlineInputBorder(
    borderRadius: CBorderRadius.all10,
    borderSide: BorderSide(color: CColors.black),
  );

  static const inactiveTextField = OutlineInputBorder(
    borderRadius: CBorderRadius.all10,
    borderSide: BorderSide(color: CColors.black),
  );

  static const errorTextField = OutlineInputBorder(
    borderRadius: CBorderRadius.all10,
    borderSide: BorderSide(color: CColors.black),
  );
}
