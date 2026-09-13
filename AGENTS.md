# AGENTS.md

This guide is for AI coding agents working in this repository. Human-oriented documentation lives in [README.md](README.md).

## 1. Snapshot

| Topic | Choice |
|---|---|
| SDK | Flutter 3.47.2 (`.fvmrc`), Dart ^3.13. Prefix commands with `fvm` when FVM is installed. |
| State | `flutter_bloc`, Cubits only |
| Dependency injection | `get_it`, instance `sl` in `lib/app/di/service_locator.dart` |
| Navigation | `go_router`, built by `createRouter` in `lib/app/router/app_router.dart` |
| Network | `dio`, wrapped by `ApiClient` in `lib/shared/network/` |
| Device storage | `shared_preferences` (settings), `flutter_secure_storage` (tokens) |
| Strings | `gen-l10n` from `lib/l10n/app_en.arb` → `lib/l10n/generated/` |
| Logging | `AppLogger` (`lib/shared/logging/`) on `dart:developer` |
| Tests | `flutter_test`, `bloc_test`, `mocktail`, `fake_async` |
| Lints | `very_good_analysis` 11, `bloc_lint` |

- **Run:** `flutter run -t lib/main_dev.dart --dart-define-from-file=env/dev.json`
- **Example backend:** DummyJSON. The demo login is `emilys` / `emilyspass`.
- **Reference implementations:**
  - `lib/features/posts/`: a paged, searchable list and a detail screen that combines two repositories.
  - `lib/features/auth/`: a login form, an app-wide session and token refresh.

## 2. Ground rules

- **Start from an example.** Find the closest file in `features/posts` or `features/auth`, read it and its test, and make the new code look like it belongs next to them.
- **Stay in scope.** Keep the change to what the task asks for. Renames, reformatting or refactors of unrelated code belong in their own task.
- **Dot shorthands.** Use them wherever the type can be inferred: `.center`, `const .all(Spacing.m)`, `.dev`.
- **Dependencies.** Don't touch the `pubspec.yaml` dependencies unless the task is about them.
- **Generated code.** Never edit `lib/l10n/generated/`. Edit `app_en.arb` and run `flutter gen-l10n`.
- **Configuration.** URLs, keys and other per-environment values go through `AppConfig` (§10), never as literals in code.
- **User-facing text** comes only from the ARB file.

## 3. Where things live

```
lib/
├── main_<env>.dart
├── app/                         # composition root; may import anything
│   ├── app.dart                 # MaterialApp.router
│   ├── bootstrap.dart           # startup sequence, uncaught-error capture
│   ├── config/app_config.dart   # Environment, AppConfig
│   ├── di/service_locator.dart  # sl, registerDependencies, _registerX per area
│   └── router/                  # app_router.dart, routes.dart, stream_listenable.dart
├── shared/                      # never imports app/ or features/
│   ├── cubit/                   # EmitGuardMixin, DebounceMixin, PagingMixin
│   ├── errors/app_failure.dart
│   ├── extensions/              # BuildContextX (l10n, theme), FailureMessage
│   ├── logging/app_logger.dart
│   ├── network/                 # ApiClient, AuthInterceptor
│   ├── result/                  # Failable, PageSlice, RepositoryRequestHandler
│   ├── storage/                 # interfaces + implementations, guardStorage
│   ├── theme/                   # AppTheme, AppColors, Spacing, ThemeCubit
│   └── widgets/                 # ErrorView, PageLoader, NotFoundPage, ThemeModeButton
├── features/<feature>/
│   ├── domain/                  # <model>.dart
│   ├── data/                    # <x>_repository.dart, dto/<x>_dto.dart
│   ├── application/             # <x>_service.dart
│   └── presentation/
│       ├── cubits/<name>/       # <name>_cubit.dart + <name>_state.dart (part)
│       ├── pages/               # <name>_page.dart
│       └── widgets/
└── l10n/app_en.arb
```

Import boundaries:
- `shared/` stays feature-agnostic.
- A feature may import another feature's `domain/` and `presentation/widgets/`, for example `SignOutButton` in `PostsPage`, but never another feature's `data/`, `application/` or cubits.
- Pages may import `app/router/routes.dart` for route paths.

## 4. Layer contracts

