#!/bin/bash
#
# Local run — like LeetCode's "Run": compile and run your solution against a
# few sample inputs, showing input / expected / your output / timing.
# For the full graded run against every test case, use ./submit.sh instead.
#
# usage: ./test.sh <problem_number> [test_ids...]
#   ./test.sh 1192          # runs samples 1 and 2 by default
#   ./test.sh 1192 11 14    # runs specific test ids

if [ -z "$1" ]; then
    echo "usage: $0 <problem_number> [test_ids...]"
    exit 1
fi

p="$1"
shift
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

# Which tests to run: those passed on the command line, else default to 1 and 2.
if [ "$#" -gt 0 ]; then
    ids=("$@")
else
    ids=(1 2)
fi

echo "compiling $src ..."
"$CXX" -O2 -o "$bin" "$src" || exit 1
echo

bold=$'\e[1m'; green=$'\e[32m'; red=$'\e[31m'; dim=$'\e[2m'; rst=$'\e[0m'

for id in "${ids[@]}"; do
    f="$tests/$id.in"
    expected="$tests/$id.out"
    if [ ! -f "$f" ]; then
        echo "${red}test $id: no $f${rst}"
        continue
    fi

    # Time the run (ms). stdout (what you return) -> myout, stderr (your
    # cerr/clog debug prints) -> mylog, kept separate.
    start=$(date +%s%N)
    "./$bin" <"$f" >/tmp/myout 2>/tmp/mylog
    rc=$?
    end=$(date +%s%N)
    ms=$(( (end - start) / 1000000 ))

    echo "${bold}=== test $id ===${rst}  ${dim}(${ms} ms, exit $rc)${rst}"

    if [ -f "$expected" ]; then
        echo "${bold}expected:${rst}"
        cat "$expected"
    fi

    echo "${bold}returned:${rst}"
    cat /tmp/myout

    if [ -s /tmp/mylog ]; then
        echo "${dim}${bold}logged (cerr):${rst}"
        echo "${dim}$(cat /tmp/mylog)${rst}"
    fi

    if [ -f "$expected" ]; then
        if diff -q /tmp/myout "$expected" >/dev/null; then
            echo "${green}${bold}PASS${rst}"
        else
            echo "${red}${bold}FAIL${rst}"
        fi
    fi
    echo
done
