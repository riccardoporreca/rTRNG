#!/bin/bash

mkdir -p valgrind-check

docker run --rm -v $(pwd):/rTRNG wch1/r-debug bash -c ' \
  RDvalgrind -e "install.packages(\"remotes\"); remotes::install_deps(\"rTRNG\", dependencies = TRUE)" \
  && RDvalgrind CMD build /rTRNG \
  && mkdir valgrind-check-lib \
  && RDvalgrind -d "valgrind --track-origins=yes" CMD check \
    -o /rTRNG/valgrind-check \
    -l valgrind-check-lib \
    --install-args="--clean" \
    --use-valgrind --no-stop-on-test-error \
    $(ls rTRNG_*.tar.gz) \
  '

grep -ri "ERROR SUMMARY" valgrind-check/rTRNG.Rcheck --exclude-dir=*pkg_src > valgrind-check/valgrind-summary
cat valgrind-check/valgrind-summary
