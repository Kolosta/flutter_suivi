import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp1_flutter/components/post.dart';
import 'package:tp1_flutter/providers/post_provider.dart';
import 'package:tp1_flutter/providers/user_provider.dart';
import 'package:tp1_flutter/models/post.dart' as models;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController contentController = TextEditingController();
    TextEditingController imageController = TextEditingController();
    ValueNotifier<String?> imageUrlNotifier = ValueNotifier<String?>(null);

    imageController.addListener(() {
      if (imageController.text.isEmpty) {
        imageUrlNotifier.value = null;
      } else {
        imageUrlNotifier.value = imageController.text;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Whooo ! Le TP1'),
      ),
      backgroundColor: Colors.white, // Set background color to light gray
      body: Column(
        children: [
          Expanded(
            child: Consumer<PostProvider>(
              builder: (context, postProvider, child) {
                return ListView.builder(
                  itemCount: postProvider.posts.length,
                  itemBuilder: (context, index) {
                    final post = postProvider.posts[index];
                    return Column(
                      children: [
                        Post(post: post),
                        (index != postProvider.posts.length - 1)
                            ? Container(
                          color: Colors.grey[100],
                          height: 10,
                        )
                            : Container(
                          color: Colors.white,
                          height: 10,
                          // child: const Divider(color: Colors.grey, height: 0, thickness: 1, indent: 0, endIndent: 0,),
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
          const Divider(color: Colors.grey, height: 0, thickness: 1, indent: 0, endIndent: 0,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ValueListenableBuilder<String?>(
                  valueListenable: imageUrlNotifier,
                  builder: (context, imageUrl, child) {
                    return imageUrl != null
                        ? Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 120,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8), // Small rounded corners on the image
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              imageUrlNotifier.value = null;
                              imageController.clear();
                            },
                          ),
                        ],
                      ),
                    )
                        : Container();
                  },
                ),
                Row(
                  children: [
                   Expanded(
                      child: TextField(
                        controller: contentController,
                        decoration: const InputDecoration(
                          hintText: 'Nouveau post',
                          border: InputBorder.none, // Remove the border
                          contentPadding: EdgeInsets.symmetric(horizontal: 10), // Add padding to match the app's style
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(imageUrlNotifier.value != null ? Icons.edit : Icons.add),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8), // Moins d'arrondis sur les angles
                              ),
                              title: const Text(
                                'Ajouter une URL d\'image',
                                style: TextStyle(color: Colors.black), // Suivre le thème du reste de l'appli
                              ),
                              content: TextField(
                                controller: imageController,
                                decoration: const InputDecoration(
                                  hintText: 'Entrez l\'URL de l\'image',
                                  hintStyle: TextStyle(color: Colors.grey), // Suivre le thème du reste de l'appli
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Annuler',
                                    style: TextStyle(color: Colors.blue), // Suivre le thème du reste de l'appli
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    imageUrlNotifier.value = imageController.text;
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Ajouter',
                                    style: TextStyle(color: Colors.blue), // Suivre le thème du reste de l'appli
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        final currentUser = Provider.of<UserProvider>(context, listen: false).currentUser;
                        if (currentUser != null && contentController.text.isNotEmpty) {
                          Provider.of<PostProvider>(context, listen: false).addPost(
                            models.Post(
                              owner: currentUser,
                              content: contentController.text,
                              image: imageController.text.isNotEmpty ? imageController.text : null,
                            ),
                          );
                          contentController.clear();
                          imageController.clear();
                          imageUrlNotifier.value = null;
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}