import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp1_flutter/models/post.dart' as models;
import 'package:tp1_flutter/providers/post_provider.dart';
import 'package:tp1_flutter/providers/user_provider.dart';

class AddCommentPage extends StatelessWidget {
  final models.Post post;

  AddCommentPage({required this.post});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;

    TextEditingController commentController = TextEditingController();
    TextEditingController imageController = TextEditingController();
    ValueNotifier<String?> imageUrlNotifier = ValueNotifier<String?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Répondre'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 50.0, // Réduire la hauteur de l'AppBar
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'En réponse à ${post.owner.username}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(post.content ?? ''),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const Divider(color: Colors.grey, height: 10, thickness: 1, indent: 0, endIndent: 0,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    hintText: 'Entrez votre commentaire',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  expands: true,
                ),
              ),
            ),
            ValueListenableBuilder<String?>(
              valueListenable: imageUrlNotifier,
              builder: (context, imageUrl, child) {
                return imageUrl != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
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
                              },
                            ),
                          ],
                        ),
                      )
                    : Container();
              },
            ),
            //Ligne grise en dessous
            const Divider(color: Colors.grey, height: 0, thickness: 1, indent: 0, endIndent: 0,),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 50.0, // Réduire la hauteur de la BottomAppBar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: () {
                  // Logic to add image URL
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
                  if (commentController.text.isNotEmpty) {
                    postProvider.addComment(
                      post,
                      models.Post(
                        owner: currentUser!,
                        content: commentController.text,
                        image: imageController.text.isNotEmpty ? imageController.text : null,
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}