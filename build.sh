#!/bin/sh
set -ex

# Clone dependencies
git clone https://github.com/dogma-dart/dogma-data.git ../dogma-data

# Get version
dart --version

# Install dependencies
pub install

# Run the linter
pub global activate linter
pub global run linter .

# Run the tests
dart --checked test/all.dart

git show-ref master --heads

# Run the tests and report back to coveralls
if [ "$COVERALLS_TOKEN" ]; then
  pub global activate dart_coveralls 0.2.0
  pub global run dart_coveralls report \
    --token $COVERALLS_TOKEN \
    --exclude-test-files \
    --throw-on-error \
    test/all.dart
fi
