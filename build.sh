#!/bin/sh
set -e

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="/tmp/tfc-build-$$"

mkdir -p "$BUILD_DIR"
trap 'rm -rf "$BUILD_DIR"' EXIT

cd "$BUILD_DIR"
"$SRC_DIR/configure"
make -j"$(nproc)" tcc
cp tcc "$SRC_DIR/tfc"
echo "ok."
