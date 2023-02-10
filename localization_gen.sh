#!/bin/bash
flutter pub run easy_localization:generate -S "assets/translations" -O "lib/core/translations" &
flutter pub run easy_localization:generate -S "assets/translations" -O "lib/core/translations" -o "local_keys.g.dart" -f keys