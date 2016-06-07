#!/bin/sh

: {$STAN_PROGRAM=''}
: {$PROGRAM_ARGUMENTS=''}

STAN_PROGRAM_BASENAME=${basename $STAN_PROGRAM}

# Directives
#PBS -N ${STAN_PROGRAM_BASENAME}-${ID}
#PBS -W group_list=yetistats
#PBS -l nodes=1,walltime=01:00:00,mem=1gb
#PBS -M dl2604@columbia.edu
#PBS -m abe
#PBS -V

# Set output and error directories
#PBS -o localhost:/vega/stats/users/dl2604/
#PBS -e localhost:/vega/stats/users/dl2604/

echo '------------------------------------------------------------'
echo 'Running'
echo time ${STAN_PROGRAM} id=${ID} ${PROGRAM_ARGUMENTS} output file=${basename ${STAN_PROGRAM}}-${ID}.csv

echo 'Done running stanc'

