extension StringExtension on String {
  bool isValidEmailFormat() => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(this);

  bool hasNumbers() => RegExp(r"^(?=.*?[0-9])").hasMatch(this);

  bool hasLowercaseChars() => RegExp(r"^(?=.*?[a-z])").hasMatch(this);

  bool hasUppercaseChars() => RegExp(r"^(?=.*?[A-Z])").hasMatch(this);

  bool hasSpecialChars() => RegExp(r"^(?=.*?[!@#\$&*~])").hasMatch(this);

  // bool hasNumbers() => RegExp(r"^(?=.*?[0-9])").hasMatch(this);

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
