#!/bin/sh

: {$LOCATION=''}

# Directives
#PBS -N cmdstan-build
#PBS -W group_list=yetistats
#PBS -l nodes=4,walltime=00:03:00,mem=2gb
#PBS -M dl2604@columbia.edu
#PBS -m abe
#PBS -V

# Set output and error directories
#PBS -o localhost:/vega/stats/users/dl2604/
#PBS -e localhost:/vega/stats/users/dl2604/

echo '------------------------------------------------------------'
echo 'Building stanc'

cd $LOCATION
echo currently at: `pwd`
time make CC=clang++ -j4 build

echo ''
echo 'Done building stanc'

