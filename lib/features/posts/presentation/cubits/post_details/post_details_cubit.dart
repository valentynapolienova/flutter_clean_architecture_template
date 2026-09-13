import 'package:clean_architecture_template/core/cubit/emit_guard_mixin.dart';
import 'package:clean_architecture_template/core/errors/app_failure.dart';
import 'package:clean_architecture_template/features/posts/application/posts_service.dart';
import 'package:clean_architecture_template/features/posts/domain/post_details.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_details_state.dart';

class PostDetailsCubit extends Cubit<PostDetailsState> with EmitGuardMixin {
  new(this._service) : super(const PostDetailsInitial());

  final PostsService _service;

  Future<void> load(int postId) async {
    emit(const PostDetailsLoading());
    final result = await _service.getPostDetails(postId);
    emitIfOpen(
      result.when<PostDetailsState>(
        success: PostDetailsLoaded.new,
        failure: PostDetailsFailed.new,
      ),
    );
  }
}
