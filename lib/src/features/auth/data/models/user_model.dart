import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String super.userId,
    required String super.email,
    required String super.username,
    super.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String userId) {
    return UserModel(
      userId: userId,
      email: json["email"] ?? "",
      username: json["username"] ?? "",
      profileImage: json['profileImage'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'username': username,
      'profileImage': profileImage,
    };
  }
}
