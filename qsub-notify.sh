#!/bin/sh

: ${ID='develop'}

# Directives
#PBS -N ${ID}-stan-notify
#PBS -W group_list=yetistats
#PBS -l nodes=1,walltime=00:00:10,mem=1gb
#PBS -M dl2604@columbia.edu
#PBS -m abe
#PBS -V

# Set output and error directories
#PBS -o localhost:/vega/stats/users/dl2604/
#PBS -e localhost:/vega/stats/users/dl2604/

echo 'Sending notification'

