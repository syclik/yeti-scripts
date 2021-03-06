#!/bin/sh

: {$STAN_PROGRAM=''}
: {$PROGRAM_ARGUMENTS=''}

# Directives
#PBS -N run-program
#PBS -W group_list=yetistats
#PBS -l nodes=1,walltime=01:00:00,mem=1gb
#PBS -M dl2604@columbia.edu
#PBS -m n
#PBS -V

# Set output and error directories
#PBS -o localhost:/vega/stats/users/dl2604/
#PBS -e localhost:/vega/stats/users/dl2604/

echo '------------------------------------------------------------'
echo 'Running'
echo $STAN_PROGRAM id=$PBS_ARRAYID $PROGRAM_ARGUMENTS output file=$STAN_PROGRAM-$PBS_ARRAYID.csv

$STAN_PROGRAM id=$PBS_ARRAYID $PROGRAM_ARGUMENTS output file=$STAN_PROGRAM-$PBS_ARRAYID.csv

echo 'Done running'

