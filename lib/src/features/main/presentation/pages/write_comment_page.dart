import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tp1_flutter/src/features/auth/domain/entities/user_entity.dart';

import '../../domain/entities/post_entity.dart';
import '../bloc/post_bloc.dart';

class WriteCommentPage extends StatefulWidget {
  final UserEntity user;
  final PostEntity post;
  final PostBloc postBloc;

  const WriteCommentPage({super.key, required this.user, required this.post, required this.postBloc});

  @override
  _WriteCommentPageState createState() => _WriteCommentPageState();
}

class _WriteCommentPageState extends State<WriteCommentPage> {
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
        title: const Text('Add Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('En réponse à', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(widget.post.content ?? '', style: const TextStyle(fontSize: 16.0)),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Comment Content',
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
                final newComment = PostEntity(
                  id: DateTime.now().toString(),
                  ownerId: widget.user.userId!,
                  content: _controller.text,
                  imagePaths: _imagePaths,
                  imageUrls: _imageUrls,
                  likes: const [],
                  commentIds: const [],
                );
                // context.read<PostBloc>().add(AddCommentEvent(widget.post, newComment));
                widget.postBloc.add(AddCommentEvent(widget.post, newComment));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}