#!/bin/bash

if [ -z "$1" ]; then
	echo "usage: $0 <problem_numer>"
	exit 1
fi

p="$1"
src="$p/sol.cpp"
tests="$p/tests"
bin="$p/sol"

g++-15 -O2 -o "$bin" "$src" || exit 1

for f in "$tests"/*.in; do
    expected="${f%.in}.out"
    "./$bin" < "$f" > /tmp/myout
    if diff -q /tmp/myout "$expected" > /dev/null; then
        echo "$(basename "$f") PASS"
    else
        echo "$(basename "$f") FAIL"
        diff <("./$bin" < "$f") "$expected"
    fi
done
