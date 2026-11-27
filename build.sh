#!/bin/sh
set -e

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="/tmp/tfc-build-$$"

mkdir -p "$BUILD_DIR"
trap 'rm -rf "$BUILD_DIR"' EXIT

cd "$BUILD_DIR"
"$SRC_DIR/configure"
make -j"$(nproc)" tcc libtcc1.a
cp tcc "$SRC_DIR/tfc"
cp libtcc1.a "$SRC_DIR/lib/libtcc1.a"
for f in bt-exe.o bt-log.o bcheck.o bcheck_run.o; do
  [ -f "$f" ] && cp "$f" "$SRC_DIR/lib/$f"
done
echo "ok."
