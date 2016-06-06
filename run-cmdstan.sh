#!/bin/bash

if [ $# -lt 2 ]; then
  echo Usage:
  echo $0: \<CmdStan commit hash\> \<Stan program path\> \<optional arguments to CmdStan\>
  exit 1
fi
 
CMDSTAN_HASH=$1
STAN_PROGRAM=$2

if [ ! -e $STAN_PROGRAM ]; then
  echo Failed to run the script:
  echo    $STAN_PROGRAM doesn\'t exist
  exit 1
fi

if [ ! -e ../cmdstan-$CMDSTAN_HASH ]; then
  git clone https://github.com/stan-dev/cmdstan ../cmdstan-$CMDSTAN_HASH
  pushd ../cmdstan-$CMDSTAN_HASH
  git submodule update --init --recursive
  popd

  qsub build-scripts/qsub-stanc.sh `pwd`../cmdstan-$CMDSTAN_HASH
fi

