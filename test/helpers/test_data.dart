import 'package:clean_architecture_template/features/auth/domain/auth_tokens.dart';
import 'package:clean_architecture_template/features/auth/domain/user.dart';
import 'package:clean_architecture_template/features/posts/domain/author.dart';
import 'package:clean_architecture_template/features/posts/domain/post.dart';
import 'package:clean_architecture_template/features/posts/domain/post_details.dart';

const testPost = Post(
  id: 1,
  authorId: 7,
  title: 'First post',
  body: 'Body 1',
  tags: ['history'],
  likes: 3,
);

const testSecondPost = Post(
  id: 2,
  authorId: 7,
  title: 'Second post',
  body: 'Body 2',
  tags: [],
  likes: 0,
);

const List<Post> testPosts = [testPost, testSecondPost];

const testAuthor = Author(id: 7, fullName: 'Ada Lovelace');

const testPostDetails = PostDetails(post: testPost, author: testAuthor);

const testUser = User(
  id: 1,
  username: 'emilys',
  fullName: 'Emily Johnson',
  email: 'emily@example.com',
);

const testTokens = AuthTokens(accessToken: 'access', refreshToken: 'refresh');
