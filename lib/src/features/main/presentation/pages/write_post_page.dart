import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tp1_flutter/src/features/auth/domain/entities/user_entity.dart';

import '../../domain/entities/post_entity.dart';
import '../../domain/entities/post_user_entity.dart';
import '../bloc/main/post_bloc.dart';

class WritePostPage extends StatefulWidget {
  final UserEntity user;
  final PostBloc postBloc;

  const WritePostPage({super.key, required this.user, required this.postBloc});

  @override
  _WritePostPageState createState() => _WritePostPageState();
}

class _WritePostPageState extends State<WritePostPage> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<String> _imagePaths = [];
  final List<String> _imageUrls = [];

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePaths.add(pickedFile.path);
      });
    }
  }

  void _addImageUrl() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController imageUrlController = TextEditingController();
        return AlertDialog(
          title: const Text('Enter Image URL'),
          content: TextField(
            controller: imageUrlController,
            decoration: const InputDecoration(
              hintText: 'Image URL',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (imageUrlController.text.isNotEmpty) {
                  setState(() {
                    _imageUrls.add(imageUrlController.text);
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Post Content',
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_imagePaths.isNotEmpty || _imageUrls.isNotEmpty)
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ..._imagePaths.map((path) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(File(path), height: 150),
                    )),
                    ..._imageUrls.map((url) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(url, height: 150),
                    )),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.add_link),
              onPressed: _addImageUrl,
            ),
            IconButton(
              icon: const Icon(Icons.photo_library),
              onPressed: () => _pickImage(context),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                final newPost = PostEntity(
                  id: DateTime.now().toString(),
                  owner: PostUserEntity(
                    userId: widget.user.userId!,
                  ),
                  content: _controller.text,
                  imagePaths: _imagePaths,
                  imageUrls: _imageUrls,
                  likes: const [],
                  commentIds: const [],
                );
                // context.read<PostBloc>().add(AddPostEvent(newPost));
                widget.postBloc.add(AddPostEvent(newPost));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}