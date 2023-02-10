import 'package:clean_architecture_template/core/style/text_styles.dart';
import 'package:clean_architecture_template/core/util/pixel_sizer.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'input_borders.dart';

BaseInputDecoration get cOutlineInputDecoration =>
    CustomOutlineInputDecoration();

class CustomOutlineInputDecoration extends BaseInputDecoration {
  CustomOutlineInputDecoration()
      : super(
          textStyle: font.black.s12.w500,
          border: COutlineInputBorders.inactiveTextField,
          enabledBorder: COutlineInputBorders.inactiveTextField,
          focusedBorder: COutlineInputBorders.activeTextField,
          filled: true,
          fillColor: CColors.white,
          hintStyle: font.black.s14.w500,
        );
}

enum ContentPaddingType { h38vAuto, h16vAuto, h5, vAuto, zero, custom }

class BaseInputDecoration extends InputDecoration {
  static const _textHeight = 1.25;

  @override
  EdgeInsetsGeometry? contentPadding;

  double? fieldHeight;
  TextStyle textStyle;
  ContentPaddingType contentPaddingType;

  BaseInputDecoration({
    double? fieldHeight,
    this.contentPaddingType = ContentPaddingType.custom,
    required this.textStyle,
    super.icon,
    super.iconColor,
    super.label,
    super.labelText,
    super.labelStyle,
    super.floatingLabelStyle,
    super.helperText,
    super.helperStyle,
    super.helperMaxLines,
    super.hintText,
    super.hintStyle,
    super.hintTextDirection,
    super.hintMaxLines,
    super.errorText,
    super.errorStyle,
    super.errorMaxLines,
    super.floatingLabelBehavior,
    super.floatingLabelAlignment,
    super.isCollapsed = false,
    super.isDense,
    super.contentPadding,
    super.prefixIcon,
    super.prefixIconConstraints,
    super.prefix,
    super.prefixText,
    super.prefixStyle,
    super.prefixIconColor,
    super.suffixIcon,
    super.suffix,
    super.suffixText,
    super.suffixStyle,
    super.suffixIconColor,
    super.suffixIconConstraints,
    super.counter,
    super.counterText,
    super.counterStyle,
    super.filled,
    super.fillColor,
    super.focusColor,
    super.hoverColor,
    super.errorBorder,
    super.focusedBorder,
    super.focusedErrorBorder,
    super.disabledBorder,
    super.enabledBorder,
    super.border,
    super.enabled = true,
    super.semanticCounterText,
    super.alignLabelWithHint,
    super.constraints,
  }) {
    this.fieldHeight = fieldHeight ?? 58.ph;

    switch (contentPaddingType) {
      case ContentPaddingType.custom:
        contentPadding = contentPadding;
        break;
      case ContentPaddingType.h38vAuto:
        contentPadding =
            EdgeInsets.fromLTRB(38.pw, topPadding, 38.pw, bottomPadding);
        break;
      case ContentPaddingType.h16vAuto:
        contentPadding =
            EdgeInsets.fromLTRB(16.pw, topPadding, 38.pw, bottomPadding);
        break;
      case ContentPaddingType.vAuto:
        contentPadding =
            EdgeInsets.only(top: topPadding, bottom: bottomPadding);
        break;
      case ContentPaddingType.zero:
        contentPadding = EdgeInsets.zero;
        break;
      case ContentPaddingType.h5:
        contentPadding = EdgeInsets.symmetric(horizontal: 5.pw);
        break;
    }
  }

  double get topPadding =>
      (fieldHeight! - textStyle.fontSize! * _textHeight) * 7 / 10;

  double get bottomPadding =>
      (fieldHeight! - textStyle.fontSize! * _textHeight) * 3 / 10;

  BaseInputDecoration get errorMode => copyWith(
        border: COutlineInputBorders.errorTextField,
        enabledBorder: COutlineInputBorders.errorTextField,
        focusedBorder: COutlineInputBorders.errorTextField,
      );

  BaseInputDecoration customHeight({required double height}) =>
      copyWith(fieldHeight: height);

  BaseInputDecoration customTextStyle({required TextStyle style}) =>
      copyWith(textStyle: style);

  BaseInputDecoration withPrefixIcon({required Widget icon}) =>
      copyWith(prefixIcon: icon);

