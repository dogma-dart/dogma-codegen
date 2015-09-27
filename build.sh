#!/bin/sh
set -ex

# Clone dependencies
git clone https://github.com/dogma-dart/dogma-data.git ../dogma-data
git clone https://github.com/dogma-dart/dogma-codegen-test.git ../dogma-codegen-test

# Get version
dart --version

# Install dependencies
pub install

# Run the tests
dart --checked test/all.dart

# Run the linter
pub global activate linter
pub global run linter .
