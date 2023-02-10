import 'dart:ui';

import 'package:flutter/material.dart';

import 'colors.dart';

const _fontFontName = 'font';

CTextStyle get font => const Font();

class Font extends CTextStyle {
  const Font()
      : super._(
          fontFamily: _fontFontName,
          fontSize: 14.0,
          //color: CColors.black,
          // height: 1.35,
        );
}

// Custom TextStyle
class CTextStyle extends TextStyle {
  const CTextStyle._({
    bool inherit = true,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    List<FontFeature>? fontFeatures,
    TextDecoration? decoration,
    Color? decorationColor,
    TextLeadingDistribution? leadingDistribution,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
  }) : super(
          inherit: inherit,
          color: color,
          backgroundColor: backgroundColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          leadingDistribution: leadingDistribution,
          textBaseline: textBaseline,
          height: height,
          locale: locale,
          foreground: foreground,
          background: background,
          shadows: shadows,
          fontFeatures: fontFeatures,
          decoration: decoration,
          decorationColor: decorationColor,
          decorationStyle: decorationStyle,
          decorationThickness: decorationThickness,
          debugLabel: debugLabel,
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          package: package,
        );

  // sizes
  CTextStyle get s8 => copyWith(fontSize: 8);

  CTextStyle get s9 => copyWith(fontSize: 9);

  CTextStyle get s10 => copyWith(fontSize: 10);

  CTextStyle get s11 => copyWith(fontSize: 11);

  CTextStyle get s12 => copyWith(fontSize: 12);

  CTextStyle get s13 => copyWith(fontSize: 13);

  CTextStyle get s14 => copyWith(fontSize: 14);

  CTextStyle get s15 => copyWith(fontSize: 15);

  CTextStyle get s16 => copyWith(fontSize: 16);

  CTextStyle get s18 => copyWith(fontSize: 18);

  CTextStyle get s20 => copyWith(fontSize: 20);

  CTextStyle get s22 => copyWith(fontSize: 22);

  CTextStyle get s24 => copyWith(fontSize: 24);

  CTextStyle get s26 => copyWith(fontSize: 26);

  CTextStyle get s30 => copyWith(fontSize: 30);

  CTextStyle get s32 => copyWith(fontSize: 32);

  CTextStyle get s36 => copyWith(fontSize: 36);

  CTextStyle get s52 => copyWith(fontSize: 52);

  // weights
  CTextStyle get w100 => copyWith(fontWeight: FontWeight.w100);

  CTextStyle get w300 => copyWith(fontWeight: FontWeight.w300);

  CTextStyle get w400 => copyWith(fontWeight: FontWeight.w400);

  CTextStyle get w500 => copyWith(fontWeight: FontWeight.w500);

  CTextStyle get w600 => copyWith(fontWeight: FontWeight.w600);

  CTextStyle get w700 => copyWith(fontWeight: FontWeight.w700);

  CTextStyle get w900 => copyWith(fontWeight: FontWeight.w900);

  // style
  CTextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  // colors
  CTextStyle get white => copyWith(color: CColors.white);

  CTextStyle get black => copyWith(color: CColors.black);

  // heights
  CTextStyle get h13 => copyWith(height: 1.35);

  CTextStyle get h10 => copyWith(height: 1);

  CTextStyle get h15 => copyWith(height: 1.5);

  CTextStyle get h35 => copyWith(height: 3.5);

  // shadows
  //CTextStyle get shadow => copyWith(shadows: CShadows.defaultShadow);

  // decoration
  CTextStyle get underline => copyWith(decoration: TextDecoration.underline);

  @override
  CTextStyle copyWith(
      {bool? inherit,
      Color? color,
      Color? backgroundColor,
      double? fontSize,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      double? letterSpacing,
      double? wordSpacing,
      TextBaseline? textBaseline,
      double? height,
      TextLeadingDistribution? leadingDistribution,
      Locale? locale,
      Paint? foreground,
      Paint? background,
      List<Shadow>? shadows,
      List<FontFeature>? fontFeatures,
      List<FontVariation>? fontVariations,
      TextDecoration? decoration,
      Color? decorationColor,
      TextDecorationStyle? decorationStyle,
      double? decorationThickness,
      String? debugLabel,
      String? fontFamily,
      List<String>? fontFamilyFallback,
      String? package,
      TextOverflow? overflow}) {
    return CTextStyle._(
      inherit: inherit ?? this.inherit,
      color: this.foreground == null && foreground == null
          ? color ?? this.color
          : null,
      backgroundColor: this.background == null && background == null
          ? backgroundColor ?? this.backgroundColor
          : null,
      fontFamily: fontFamily ?? this.fontFamily,
      fontFamilyFallback: fontFamilyFallback ?? this.fontFamilyFallback,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      fontStyle: fontStyle ?? this.fontStyle,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      wordSpacing: wordSpacing ?? this.wordSpacing,
      textBaseline: textBaseline ?? this.textBaseline,
      height: height ?? this.height,
      locale: locale ?? this.locale,
      foreground: foreground ?? this.foreground,
      background: background ?? this.background,
      shadows: shadows ?? this.shadows,
      fontFeatures: fontFeatures ?? this.fontFeatures,
      decoration: decoration ?? this.decoration,
      decorationColor: decorationColor ?? this.decorationColor,
      decorationStyle: decorationStyle ?? this.decorationStyle,
      decorationThickness: decorationThickness ?? this.decorationThickness,
    );
  }
}
