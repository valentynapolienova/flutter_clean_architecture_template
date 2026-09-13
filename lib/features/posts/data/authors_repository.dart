import 'package:clean_architecture_template/core/network/api_client.dart';
import 'package:clean_architecture_template/features/posts/data/dto/author_dto.dart';
import 'package:clean_architecture_template/features/posts/domain/author.dart';

class AuthorsRepository {
  const new({required this.api});

  final ApiClient api;

  Future<Author> fetchAuthor(int authorId) async {
    final json = await api.getJson('/auth/users/$authorId');
    return AuthorDto.fromJson(json).toDomain();
  }
}
