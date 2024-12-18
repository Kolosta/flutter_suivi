import '../../domain/entities/user_entity.dart';

class RegisterModel extends UserEntity {
  const RegisterModel({
    required String username,
    required String email,
    required String password,
  }) : super(
    username: username,
    email: email,
    password: password,
  );

  RegisterModel copyWith({
    String? username,
    String? email,
    String? password,
  }) {
    return RegisterModel(
      username: username ?? (this.username ?? ""),
      email: email ?? (this.email ?? ""),
      password: password ?? (this.password ?? ""),
    );
  }

  /// Convert RegisterModel to a Map for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "email": email,
      // Note: Avoid storing password in plain text in Firestore for security reasons.
    };
  }

  /// Convert RegisterModel to JSON for use in APIs or local storage.
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "password": password, // Only include if necessary for a specific use case.
    };
  }

  /// Creates a RegisterModel from a JSON map.
  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      password: json["password"] ?? "",
    );
  }

  /// Creates a RegisterModel from Firestore data (Map).
  factory RegisterModel.fromMap(Map<String, dynamic> map) {
    return RegisterModel(
      username: map["username"] ?? "",
      email: map["email"] ?? "",
      password: map["password"] ?? "",
    );
  }
}



//
// class RegisterModel extends UserEntity {
//   const RegisterModel({
//     required String username,
//     required String email,
//     required String password,
//   }) : super(
//           username: username,
//           email: email,
//           password: password,
//         );
//
//   RegisterModel copyWith({
//     String? username,
//     String? email,
//     String? password,
//   }) {
//     return RegisterModel(
//       username: username ?? (this.username ?? ""),
//       email: email ?? (this.email ?? ""),
//       password: password ?? (this.password ?? ""),
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       "username": username,
//       "email": email,
//       "password": password,
//     };
//   }
// }