  @override
  BaseInputDecoration copyWith({
    ContentPaddingType? contentPaddingType,
    bool? withContentPadding,
    double? fieldHeight,
    TextStyle? textStyle,
    Widget? icon,
    Color? iconColor,
    Widget? label,
    String? labelText,
    TextStyle? labelStyle,
    TextStyle? floatingLabelStyle,
    String? helperText,
    TextStyle? helperStyle,
    int? helperMaxLines,
    String? hintText,
    TextStyle? hintStyle,
    TextDirection? hintTextDirection,
    int? hintMaxLines,
    String? errorText,
    TextStyle? errorStyle,
    int? errorMaxLines,
    FloatingLabelBehavior? floatingLabelBehavior,
    FloatingLabelAlignment? floatingLabelAlignment,
    bool? isCollapsed,
    bool? isDense,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixIcon,
    Widget? prefix,
    String? prefixText,
    BoxConstraints? prefixIconConstraints,
    TextStyle? prefixStyle,
    Color? prefixIconColor,
    Widget? suffixIcon,
    Widget? suffix,
    String? suffixText,
    TextStyle? suffixStyle,
    Color? suffixIconColor,
    BoxConstraints? suffixIconConstraints,
    Widget? counter,
    String? counterText,
    TextStyle? counterStyle,
    bool? filled,
    Color? fillColor,
    Color? focusColor,
    Color? hoverColor,
    InputBorder? errorBorder,
    InputBorder? focusedBorder,
    InputBorder? focusedErrorBorder,
    InputBorder? disabledBorder,
    InputBorder? enabledBorder,
    InputBorder? border,
    bool? enabled,
    String? semanticCounterText,
    bool? alignLabelWithHint,
    BoxConstraints? constraints,
  }) {
    return BaseInputDecoration(
      contentPaddingType: contentPaddingType ?? this.contentPaddingType,
      fieldHeight: fieldHeight ?? this.fieldHeight,
      textStyle: textStyle ?? this.textStyle,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      label: label ?? this.label,
      labelText: labelText ?? this.labelText,
      labelStyle: labelStyle ?? this.labelStyle,
      floatingLabelStyle: floatingLabelStyle ?? this.floatingLabelStyle,
      helperText: helperText ?? this.helperText,
      helperStyle: helperStyle ?? this.helperStyle,
      helperMaxLines: helperMaxLines ?? this.helperMaxLines,
      hintText: hintText ?? this.hintText,
      hintStyle: hintStyle ?? this.hintStyle,
      hintTextDirection: hintTextDirection ?? this.hintTextDirection,
      hintMaxLines: hintMaxLines ?? this.hintMaxLines,
      errorText: errorText ?? this.errorText,
      errorStyle: errorStyle ?? this.errorStyle,
      errorMaxLines: errorMaxLines ?? this.errorMaxLines,
      floatingLabelBehavior:
          floatingLabelBehavior ?? this.floatingLabelBehavior,
      floatingLabelAlignment:
          floatingLabelAlignment ?? this.floatingLabelAlignment,
      isCollapsed: isCollapsed ?? this.isCollapsed,
      isDense: isDense ?? this.isDense,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      prefix: prefix ?? this.prefix,
      prefixText: prefixText ?? this.prefixText,
      prefixStyle: prefixStyle ?? this.prefixStyle,
      prefixIconColor: prefixIconColor ?? this.prefixIconColor,
      prefixIconConstraints:
          prefixIconConstraints ?? this.prefixIconConstraints,
      suffixIcon: suffixIcon ?? this.suffixIcon,
      suffix: suffix ?? this.suffix,
      suffixText: suffixText ?? this.suffixText,
      suffixStyle: suffixStyle ?? this.suffixStyle,
      suffixIconColor: suffixIconColor ?? this.suffixIconColor,
      suffixIconConstraints:
          suffixIconConstraints ?? this.suffixIconConstraints,
      counter: counter ?? this.counter,
      counterText: counterText ?? this.counterText,
      counterStyle: counterStyle ?? this.counterStyle,
      filled: filled ?? this.filled,
      fillColor: fillColor ?? this.fillColor,
      focusColor: focusColor ?? this.focusColor,
      hoverColor: hoverColor ?? this.hoverColor,
      errorBorder: errorBorder ?? this.errorBorder,
      focusedBorder: focusedBorder ?? this.focusedBorder,
      focusedErrorBorder: focusedErrorBorder ?? this.focusedErrorBorder,
      disabledBorder: disabledBorder ?? this.disabledBorder,
      enabledBorder: enabledBorder ?? this.enabledBorder,
      border: border ?? this.border,
      enabled: enabled ?? this.enabled,
      semanticCounterText: semanticCounterText ?? this.semanticCounterText,
      alignLabelWithHint: alignLabelWithHint ?? this.alignLabelWithHint,
      constraints: constraints ?? this.constraints,
    );
  }
}
