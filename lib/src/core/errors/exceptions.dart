// class ServerException implements Exception {}

class ServerException implements Exception {
  final String message;

  ServerException([this.message = ""]); //Crochets pour le rendre optionnel

  @override
  String toString() {
    return "ServerException: $message";
  }
}

// class CacheException implements Exception {}

//CacheException with parameter
class CacheException implements Exception {
  final String message;

  CacheException([this.message = ""]);

  @override
  String toString() {
    return "CacheException: $message";
  }
}

class AuthException implements Exception {}

class EmptyException implements Exception {}

class DuplicateEmailException implements Exception {}

class TypeMismatchException implements Exception {
  final String message;

  TypeMismatchException([this.message = ""]);

  @override
  String toString() {
    return "TypeMismatchException: $message";
  }
}