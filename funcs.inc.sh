# Hey Emacs, this file needs -*- sh -*- mode

set -e

which time > /dev/null || { echo "time not found"; exit 1; }

# Use same version everywhere, but flambda won't be used without compiler support.
coqVersion=8.13.2+flambda
switchName=ocaml-$compilerVersion-coq-$coqVersion

if [ -z "$preciseCompilerVersion" ]; then
  preciseCompilerVersion=$compilerVersion
fi

if ! grep -q flambda <<< $compilerVersion; then
  preciseCompilerVersion=ocaml-base-compiler.$compilerVersion
fi

if [ "$1" = "-n" ]; then
  PERFORM=echo
  shift
else
  PERFORM=
fi

addRepo() {
  $PERFORM opam repo add --all --set-default $1 $2
}

setupRepos() {
  addRepo bb-overlay https://github.com/Blaisorblade/opam-overlay.git
  addRepo iris-dev https://gitlab.mpi-sws.org/iris/opam.git
  addRepo coq-released https://coq.inria.fr/opam/released
}

selectSwitch() {
  echo "Selecting switch $switchName"
  $PERFORM eval `opam env --switch=$switchName --set-switch`
}

createSwitch() {
  $(which time) $PERFORM opam switch create --no-switch -y $switchName $preciseCompilerVersion
  selectSwitch
  opam pin -y num 1.3
  opam pin -y zarith 1.12
}

installCoq() {
  $(which time) $PERFORM opam install -y coq.$coqVersion
}

setup() {
  set -x
  setupRepos
  createSwitch
  installCoq
}

####

# timefmt="%U user, %e real, %S sys, %M kb mem"
benchLib() {
  $(which time) $PERFORM opam remove $1
  $(which time) $PERFORM opam install -j1 -y $1.$2 2>&1 | tee -a $1-$2-bench-$switchName.log
}

benchStdpp() {
  benchLib coq-stdpp dev.2021-01-07.1.43aea848
}

benchBigNum() {
  benchLib coq-bignums 8.13.0
}

bench() {
  selectSwitch
  benchStdpp
  benchBigNum
}

avgReport() {
  # This "parses" the output from Linux's time command.
  awk < $i '
    function report(tot, totsq, n, label) {
      # n = 1 will produce NaN stddev, but that's fine.
      if (n >= 1) {
        mean = tot / n;
        meansq = totsq / n
        varpop = meansq-mean*mean
        # We need the sample standard deviation (stddev), not the population stddev.
        stddevsample=sqrt(varpop * n / (n - 1))
        # \sigma^2_pop = (\Sigma_i X_i^2)/n - \mu^2
        # \sigma^2_sample = \sigma^2_pop * n/(n-1)
        print "Mean +/- stddev:", mean, "+/-", stddevsample, "s " label " time"
      }
    }
    /user/ { utot += $1; utotsq += $1*$1; n++ }
    END {
      report(utot, utotsq, n, "user")
    }'
}

avgReports() {
  for i in "$1"/*.log; do
    echo -n "$i: "
    avgReport $i
  done
}
# vim: ft=sh sw=2
