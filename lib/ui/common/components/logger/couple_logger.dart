import 'package:logger/logger.dart';

class CoupleLog {
  late Logger logger;

  static final CoupleLog _instance = CoupleLog._internal();

  factory CoupleLog() {
    return _instance;
  }

  d(String message) {
    logger.d(message);
  }

  i(String message) {
    logger.i(message);
  }

  e(String message) {
    logger.e(message);
  }

  CoupleLog._internal() {
    logger = Logger(printer: PrettyPrinter(methodCount: 0));
  }
}
