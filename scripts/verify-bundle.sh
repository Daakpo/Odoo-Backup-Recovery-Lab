#!/usr/bin/env bash
# Read-only check of the four documented recovery components.
set -euo pipefail
if [[ $# -ne 1 ]]; then
  printf 'Usage: bash %s /path/to/recovery-bundle\n' "$0" >&2
  exit 2
fi
cd -- "$1"
for name in database.dump odoo-data.tar.gz odoo.conf project.tar.gz SHA256SUMS; do
  [[ -f "$name" ]] || { printf 'Missing file: %s\n' "$name" >&2; exit 1; }
done
# Feed only the expected records to sha256sum, rejecting other manifest paths.
awk '
  $1 !~ /^[[:xdigit:]]+$/ || length($1) != 64 { exit 1 }
  $2 !~ /^(database\.dump|odoo-data\.tar\.gz|odoo\.conf|project\.tar\.gz)$/ { exit 1 }
  seen[$2]++ { exit 1 }
  END { if (NR != 4) exit 1 }
' SHA256SUMS || { printf 'Unexpected SHA256SUMS structure\n' >&2; exit 1; }
sha256sum -c SHA256SUMS
gzip -t odoo-data.tar.gz
tar -tzf project.tar.gz >/dev/null
printf 'Four checksums and archive checks passed. Database restore remains a separate check.\n'
