import 'package:cloud_firestore/cloud_firestore.dart';

class ApiUrl {
  const ApiUrl._();

  static const baseUrl = "https://....com/api/v1";
  // static const anilistApiUrl = "https://graphql.anilist.co";

  // static const products = "/products";
  static final posts = FirebaseFirestore.instance.collection("posts");
  static final users = FirebaseFirestore.instance.collection("users");
  // static final animeCollection = FirebaseFirestore.instance.collection("animeCollection");
}
