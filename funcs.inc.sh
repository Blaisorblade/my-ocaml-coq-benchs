# Hey Emacs, this file needs -*- sh -*- mode

set -e

if [ "$1" = "-n" ]; then
  PERFORM=echo
  shift
else
  PERFORM=
fi

selectSwitch() {
  echo "Selecting switch $switchName"
  $PERFORM eval `opam env --switch=$switchName --set-switch`
}

createSwitch() {
  time $PERFORM opam switch create --no-switch -y $switchName $compilerVersion
  selectSwitch
}

installCoq() {
  time $PERFORM opam install -y coq.8.10.0
}

setup() {
  set -x
  createSwitch
  installCoq
}

####

benchLib() {
  time $PERFORM opam remove $1
  $(which time) $PERFORM opam install -y $1.$2 2>&1 | tee -a $1-$2-bench-$switchName.log
}

benchStdpp() {
  benchLib coq-stdpp dev.2019-09-19.1.9041e6d8
}

bench() {
  selectSwitch
  benchStdpp
}

# vim: ft=sh sw=2
