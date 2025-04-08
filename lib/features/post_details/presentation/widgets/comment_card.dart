import 'package:flutter/material.dart';
import 'package:practice_project/features/post_details/data/model/comment_model.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.comment});
  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.black45, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text(
            comment.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
          ),
          Text(
            comment.body,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
