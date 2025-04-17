class Validator {
  var kWhiteSpaceRegex = RegExp(r"\s");
  // var kSpecialCharRegex =
  //     RegExp(r"[^\u3131-\u3163\u318D\uac00-\ud7a3a-zA-Z0-9]");
  var kActualNumberRegex = RegExp(r'^\d{1,3}(\.\d{0,2})?$');

  static bool isValidEmail(String input) {
    RegExp pattern = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+(\.[a-zA-Z]+)+$");
    return pattern.hasMatch(input);
  }

  static bool validPasswordPattern(String input) {
    RegExp pattern = RegExp(
        r'^(?=.*[a-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,20}$');
    bool hasUppercase = input.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = input.contains(RegExp(r'[a-z]'));
    bool hasDigit = input.contains(RegExp(r'\d'));
    bool hasSpecial = input.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    return pattern.hasMatch(input) &&
        hasUppercase &&
        hasDigit &&
        hasSpecial &&
        hasLowercase;
    // return true;
  }

  static bool isValidPhone(String input) {
    RegExp pattern = RegExp(r'^010\d{8}$');

    return pattern.hasMatch(input);
  }
}