```
Page ─▶ Cubit ─▶ Service ─▶ Repository ─▶ ApiClient / storage
          └─────────┴───────────┴──▶ domain models
```

| Layer | Contains | Produces | Must not |
|---|---|---|---|
| domain | immutable models | — | import Flutter, Dio, JSON code or other layers |
| data | repositories, DTOs | domain models; throws `AppFailure` | return `Failable`, import widgets |
| application | services | `FutureFailable<T>` | import Flutter or Dio, throw |
| presentation | cubits, states, pages, widgets | UI | touch repositories, DTOs, storages or `sl` |

### 4.1 Domain
- Each model is a `final class` extending `Equatable`, with a `const` constructor and `final` fields. Every field appears in `props`.
- Names follow the app's vocabulary (`authorId`), not the API's (`userId`).

### 4.2 Data
- **Repositories** are named `XRepository` and take named required dependencies (`ApiClient`, storages). Methods are named `fetchX`, `createX`, `updateX`, `deleteX`.
- **Calling the API:** use `api.getJson` / `getJsonList` / `postJson` / `putJson` / `patchJson` / `delete`, convert responses with a DTO's `toDomain()`, and return domain types.
- **Failures:** failures thrown by `ApiClient` pass through. Catch one only to give it a more specific meaning, as `AuthRepository.signIn` does when it maps a 400 to `InvalidCredentialsFailure`.
- **DTOs** are `final class XDto` in `data/dto/`, with `factory XDto.fromJson(Map<String, dynamic>)` using explicit casts and `toDomain()`. If a payload doesn't match, the cast throws a `TypeError`, which the request handler reports as `UnexpectedFailure`.
- **Storages** (`shared/storage/`): an `abstract interface class` plus an implementation that wraps each platform call in `guardStorage`. Keys are private constants in the implementation. Storages hold no logic.
- **Authentication:** requests that need a signed-in user use the default `ApiClient`. Only sign-in and token refresh use `sl<ApiClient>(instanceName: publicApiName)`.

### 4.3 Application
- **Services** are named `XService` and take named required dependencies.
- **Return type:** every public method returns `FutureFailable<T>`, built as `RepositoryRequestHandler<T>()(request: () async { ... })`.
- **Business logic lives here:** combining repositories (`PostsService.getPostDetails`), normalizing input (trimming the search query), and owning tokens (`AuthService`).
- **App-wide events:** a service may expose a `Stream` (`AuthService.userChanges`). It owns the controller and closes it in `dispose()`, which is registered with get_it.

### 4.4 Presentation

Code follows Dart 3.13 style as enforced by `very_good_analysis` 11:
- constructors are declared as `new(...)` / `const new(...)` rather than repeating the class name,
- empty class bodies end with `;`, as in `class MockX extends Mock implements X;`.

`dart fix --apply` converts older code.

Smallest complete cubit, `PostDetailsCubit`:

```dart
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
```

Cubits:
- **Dependencies** are private positional fields (`this._service`). No public fields; `bloc lint` enforces this.
- **Who they call:** services only. The one exception is `ThemeCubit`, which uses `SettingsStorage` directly because settings carry no rules.
- **Emitting:** use `emit` before the first `await` and `emitIfOpen` after it.
- **States:** the state file is a `part` of the cubit and contains a `sealed class XState extends Equatable` with `final class` subclasses: `XInitial`, `XLoading`, `XLoaded(...)`, `XFailed(AppFailure failure)`.
  - Keep failures as `AppFailure`, not strings; widgets translate them.
  - Put state that changes independently of the main status in fields of the loaded state, as `PostsListLoaded.isLoadingMore` and `loadMoreFailure` do.
- **Derived values** such as filters and flags are computed in the cubit or in state getters, not in widgets.

Pages and widgets:
- **Rendering:** use `BlocBuilder` with an exhaustive `switch (state)`. One-off reactions such as navigation or snackbars go in a `BlocListener`.
- **Dependencies:** read cubits with `context.read<X>()`. Never construct them in widgets and never use `sl`.
- **Failures:** `ErrorView(failure: ..., onRetry: ...)` for a whole screen, or `failure.toMessage(context.l10n)` inline.
- **Styling:** `context.colorScheme`, `context.textTheme`, `context.colors` (brand `AppColors`) and `Spacing.*`. No hard-coded colours or spacing numbers.
- **State classes:** put `dispose()` after `build()` and dispose every controller the state creates.

