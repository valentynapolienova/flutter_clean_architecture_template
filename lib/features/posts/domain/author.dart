import 'package:equatable/equatable.dart';

final class Author extends Equatable {
  const new({required this.id, required this.fullName});

  final int id;
  final String fullName;

  @override
  List<Object?> get props => [id, fullName];
}
