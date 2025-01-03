// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, annotate_overrides

class AppException implements Exception {
  final _message;
  final _prefix;
  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class fetchDataException extends AppException {
  fetchDataException([String? message])
      : super(message, "Error During Communication");
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, "Invalid request");
}

class UnutherozidRequestException extends AppException {
  UnutherozidRequestException([String? message])
      : super(message, "Unutherised requrest");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid input");
}
