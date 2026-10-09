#!/usr/bin/env bash
set -euo pipefail
paper_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd -- "$paper_dir/.." && pwd)"
build_dir="$repo_dir/tmp/paper-build"
mkdir -p "$build_dir"
export SOURCE_DATE_EPOCH="${SOURCE_DATE_EPOCH:-$(git -C "$repo_dir" show -s --format=%ct HEAD)}"
export FORCE_SOURCE_DATE=1
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory="$build_dir" "$paper_dir/paper.tex" > "$build_dir/build-pass-1.txt"
pdflatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory="$build_dir" "$paper_dir/paper.tex" > "$build_dir/build-pass-2.txt"
cp "$build_dir/paper.pdf" "$paper_dir/paper.pdf"
printf 'Built %s\n' "$paper_dir/paper.pdf"
