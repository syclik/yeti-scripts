#!/bin/sh

: {$CMDSTAN_LOCATION=''}
: {$STAN_PROGRAM=''}

# Directives
#PBS -N build-stan-program
#PBS -W group_list=yetistats
#PBS -l nodes=1,walltime=00:01:00,mem=4gb
#PBS -M dl2604@columbia.edu
#PBS -m abe
#PBS -V

# Set output and error directories
#PBS -o localhost:/vega/stats/users/dl2604/
#PBS -e localhost:/vega/stats/users/dl2604/

echo '------------------------------------------------------------'
echo 'Building Stan program: '$STAN_PROGRAM
echo 'CMDSTAN_LOCATION: '$CMDSTAN_LOCATION


cd $CMDSTAN_LOCATION
echo currently at: `pwd`
time make CC=clang++ $STAN_PROGRAM

echo ''
echo 'Done building program'

