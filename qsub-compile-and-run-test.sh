#!/bin/sh

: ${ID='develop'}
: ${TARGET=''}

# Directives
#PBS -N $ID-stan-compile-and-run-test
#PBS -W group_list=yetistats
#PBS -l nodes=1,walltime=00:01:00,mem=1gb
#PBS -M dl2604@columbia.edu
#PBS -m abe
#PBS -V

# Set output and error directories
#PBS -o localhost:/vega/stats/users/dl2604/
#PBS -e localhost:/vega/stats/users/dl2604/

## Run a target
time make CC=clang++ ${TARGET}
