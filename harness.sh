#!/bin/bash -x

reps=3
flambdaThenNorm() {
  for i in `seq 1 $reps`; do
    ./4-10-2/bench-flambda-no-native.sh
    ./4-10-2/bench-no-native.sh
    ./4-07-1/bench-flambda-no-native.sh
    ./4-07-1/bench-no-native.sh
  done
}
normThenFlambda() {
  for i in `seq 1 $reps`; do
    ./4-10-2/bench-no-native.sh
    ./4-10-2/bench-flambda-no-native.sh
    ./4-07-1/bench-no-native.sh
    ./4-07-1/bench-flambda-no-native.sh
  done
}
flambdaThenNorm
normThenFlambda
normThenFlambda
flambdaThenNorm

./reports.sh .
