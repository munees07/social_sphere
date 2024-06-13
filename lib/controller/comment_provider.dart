import 'package:flutter/material.dart';
import 'package:social_sphere/model/comment_model.dart';
import 'package:social_sphere/service/comment_service.dart';

class CommentProvider extends ChangeNotifier {
  CommentService service = CommentService();
  Stream<List<CommentModel>> getComments(String postId) {
    return service.getComments(postId);
  }

  Future<void> addComment(CommentModel comment) async {
    await service.addComment(comment);
  }
}
