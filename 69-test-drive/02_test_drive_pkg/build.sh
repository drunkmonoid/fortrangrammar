#!/usr/bin/env bash
# Run fpm test with test-drive. Exit 77 when fpm or test-drive is absent.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

if ! command -v fpm >/dev/null 2>&1; then
  echo "fpm was not found"
  exit 77
fi

if ! fpm test >/dev/null 2>&1; then
  echo "test-drive dependency could not be resolved or fpm test failed"
  exit 77
fi
