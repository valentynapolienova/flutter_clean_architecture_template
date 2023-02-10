import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

extension DoubleExtension on double {
  String get decimalZeroFormat {
    return this.toStringAsFixed(this.truncateToDouble() == this ? 0 : 1);
  }
}

extension CapExtension on String {
  String get capitalize => isEmpty
      ? ""
      : "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";

  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';

  String get capitalizeFirstOfEach =>
      this.split(" ").map((str) => str.capitalize).join(" ");
}

extension ConversionExt on String {
  double toDoubleIncludingInt() {
    return (double.tryParse(this) ?? int.tryParse(this)?.toDouble() ?? 0);
  }
}

extension LinearGradientExtension on LinearGradient {
  LinearGradient copyWith({
    Alignment? begin,
    Alignment? end,
  }) {
    return LinearGradient(
        begin: begin ?? this.begin,
        end: end ?? this.end,
        colors: this.colors,
        stops: this.stops,
        tileMode: this.tileMode);
  }

  LinearGradient get rotation90 {
    return LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: this.colors,
      stops: this.stops,
      tileMode: this.tileMode,
    );
  }

  LinearGradient get rotation180 {
    return LinearGradient(
      begin: end,
      end: begin,
      colors: this.colors,
      stops: this.stops,
      tileMode: this.tileMode,
    );
  }

  LinearGradient get rotation270 {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: this.colors,
      stops: this.stops,
      tileMode: this.tileMode,
    );
  }
}

extension PaddingsExt on EdgeInsets {
  EdgeInsets overrideZeros(EdgeInsets other) {
    final top = this.top == 0 ? other.top : this.top;
    final bottom = this.bottom == 0 ? other.bottom : this.bottom;
    final left = this.left == 0 ? other.left : this.left;
    final right = this.right == 0 ? other.right : this.right;

    return EdgeInsets.only(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
    );
  }
}

extension DateTimeExt on DateTime {
  String toDateOnly() {
    initializeDateFormatting();
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(this);
  }

  DateTime zeroTime() {
    return DateTime(this.year, this.month, this.day);
  }
}
