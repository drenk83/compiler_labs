#!/bin/bash
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PARSER="$ROOT/bash_parser"
ACCEPT="$ROOT/tests/accept"
REJECT="$ROOT/tests/reject"
fail=0
n_ok=0
n_bad=0

if [ ! -x "$PARSER" ]; then
  echo "missing parser: $PARSER" >&2
  exit 1
fi

run_parser() {
  local f="$1"
  stdout=$(mktemp)
  stderr=$(mktemp)
  "$PARSER" "$f" >"$stdout" 2>"$stderr"
  st=$?
}

check_empty() {
  local path="$1" label="$2"
  if [ -s "$path" ]; then
    echo "FAIL $label (expected empty): $(cat "$path")"
    return 1
  fi
  return 0
}

for f in "$ACCEPT"/*.sh; do
  [ -e "$f" ] || continue
  run_parser "$f"
  rel="${f#"$ROOT"/}"
  if [ "$st" -ne 0 ]; then
    echo "FAIL accept $rel (exit $st): $(tr '\n' ' ' <"$stderr")"
    fail=1
    n_bad=$((n_bad + 1))
  elif ! check_empty "$stdout" "$rel stdout"; then
    fail=1
    n_bad=$((n_bad + 1))
  elif ! check_empty "$stderr" "$rel stderr"; then
    fail=1
    n_bad=$((n_bad + 1))
  else
    n_ok=$((n_ok + 1))
  fi
  rm -f "$stdout" "$stderr"
done

for f in "$REJECT"/*.sh; do
  [ -e "$f" ] || continue
  linef="${f%.sh}.line"
  rel="${f#"$ROOT"/}"
  if [ ! -f "$linef" ]; then
    echo "FAIL $rel (missing ${linef#"$ROOT"/})"
    fail=1
    n_bad=$((n_bad + 1))
    continue
  fi
  expected="Error: line $(tr -d ' \t\n' <"$linef")"
  msgf="${f%.sh}.msg"
  if [ -f "$msgf" ]; then
    expected="$expected: $(tr -d '\n' <"$msgf")"
  fi
  run_parser "$f"
  got=$(sed -n '1p' "$stderr")
  if [ "$st" -eq 0 ]; then
    echo "FAIL reject $rel (exit 0, want 1)"
    fail=1
    n_bad=$((n_bad + 1))
  elif [ -s "$stdout" ]; then
    echo "FAIL reject $rel (stdout not empty)"
    fail=1
    n_bad=$((n_bad + 1))
  elif [ "$got" != "$expected" ]; then
    echo "FAIL reject $rel (want '$expected', got '$got')"
    fail=1
    n_bad=$((n_bad + 1))
  else
    n_ok=$((n_ok + 1))
  fi
  rm -f "$stdout" "$stderr"
done

echo "$n_ok passed, $n_bad failed"
exit "$fail"
