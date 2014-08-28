#!/bin/sh

: ${ID='develop'}

# Directives
#PBS -N ${ID}-stan-libstanc
#PBS -W group_list=yetistats
#PBS -l nodes=1,walltime=00:05:00,mem=2gb
#PBS -M dl2604@columbia.edu
#PBS -m abe
#PBS -V

# Set output and error directories
#PBS -o localhost:/vega/stats/users/dl2604/
#PBS -e localhost:/vega/stats/users/dl2604/

# 2. Build bin/libstanc.a and bin/libstan.a.
echo '------------------------------------------------------------'
echo 'Building libs'

time make CC=clang++ bin/libstanc.a 

echo ''
echo 'Done building libs'

# 3. Generate all test files.
