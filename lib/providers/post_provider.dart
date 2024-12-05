import 'package:flutter/material.dart';
import 'package:tp1_flutter/models/post.dart';
import 'package:tp1_flutter/models/user.dart';

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];

  List<Post> get posts => _posts;

  void addPost(Post post) {
    _posts.add(post);
    notifyListeners();
  }

  void likePost(Post post, User user) {
    if (post.likes.contains(user)) {
      post.likes = List.from(post.likes)..remove(user);
      print('User ${user.username} unliked post by ${post.owner.username}');
    } else {
      post.likes = List.from(post.likes)..add(user);
      print('User ${user.username} liked post by ${post.owner.username}');
    }
    notifyListeners();
  }

  void addComment(Post post, Post comment) {
    post.comments = List.from(post.comments)..add(comment);
    notifyListeners();
  }
}