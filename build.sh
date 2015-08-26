git clone https://github.com/dogma-dart/dogma-data.git -b features/simplify-serialization ../dogma-data

pub install

pub global activate linter
pub global run linter .

dart --checked test/all.dart

if [ "$COVERALLS_TOKEN" ]; then
  pub global activate dart_coveralls 0.2.0
  pub global run dart_coveralls report \
    --token $COVERALLS_TOKEN \
    --exclude-test-files \
    --throw-on-error \
    test/all.dart
fi
