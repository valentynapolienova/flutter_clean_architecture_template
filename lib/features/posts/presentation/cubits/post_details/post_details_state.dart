part of 'post_details_cubit.dart';

sealed class PostDetailsState extends Equatable {
  const new();

  @override
  List<Object?> get props => [];
}

final class PostDetailsInitial extends PostDetailsState {
  const new();
}

final class PostDetailsLoading extends PostDetailsState {
  const new();
}

final class PostDetailsLoaded extends PostDetailsState {
  const new(this.details);

  final PostDetails details;

  @override
  List<Object?> get props => [details];
}

final class PostDetailsFailed extends PostDetailsState {
  const new(this.failure);

  final AppFailure failure;

  @override
  List<Object?> get props => [failure];
}
