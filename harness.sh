#!/bin/bash -x

reps=3
flambdaThenNorm() {
  for i in `seq 1 $reps`; do
    ./bench-4-10-2-flambda-no-native.sh
    ./bench-4-10-2-no-native.sh
    ./bench-4-07-1-flambda-no-native.sh
    ./bench-4-07-1-no-native.sh
  done
}
normThenFlambda() {
  for i in `seq 1 $reps`; do
    ./bench-4-10-2-no-native.sh
    ./bench-4-10-2-flambda-no-native.sh
    ./bench-4-07-1-no-native.sh
    ./bench-4-07-1-flambda-no-native.sh
  done
}
flambdaThenNorm
normThenFlambda
normThenFlambda
flambdaThenNorm

./reports.sh .
