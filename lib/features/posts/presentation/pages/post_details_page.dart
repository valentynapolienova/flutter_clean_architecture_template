import 'package:clean_architecture_template/features/posts/presentation/cubits/post_details/post_details_cubit.dart';
import 'package:clean_architecture_template/shared/extensions/build_context_x.dart';
import 'package:clean_architecture_template/shared/theme/spacing.dart';
import 'package:clean_architecture_template/shared/widgets/error_view.dart';
import 'package:clean_architecture_template/shared/widgets/page_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailsPage extends StatelessWidget {
  const new({required this.postId, super.key});

  final int postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.postDetailsTitle)),
      body: BlocBuilder<PostDetailsCubit, PostDetailsState>(
        builder: (context, state) => switch (state) {
          PostDetailsInitial() || PostDetailsLoading() => const PageLoader(),
          PostDetailsFailed(:final failure) => ErrorView(
            failure: failure,
            onRetry: () => context.read<PostDetailsCubit>().load(postId),
          ),
          PostDetailsLoaded(:final details) => ListView(
            padding: const .all(Spacing.m),
            children: [
              Text(details.post.title, style: context.textTheme.headlineSmall),
              const SizedBox(height: Spacing.s),
              Text(
                context.l10n.writtenBy(details.author.fullName),
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.colors.subtleText,
                ),
              ),
              const SizedBox(height: Spacing.m),
              Text(details.post.body, style: context.textTheme.bodyLarge),
              const SizedBox(height: Spacing.m),
              Wrap(
                spacing: Spacing.s,
                runSpacing: Spacing.s,
                children: [
                  Chip(
                    avatar: const Icon(Icons.favorite_border, size: 18),
                    label: Text(context.l10n.likesCount(details.post.likes)),
                  ),
                  for (final tag in details.post.tags)
                    Chip(label: Text('#$tag')),
                ],
              ),
            ],
          ),
        },
      ),
    );
  }
}
