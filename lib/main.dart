import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp1_flutter/models/post.dart';
import 'package:tp1_flutter/models/user.dart';
import 'package:tp1_flutter/pages/home.dart';
import 'package:tp1_flutter/providers/post_provider.dart';
import 'package:tp1_flutter/providers/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    //TODO : faire un systeme de login pour supprimer ça
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).setCurrentUser(
        // User(username: 'current_user', avatar: 'https://encrypted-tbn0SIrx3nVQ&s'), //Case where the image is not found, bad url
        // User(username: 'current_user', avatar: ''), //Case where the image is not found, empty url
        User(username: 'current_user', avatar: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyIxAp9lLLNt0nSzzs2uCR6w_6N4SIrx3nVQ&s'), //Case where the image is found
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Fundamentals',
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}