## 5. Failures

- **Where they're defined:** all failures are `final class`es in `lib/shared/errors/app_failure.dart`. The file is sealed, so the list is closed.
- **How they flow:**
  - `ApiClient` maps Dio errors: timeouts → `TimeoutFailure`, connection errors → `NoConnectionFailure`, 401 → `UnauthorizedFailure`, other statuses or a non-object body → `ServerFailure(statusCode)`.
  - `RepositoryRequestHandler` returns thrown `AppFailure`s as `Failed(...)`. Anything else becomes `Failed(UnexpectedFailure(error))` and is logged as an error.
- **Adding a failure:**
  1. Add a `final class` to `app_failure.dart`.
  2. Add an `error…` key to `app_en.arb` and run `flutter gen-l10n`.
  3. Add a `case` to `FailureMessage.toMessage`. The analyzer flags every `switch` that's now incomplete.
  4. Throw it from the repository that can detect it.

## 6. Cubit mixins (`lib/shared/cubit/`)

| Mixin | Use | API |
|---|---|---|
| `EmitGuardMixin` | Any cubit that awaits | `emitIfOpen(state)` |
| `DebounceMixin` | Search-as-you-type and similar | `debounce(delay, action)`; cancelled on `close()` |
| `PagingMixin<S, T>` | Offset-paged lists | implement `fetchPage`, `onPageLoading`, `onPageLoaded`, `onPageFailed`; call `loadFirstPage()` / `loadNextPage()`; override `pageSize` if needed |

`PagingMixin`:
- **Owns the loaded items.** `onPageLoaded` receives all items loaded so far.
- **Ignores `loadNextPage`** while a page is loading, when nothing is left, or before the first page arrives.
- **Discards stale pages:** a page that arrives after `loadFirstPage` restarted is dropped.
- **Paging data:** repositories return a `PageSlice<T>(items, hasMore)`.

`PostsListCubit` combines all three.

## 7. Dependency injection

- **Structure:** `registerDependencies` calls one private function per area: `_registerShared`, `_registerAuth`, `_registerPosts`. A new feature gets its own `_registerX`.
- **Registration types:**
  - Storages, clients, repositories and services use `registerLazySingleton`.
  - Anything that needs async setup uses `registerSingletonAsync`, which `sl.allReady()` waits for.
  - App-wide cubits (`ThemeCubit`, `SessionCubit`) are lazy singletons with `dispose: (c) => c.close()`, resolved in `bootstrap.dart` and passed to `App`.
- **Screen cubits** are never registered; routes create them.
- **Where `sl` may be read:** `service_locator.dart`, `bootstrap.dart` and route builders in `app_router.dart`. Nowhere else.
- **Multiple instances** of one type are told apart with `instanceName` constants declared next to `sl`, like `publicApiName`.

## 8. Navigation and access control

- **Paths** live in `Routes`. Parameterized paths have a builder method (`Routes.postDetails(id)`), and IDs travel as path parameters that are validated in the route's `redirect`.
- **Screen cubits** are created in the route builder, which starts their first load:
  `create: (_) => _started(XCubit(sl()), (cubit) => cubit.load())`
- **Access** is decided by `redirectForSession`:
  - unknown session → `/splash`
  - signed out → `/login`
  - signed in → away from splash and login

  Every other route requires a signed-in user. To make a route public, add it to `isPublicPage` and extend `test/app/router/app_router_test.dart`.
- **Redirect trigger:** the router re-runs redirects whenever `SessionCubit` emits (`StreamListenable`).

## 9. Authentication flow

1. **Startup:** `bootstrap` calls `SessionCubit.restore()`. `AuthService.restoreSession()` returns `null` when no token is stored, otherwise the user from `/auth/me`.
2. **Sign-in:** `LoginCubit.signIn` → `AuthService.signIn`, which saves the tokens in `TokenStorage` and emits the user on `userChanges`. `SessionCubit` emits `SessionSignedIn`, and the router leaves `/login`.
3. **Requests:** `AuthInterceptor` adds `Authorization: Bearer <token>` to every request made through the default `ApiClient`.
4. **Expired token (401):**
   - If another request already stored a newer token, the interceptor retries with that one.
   - Otherwise it calls `AuthService.refreshAccessToken()` and retries once.
   - If that fails, it calls `AuthService.signOut()`, which clears the tokens and emits `null`. The router then shows `/login`.
