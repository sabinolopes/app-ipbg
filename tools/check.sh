#!/bin/sh
# Full project check: formatting, analysis (types + lint, zero warnings) and tests.
set -e
cd "$(dirname "$0")/.."

dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos --fatal-warnings
flutter test
