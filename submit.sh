#!/bin/bash

if [ -z "$1" ]; then
    echo "usage: $0 <problem_numer>"
    exit 1
fi

p="$1"
src="$p/sol.cpp"
tests="$p/tests"
bin="$p/sol"

# Compiler: override with `CXX=... ./test.sh`. Default to real g++ per-OS
# (on macOS `g++` is Apple clang, so prefer Homebrew's g++-15).
if [ -z "$CXX" ]; then
    if [ "$(uname)" = "Darwin" ]; then
        CXX=g++-15
    else
        CXX=g++
    fi
fi

"$CXX" -std=c++23 -O2 -o "$bin" "$src" || exit 1

for f in "$tests"/*.in; do
    expected="${f%.in}.out"
    "./$bin" <"$f" >/tmp/myout
    if diff -q /tmp/myout "$expected" >/dev/null; then
        echo "$(basename "$f") PASS"
    else
        got=$(tr '\n' ' ' </tmp/myout | cut -c1-200)
        exp=$(tr '\n' ' ' <"$expected" | cut -c1-200)
        echo "$(basename "$f") FAIL | expected: $exp | got: $got"
    fi
done
