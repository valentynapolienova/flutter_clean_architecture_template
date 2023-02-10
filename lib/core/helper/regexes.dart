abstract class Regexes {
  static final RegExp isEmail =
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}");
  static final RegExp onlyNumber = RegExp('[0-9]');
  static final RegExp onlyNumberAndPlusSign = RegExp('[0-9+]');
  static final RegExp onlyCapitalLetter = RegExp('[A-Z]');
}
