#!/usr/bin/env bash
# Builds a PDF from a CMF structure reference in Markdown: pandoc renders the
# Markdown to HTML styled by pdf.css, then headless Chrome prints it (landscape Letter).
# A browser sizes table columns to fit their content, which LaTeX can't do
# for Markdown tables.
#
# Needs pandoc and Google Chrome (or Chromium). Set CHROME to use a specific
# browser binary.
#
# Usage: tools/build_pdf.sh [input.md] [output.pdf]
#   input.md defaults to schema/v1/CMF_STRUCTURE.md; output.pdf defaults to
#   the input path with .pdf in place of .md.
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
IN="${1:-$DIR/../schema/v1/CMF_STRUCTURE.md}"
OUT="${2:-${IN%.md}.pdf}"

find_chrome() {
  if [[ -n "${CHROME:-}" ]]; then echo "$CHROME"; return; fi
  for c in \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    "/Applications/Chromium.app/Contents/MacOS/Chromium" \
    google-chrome google-chrome-stable chromium chromium-browser; do
    if [[ -x "$c" ]] || command -v "$c" >/dev/null 2>&1; then echo "$c"; return; fi
  done
  echo "build_pdf.sh: Chrome not found; set CHROME to the browser binary" >&2
  exit 1
}

command -v pandoc >/dev/null || { echo "build_pdf.sh: pandoc not found" >&2; exit 1; }
CHROME_BIN="$(find_chrome)"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Links to other files (the JSON Schema) would point into this temp folder
# once printed; keep their text and drop the link. In-page links stay.
# Field tables (first header "#") get a "fields" class for pdf.css.
cat > "$TMP/filters.lua" <<'LUA'
function Link(el)
  if el.target:match("^#") or el.target:match("^https?:") then return el end
  return el.content
end

function Table(tbl)
  local first = tbl.head.rows[1] and tbl.head.rows[1].cells[1]
  if first and pandoc.utils.stringify(first.contents) == "#" then
    tbl.classes:insert("fields")
  end
  return tbl
end
LUA

pandoc "$IN" \
  --from gfm \
  --to html5 \
  --standalone \
  --embed-resources \
  --css "$DIR/pdf.css" \
  --metadata pagetitle="CMF Structure Reference" \
  --lua-filter "$TMP/filters.lua" \
  --output "$TMP/CMF_STRUCTURE.html"

"$CHROME_BIN" \
  --headless \
  --disable-gpu \
  --no-pdf-header-footer \
  --print-to-pdf="$OUT" \
  "file://$TMP/CMF_STRUCTURE.html" 2>/dev/null

echo "Wrote $OUT"