5. **Porting to another backend:** change only `AuthRepository` (paths, DTOs, status mapping). Keep the service, cubit and interceptor contracts.

## 10. Configuration

- **Where values come from:** `AppConfig` is built in `main_<env>.dart` from `.fromEnvironment('KEY')` and checked by `ensureValid()` in `bootstrap`.
- **New value:**
  1. Add the key to every `env/<env>.json`.
  2. Add a field to `AppConfig`.
  3. Read it in every `main_<env>.dart`.
  4. Validate it if it's required.
- **New environment:**
  1. Add an `Environment` value.
  2. Create `lib/main_<env>.dart` and `env/<env>.json`.
  3. Add launch configs in `.vscode/launch.json` and `.run/`.
- **Secrets** go in `env/*.local.json` (gitignored) or CI secrets.

## 11. Logging

- **Setup:** declare `const _log = AppLogger('Name');` at the top of a file, then call `_log.debug/info/warning/error(...)`.
- **Configuration:** `AppLogger.minLevel` is set in `bootstrap`. `AppLogger.errorReporter` is the single place to connect crash reporting.
- **What to log:** failures are already logged by `RepositoryRequestHandler` and `guardStorage`, so don't log them again. Never log tokens, passwords or personal data.

## 12. Tests

- **Layout:** `test/` mirrors `lib/`, and each test file is named `<file>_test.dart`.
- **Helpers:**
  - `test/helpers/mocks.dart`: mocktail mocks
  - `test/helpers/test_data.dart`: `const` fixtures
  - `test/helpers/pump_app.dart`: `tester.pumpApp(widget)` with theme and strings
  - `test/helpers/fake_http_adapter.dart`: an in-memory HTTP server for `ApiClient` and interceptor tests
  - `test/flutter_test_config.dart`: silences logging

| Subject | Replace | Check |
|---|---|---|
| Repository | `MockApiClient` | path and params (use `captureAny`), DTO → domain mapping, failures thrown |
| Service | repositories, storages | exact `Succeeded` / `Failed`, rules, side effects |
| Cubit | services | exact state sequence (`blocTest`), `fakeAsync` for debounce |
| Page | `MockCubit` + `whenListen` | output per state, calls to the cubit |
| Network | `FakeHttpAdapter` | status mapping, headers, retries |

- **Coverage:** each behaviour change comes with a test, and a bug fix comes with a test that fails without the fix.
- **Isolation:** tests run in random order, so create mocks in `setUp` and share no mutable state.
- **Time:** never wait for real time. Timers go through `fakeAsync`, and dates in expectations are fixed values.
- **Spinners:** when a spinner is on screen, use `pump()`; `pumpAndSettle()` would never settle.
- **Cleanup:** close cubits a test creates with `addTearDown(cubit.close)`.

## 13. Recipes

**New feature `orders`**
1. Create `domain/order.dart`, `data/dto/order_dto.dart`, `data/orders_repository.dart`, `application/orders_service.dart`, `presentation/cubits/orders/{orders_cubit,orders_state}.dart`, `presentation/pages/orders_page.dart`.
2. Add `_registerOrders()` to `service_locator.dart` and call it from `registerDependencies`.
3. Add paths to `Routes` and a `GoRoute` that creates the cubit.
4. Add strings to `app_en.arb` and run `flutter gen-l10n`.
5. Add mocks, fixtures and tests under `test/features/orders/`.

**New endpoint in an existing feature:** add a DTO if needed, then a repository method, a service method returning `FutureFailable`, a cubit method or state, and tests for each.

**New failure:** see §5.

**Paged list:** return `PageSlice<T>` from the repository, mix `PagingMixin` into the cubit, and trigger `loadNextPage()` from a scroll listener, as `PostsPage` does.

## 14. Before handing back

Run these and report the results. Say explicitly if something couldn't be run.

```sh
flutter gen-l10n        # when app_en.arb changed
dart format lib test
flutter analyze --fatal-infos --fatal-warnings
flutter test
bloc lint .             # after: dart pub global activate bloc_tools
```
