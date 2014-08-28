#!/bin/sh

# Directives
#PBS -N stan-develop-generate-tests
#PBS -W group_list=yetistats
#PBS -l nodes=1,walltime=00:02:00,mem=1gb
#PBS -M dl2604@columbia.edu
#PBS -m abe
#PBS -V

# Set output and error directories
#PBS -o localhost:/vega/stats/users/dl2604/
#PBS -e localhost:/vega/stats/users/dl2604/

# 3. Generate all test files.
echo '------------------------------------------------------------'
echo 'Generating all tests'

##time make CC=clang++ bin/libstan.a
echo 'need to figure this out' 

echo ''
echo 'Done building libs'

