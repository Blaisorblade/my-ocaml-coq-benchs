#!/bin/bash -x

./create-4-09-0-flambda.sh
./create-4-09-0.sh

reps=3
flambdaThenNorm() {
  for i in `seq 1 $reps`; do
    ./bench-4-09-0-flambda.sh
    ./bench-4-09-0.sh
  done
}
normThenFlambda() {
  for i in `seq 1 $reps`; do
    ./bench-4-09-0.sh
    ./bench-4-09-0-flambda.sh
  done
}
flambdaThenNorm
normThenFlambda
normThenFlambda
flambdaThenNorm
