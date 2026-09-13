import 'package:clean_architecture_template/l10n/generated/app_localizations.dart';
import 'package:clean_architecture_template/shared/errors/app_failure.dart';

extension FailureMessage on AppFailure {
  /// A short explanation for the user, in their language.
  String toMessage(AppLocalizations l10n) => switch (this) {
    NoConnectionFailure() => l10n.errorNoConnection,
    TimeoutFailure() => l10n.errorTimeout,
    ServerFailure() => l10n.errorServer,
    UnauthorizedFailure() => l10n.errorSessionExpired,
    InvalidCredentialsFailure() => l10n.errorInvalidCredentials,
    StorageFailure() => l10n.errorStorage,
    UnexpectedFailure() => l10n.errorUnexpected,
  };
}
