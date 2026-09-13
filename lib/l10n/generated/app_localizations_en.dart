// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Clean Architecture Template';

  @override
  String get postsTitle => 'Posts';

  @override
  String get postDetailsTitle => 'Post';

  @override
  String get searchPostsHint => 'Search posts';

  @override
  String get noPostsYet => 'No posts yet.';

  @override
  String get noPostsFound => 'No posts match your search.';

  @override
  String writtenBy(String name) {
    return 'Written by $name';
  }

  @override
  String likesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count likes',
      one: '1 like',
    );
    return '$_temp0';
  }

  @override
  String get retry => 'Retry';

  @override
  String get pageNotFound => 'Page not found.';

  @override
  String get goHome => 'Go to home';

  @override
  String get toggleTheme => 'Toggle theme';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to read the posts.';

  @override
  String get usernameLabel => 'Username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signInButton => 'Sign in';

  @override
  String get useDemoAccount => 'Use demo account';

  @override
  String get signOut => 'Sign out';

  @override
  String get fieldRequired => 'This field is required.';

  @override
  String get errorNoConnection =>
      'No internet connection. Check your network and try again.';

  @override
  String get errorTimeout => 'The server took too long to respond. Try again.';

  @override
  String get errorServer =>
      'The server couldn\'t handle the request. Try again later.';

  @override
  String get errorSessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get errorInvalidCredentials => 'Wrong username or password.';

  @override
  String get errorStorage => 'Couldn\'t access data saved on this device.';

  @override
  String get errorUnexpected => 'Something went wrong. Try again.';
}
