/// Route paths. Parameterized locations have a builder method.
abstract final class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const posts = '/posts';
  static const postIdParam = 'postId';

  static String postDetails(int postId) => '$posts/$postId';
}
