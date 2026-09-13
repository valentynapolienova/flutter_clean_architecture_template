import 'package:equatable/equatable.dart';

/// One page of a longer list and whether more pages follow.
final class PageSlice<T> extends Equatable {
  const new({required this.items, required this.hasMore});

  final List<T> items;
  final bool hasMore;

  @override
  List<Object?> get props => [items, hasMore];
}
