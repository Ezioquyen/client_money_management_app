class AppExceptions implements Exception {
  final _message;
  final _prefix;

  AppExceptions([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix $_message";
  }
}

class InternetExceptions extends AppExceptions {
  InternetExceptions([String? message]) : super(message, "No Internet");
}

class TimeOutExceptions extends AppExceptions {
  TimeOutExceptions([String? message]) : super(message, "Request Time out");
}

class ServerExceptions extends AppExceptions {
  ServerExceptions([String? message])
      : super(message, "Internal server exception");
}

class FetchDataExceptions extends AppExceptions {
  FetchDataExceptions([String? message])
      : super(message, "Fetch data exception");
}