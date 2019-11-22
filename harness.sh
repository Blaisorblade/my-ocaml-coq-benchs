#!/bin/bash -x

./create-4-09-0-flambda-no-native.sh
./create-4-09-0-flambda.sh
./create-4-09-0.sh

reps=3
flambdaThenNorm() {
  for i in `seq 1 $reps`; do
    ./bench-4-09-0-flambda-no-native.sh
    ./bench-4-09-0-flambda.sh
    ./bench-4-09-0.sh
  done
}
normThenFlambda() {
  for i in `seq 1 $reps`; do
    ./bench-4-09-0.sh
    ./bench-4-09-0-flambda-no-native.sh
    ./bench-4-09-0-flambda.sh
  done
}
flambdaThenNorm
normThenFlambda
normThenFlambda
flambdaThenNorm

mkdir -p run-1
mv *.log run-1
./reports.sh
