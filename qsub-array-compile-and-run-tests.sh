#!/bin/sh

: ${ID='develop'}
: ${targets=''}

# Directives
#PBS -N ${ID}-stan-array-compile-and-run-test
#PBS -W group_list=yetistats
#PBS -l nodes=1,walltime=00:28:00,mem=1gb
#PBS -M dl2604@columbia.edu
#PBS -m abe
#PBS -V

# Set output and error directories
#PBS -o localhost:/vega/stats/users/dl2604/
#PBS -e localhost:/vega/stats/users/dl2604/

## Run a target
echo 'target is: ' ${targets[$PBS_ARRAY_INDEX]}
time make CC=clang++ ${targets[$PBS_ARRAY_INDEX]}
