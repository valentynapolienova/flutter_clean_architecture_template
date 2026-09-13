#!/usr/bin/env bash
# Renames the template to your app: Dart package name and imports, Android
# applicationId and namespace, iOS bundle identifier and display names.
#
# Usage:   tool/rename.sh <package_name> <org> ["Display Name"]
# Example: tool/rename.sh shop_app com.acme "Shop"
set -euo pipefail

OLD_NAME="clean_architecture_template"
OLD_ORG="com.example"
OLD_IOS_ID="com.example.cleanArchitectureTemplate"
OLD_DISPLAY="Clean Architecture Template"

die() {
  echo "error: $1" >&2
  exit 1
}

NEW_NAME="${1:-}"
NEW_ORG="${2:-}"
[[ -n "$NEW_NAME" && -n "$NEW_ORG" ]] ||
  die "usage: tool/rename.sh <package_name> <org> [\"Display Name\"]"
[[ "$NEW_NAME" =~ ^[a-z][a-z0-9_]*$ ]] ||
  die "package_name must be snake_case, for example shop_app"
[[ "$NEW_ORG" =~ ^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)+$ ]] ||
  die "org must be a reverse domain, for example com.acme"

# shop_app -> "Shop App" (display name) and shopApp (iOS bundle id).
NEW_DISPLAY="${3:-$(perl -pe 's/(^|_)([a-z])/($1 ? " " : "") . uc($2)/ge' <<<"$NEW_NAME")}"
NEW_CAMEL="$(perl -pe 's/_([a-z0-9])/uc($1)/ge' <<<"$NEW_NAME")"

cd "$(dirname "$0")/.."
grep -q "^name: $OLD_NAME$" pubspec.yaml ||
  die "pubspec.yaml is not named $OLD_NAME; the template was already renamed"

# replace <old> <new> <files...> — literal match, no regex escaping needed.
replace() {
  local old="$1" new="$2"
  shift 2
  OLD="$old" NEW="$new" perl -pi -e 's/\Q$ENV{OLD}\E/$ENV{NEW}/g' "$@"
}

# replace_word <old> <new> <files...> — skips matches inside longer words.
replace_word() {
  local old="$1" new="$2"
  shift 2
  OLD="$old" NEW="$new" perl -pi -e 's/\b\Q$ENV{OLD}\E\b/$ENV{NEW}/g' "$@"
}

DART_FILES=()
while IFS= read -r -d '' file; do DART_FILES+=("$file"); done \
  < <(find lib test -name '*.dart' -print0)

OLD_KOTLIN_DIR="android/app/src/main/kotlin/${OLD_ORG//.//}/$OLD_NAME"
NEW_KOTLIN_DIR="android/app/src/main/kotlin/${NEW_ORG//.//}/$NEW_NAME"

# Android
replace "$OLD_ORG.$OLD_NAME" "$NEW_ORG.$NEW_NAME" \
  android/app/build.gradle.kts "$OLD_KOTLIN_DIR/MainActivity.kt"
replace "android:label=\"$OLD_NAME\"" "android:label=\"$NEW_DISPLAY\"" \
  android/app/src/main/AndroidManifest.xml
if [[ "$OLD_KOTLIN_DIR" != "$NEW_KOTLIN_DIR" ]]; then
  mkdir -p "$NEW_KOTLIN_DIR"
  mv "$OLD_KOTLIN_DIR/MainActivity.kt" "$NEW_KOTLIN_DIR/MainActivity.kt"
  find android/app/src/main/kotlin -type d -empty -delete
fi

# iOS
replace "$OLD_IOS_ID" "$NEW_ORG.$NEW_CAMEL" ios/Runner.xcodeproj/project.pbxproj

# Display name
replace "$OLD_DISPLAY" "$NEW_DISPLAY" \
  ios/Runner/Info.plist lib/l10n/app_en.arb "${DART_FILES[@]}"

# Dart package name
replace_word "$OLD_NAME" "$NEW_NAME" \
  pubspec.yaml ios/Runner/Info.plist AGENTS.md "${DART_FILES[@]}"

echo "Renamed to $NEW_NAME ($NEW_ORG.$NEW_NAME, iOS $NEW_ORG.$NEW_CAMEL, \"$NEW_DISPLAY\")."

# The new package name changes where imports sort, so re-sort and reformat.
if command -v flutter >/dev/null 2>&1; then
  flutter pub get >/dev/null
  dart fix --apply --code=directives_ordering >/dev/null
  dart format lib test >/dev/null
  echo "Sorted imports and formatted code."
  echo "Next: flutter analyze && flutter test"
else
  echo "Next: flutter pub get && dart fix --apply --code=directives_ordering && dart format lib test"
fi
