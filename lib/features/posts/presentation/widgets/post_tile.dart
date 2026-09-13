import 'package:clean_architecture_template/features/posts/domain/post.dart';
import 'package:clean_architecture_template/shared/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  const new({required this.post, required this.onTap, super.key});

  final Post post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.title, maxLines: 1, overflow: .ellipsis),
      subtitle: Text(
        post.body,
        maxLines: 2,
        overflow: .ellipsis,
        style: TextStyle(color: context.colors.subtleText),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
