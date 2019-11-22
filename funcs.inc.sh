# Hey Emacs, this file needs -*- sh -*- mode

set -e
switchName=ocaml-$compilerVersion-coq-$coqVersion

if [ "$1" = "-n" ]; then
  PERFORM=echo
  shift
else
  PERFORM=
fi

setupRepos() {
  $PERFORM opam repo add --all --set-default bb-overlay https://github.com/Blaisorblade/opam-overlay.git
  $PERFORM opam repo add --all --set-default iris-dev https://gitlab.mpi-sws.org/iris/opam.git
}

selectSwitch() {
  echo "Selecting switch $switchName"
  $PERFORM eval `opam env --switch=$switchName --set-switch`
}

createSwitch() {
  time $PERFORM opam switch create --no-switch -y $switchName $compilerVersion
  selectSwitch
}

installCoq() {
  time $PERFORM opam install -y coq.$coqVersion
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
  time $PERFORM opam remove $1
  $(which time) $PERFORM opam install -y $1.$2 2>&1 | tee -a $1-$2-bench-$switchName.log
}

benchStdpp() {
  benchLib coq-stdpp dev.2019-09-19.1.9041e6d8
}

benchBigNum() {
  benchLib coq-bignums 8.10.0
}

bench() {
  selectSwitch
  benchStdpp
  benchBigNum
}

avgReport() {
  # This "parses" the output from Linux's time command.
  awk < $i '
    /user/ { tot+= $1; totsq+= $1*$1; n++ }
    END {
      if (n >= 2) {
        mean = tot / n;
        meansq = totsq / n
        varpop = meansq-mean*mean
        # We need the sample standard deviation (stddev), not the population stddev.
        stddevsample=sqrt(varpop * n / (n - 1))
        # \sigma^2_pop = (\Sigma_i X_i^2)/n - \mu^2
        # \sigma^2_sample = \sigma^2_pop * n/(n-1)
        print "Mean +/- stddev:", mean, "+/-", stddevsample, "s user time"
      }
    }'
}

avgReports() {
  for i in run-1/*.log; do
    echo -n "$i: "
    avgReport $i
  done
}
# vim: ft=sh sw=2
