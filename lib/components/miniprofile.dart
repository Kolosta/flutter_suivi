import 'package:flutter/material.dart';
import 'package:tp1_flutter/models/user.dart';

class MiniProfile extends StatelessWidget {
  final User user;

  const MiniProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          child: ClipOval(
            child: FadeInImage(
              placeholder: const AssetImage('assets/default_avatar.jpg'),
              image: NetworkImage(user.avatar),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/default_avatar.jpg');
              },
              fit: BoxFit.cover,
              width: 40,
              height: 40,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          user.username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}