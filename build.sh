#!/usr/bin/env bash
# Builds build/dicthtml-wb.zip, a Kobo dictionary of Webster's Unabridged
# Dictionary (1913), from the Project Gutenberg text.
#
# The script compiles the dictutil tools from source into bin/, because the
# release binaries cover only some platforms. The tools use cgo, so the build
# needs Go and a C compiler. `nix develop` gives both.
set -euo pipefail

DICTUTIL_VERSION=v0.3.2
SOURCE_URL=https://www.gutenberg.org/ebooks/29765.txt.utf-8

cd "$(dirname "$0")"
mkdir -p bin build

if [[ ! -x bin/dictgen || ! -x bin/dictutil || ! -x bin/webster1913-convert ]]; then
  echo "Building dictutil $DICTUTIL_VERSION into bin/."
  GOBIN="$PWD/bin" go install \
    "github.com/pgaskin/dictutil/cmd/dictgen@$DICTUTIL_VERSION" \
    "github.com/pgaskin/dictutil/cmd/dictutil@$DICTUTIL_VERSION" \
    "github.com/pgaskin/dictutil/examples/webster1913-convert@$DICTUTIL_VERSION"
fi

if [[ ! -f build/pg29765.txt ]]; then
  echo "Downloading the Project Gutenberg text."
  curl -fsSL -o build/pg29765.txt "$SOURCE_URL"
fi

bin/webster1913-convert -o build/webster1913.df build/pg29765.txt
bin/dictgen -o build/dicthtml-wb.zip build/webster1913.df

sha256sum build/pg29765.txt build/dicthtml-wb.zip
