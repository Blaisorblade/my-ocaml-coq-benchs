#!/bin/bash -x

./create-4-07-1-flambda-no-native.sh
./create-4-07-1-flambda.sh
./create-4-07-1.sh
./create-4-09-0-flambda-no-native.sh
./create-4-09-0-flambda.sh
./create-4-09-0.sh

reps=3
flambdaThenNorm() {
  for i in `seq 1 $reps`; do
    ./bench-4-09-0-flambda-no-native.sh
    ./bench-4-09-0-flambda.sh
    ./bench-4-09-0.sh
    ./bench-4-07-1-flambda-no-native.sh
    ./bench-4-07-1-flambda.sh
    ./bench-4-07-1.sh
  done
}
normThenFlambda() {
  for i in `seq 1 $reps`; do
    ./bench-4-09-0.sh
    ./bench-4-09-0-flambda-no-native.sh
    ./bench-4-09-0-flambda.sh
    ./bench-4-07-1.sh
    ./bench-4-07-1-flambda-no-native.sh
    ./bench-4-07-1-flambda.sh
  done
}
flambdaThenNorm
normThenFlambda
normThenFlambda
flambdaThenNorm

./reports.sh .
