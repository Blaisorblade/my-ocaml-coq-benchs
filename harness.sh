#!/bin/bash -x
opam repo add coq-released --all-switches --set-default https://coq.inria.fr/opam/released
opam repo add iris-dev --all-switches --set-default git+https://gitlab.mpi-sws.org/FP/opam-dev.git


./create-4-07-1-flambda.sh
./create-4-07-1.sh

reps=3
flambdaThenNorm() {
  for i in `seq 1 $reps`; do
    ./bench-4-07-1-flambda.sh
    ./bench-4-07-1.sh
  done
}
normThenFlambda() {
  for i in `seq 1 $reps`; do
    ./bench-4-07-1.sh
    ./bench-4-07-1-flambda.sh
  done
}
flambdaThenNorm
normThenFlambda
normThenFlambda
flambdaThenNorm
