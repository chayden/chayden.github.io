#!/bin/sh
# Verify that resources referenced in HTML files exist.
set -e
status=0
for html in *.html; do
  echo "Checking $html"
  refs=$(grep -oE '(href|src)="[^"]+"' "$html" | sed -E 's/(href|src)="([^"]+)"/\2/')
  for res in $refs; do
    case "$res" in
      http:*|https:*|//*)
        continue ;;
    esac
    path=${res#"/"}
    path=${path%%\?*}
    if [ ! -e "$path" ]; then
      echo "Missing resource: $res (referenced in $html)"
      status=1
    fi
  done
done
exit $status
