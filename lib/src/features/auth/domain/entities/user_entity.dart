import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String? username;
  final String? email;
  final String? password;
  final String? profileImage;

  const UserEntity({
    this.userId,
    this.username,
    this.email,
    this.password,
    this.profileImage,
  });

  @override
  List<Object?> get props => [
    userId,
    username,
    email,
    password,
    profileImage,
  ];
}