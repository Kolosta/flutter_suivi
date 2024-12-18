
class AddCommentModel {
  final String postId;
  final String content;

  AddCommentModel({
    required this.postId,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'content': content,
    };
  }
}