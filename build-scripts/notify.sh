#!/bin/sh
# Directives
#PBS -N notify
#PBS -W group_list=yetistats
#PBS -l nodes=1,walltime=00:00:01,mem=1mb
#PBS -M dl2604@columbia.edu
#PBS -m abe
#PBS -V

# Set output and error directories
#PBS -o localhost:/vega/stats/users/dl2604/
#PBS -e localhost:/vega/stats/users/dl2604/

echo 'Done running array job'
