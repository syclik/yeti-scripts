#!/bin/bash

## Expecting three arguments
if [ $# -lt 3 ]; then
  echo Usage:
  echo $0: \<CmdStan commit hash\> \<Stan program path\> \<number of chains\> \<optional arguments to CmdStan\>
  exit 1
fi

CMDSTAN_HASH=$1
shift
STAN_PROGRAM=$1
shift
N=$1
shift
PROGRAM_ARGUMENTS=$*

if [ ! -e $STAN_PROGRAM ]; then
  echo Failed to run the script:
  echo    $STAN_PROGRAM doesn\'t exist
  exit 1
fi

if [ ! -e ../cmdstan-$CMDSTAN_HASH ]; then
  job_clone_cmdstan=${qsub build-scripts/qsub-clone-cmdstan.sh -v CMDSTAN_HASH=$CMDSTAN_HASH}
  echo Cloning CmdStan: $job_clone_cmdstan
fi


CMDSTAN_LOCATION=`pwd`/../cmdstan-$CMDSTAN_HASH
if [ ! -e ../cmdstan-$CMDSTAN_HASH/bin/stanc ]; then
  if [-z $job_clone_cmdstan ]; then
    job_cmdstan_build=$(qsub build-scripts/qsub-stanc.sh -v LOCATION=$CMDSTAN_LOCATION)
  else
    job_cmdstan_build=$(qsub build-scripts/qsub-stanc.sh -v LOCATION=$CMDSTAN_LOCATION -W depend=afterok:$job_clone_cmdstan)
  fi
  echo Building CmdStan: $job_cmdstan_build
fi

## Copy Stan program into one marked by the cmdstan hash
STAN_PROGRAM_FILENAME="${STAN_PROGRAM%.*}"
if [ ! -e $STAN_PROGRAM_FILENAME-$CMDSTAN_HASH.stan ]; then
  cp $STAN_PROGRAM $STAN_PROGRAM_FILENAME-$CMDSTAN_HASH.stan
fi

## Build the Stan program as an executable
STAN_PROGRAM_LOCATION=`pwd`/$STAN_PROGRAM_FILENAME-$CMDSTAN_HASH
if [ ! -e $STAN_PROGRAM_FILENAME-$CMDSTAN_HASH ]; then
  if [ -z $job_cmdstan_build ]; then
    job_build=$(qsub build-scripts/qsub-build-stan-program.sh -v CMDSTAN_LOCATION=$CMDSTAN_LOCATION,STAN_PROGRAM=$STAN_PROGRAM_LOCATION)
  else
    job_build=$(qsub build-scripts/qsub-build-stan-program.sh -v CMDSTAN_LOCATION=$CMDSTAN_LOCATION,STAN_PROGRAM=$STAN_PROGRAM_LOCATION -W depend=afterok:$job_cmdstan_build)
  fi
  echo Building Stan program: $job_build
fi



## Run the Stan executable
if [ -z $job_build ]; then
  job_run=$(qsub -v STAN_PROGRAM=$STAN_PROGRAM_LOCATION,PROGRAM_ARGUMENTS="${PROGRAM_ARGUMENTS}" -t 1-$N build-scripts/qsub-run-array.sh)
else
  job_run=$(qsub -v STAN_PROGRAM=$STAN_PROGRAM_LOCATION,PROGRAM_ARGUMENTS="${PROGRAM_ARGUMENTS}" -W depend=afterok:$job_build -t 1-$N build-scripts/qsub-run-array.sh)
fi

echo Running $STAN_PROGRAM: $job_run
echo Done.
