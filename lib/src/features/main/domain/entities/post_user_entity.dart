import 'package:equatable/equatable.dart';

class PostUserEntity extends Equatable {
  final String userId;
  final String? username;
  final String? email;
  final String? profileImage;

  const PostUserEntity({
    required this.userId,
    this.username,
    this.email,
    this.profileImage,
  });

  @override
  List<Object?> get props => [
    userId,
    username,
    email,
    profileImage,
  ];

  PostUserEntity copyWith({
    String? userId,
    String? username,
    String? email,
    String? profileImage,
  }) {
    return PostUserEntity(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}