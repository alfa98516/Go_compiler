#!/bin/bash
set -e

go build -o grobbit .

./grobbit tests/icg/student_test.gr out/student_test.ll

clang out/student_test.ll out/main.c -o out/student_test

./out/student_test