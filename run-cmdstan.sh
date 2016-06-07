#!/bin/bash

## Expecting two arguments
if [ $# -lt 2 ]; then
  echo Usage:
  echo $0: \<CmdStan commit hash\> \<Stan program path\> \<optional arguments to CmdStan\>
  exit 1
fi

CMDSTAN_HASH=$1
shift
STAN_PROGRAM=$1
shift
PROGRAM_ARGUMENTS=$*

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
fi

if [ ! -e ../cmdstan-$CMDSTAN_HASH/bin/stanc ]; then
  job_cmdstan_build=$(qsub build-scripts/qsub-stanc.sh -v LOCATION=`pwd`/../cmdstan-$CMDSTAN_HASH)
  echo Building CmdStan: $job_cmdstan_build
fi



## Copy Stan program into one marked by the cmdstan hash
STAN_PROGRAM_FILENAME="${STAN_PROGRAM%.*}"
if [ ! -e $STAN_PROGRAM_FILENAME-$CMDSTAN_HASH.stan ]; then
  cp $STAN_PROGRAM $STAN_PROGRAM_FILENAME-$CMDSTAN_HASH.stan
fi

## Build the Stan program as an executable
if [ ! -e $STAN_PROGRAM_FILENAME-$CMDSTAN_HASH ]; then
  if [ -z $job_cmdstan_build ]; then
    job_build=$(qsub build-scripts/qsub-build-stan-program.sh -v CMDSTAN_LOCATION=`pwd`/../cmdstan-$CMDSTAN_HASH,STAN_PROGRAM=`pwd`/$STAN_PROGRAM_FILENAME-$CMDSTAN_HASH)
  else
    job_build=$(qsub build-scripts/qsub-build-stan-program.sh -v CMDSTAN_LOCATION=`pwd`/../cmdstan-$CMDSTAN_HASH,STAN_PROGRAM=`pwd`/$STAN_PROGRAM_FILENAME-$CMDSTAN_HASH -W depend=afterok:$job_cmdstan_build)
  fi
  echo Building Stan program: $job_build
fi



## Run the Stan executable
if [ -z $job_build ]; then
  job_run=$(qsub -v STAN_PROGRAM=`pwd`/$STAN_PROGRAM_FILENAME-$CMDSTAN_HASH,PROGRAM_ARGUMENTS="${PROGRAM_ARGUMENTS}" -t 1-2 build-scripts/qsub-run-array.sh)
else
  job_run=$(qsub -v STAN_PROGRAM=`pwd`/$STAN_PROGRAM_FILENAME-$CMDSTAN_HASH,PROGRAM_ARGUMENTS="${PROGRAM_ARGUMENTS}" -W depend=afterok:$job_build -t 1-2 build-scripts/qsub-run-array.sh)
fi

echo Running $STAN_PROGRAM: $job_run
echo Done.
