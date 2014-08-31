#!/bin/sh

# Directives
#PBS -N ${ID}-stan-array-compile-and-run-test
#PBS -W group_list=yetistats
#PBS -l nodes=1,walltime=01:00:00,mem=1gb
#PBS -m a
#PBS -M dl2604@columbia.edu
#PBS -V

## No notification per target

# Set output and error directories
#PBS -o localhost:/vega/stats/users/dl2604/
#PBS -e localhost:/vega/stats/users/dl2604/

# targets_raw=$(find src/test -name '*_test.cpp')
# targets=($targets_raw)
# target=${targets[$PBS_ARRAYID]}
# echo 'new target: ' $(echo "$target" | sed 's|src/||')
# ##targets_new=echo "$targets_raw" | sed "s|src/\(.*\)_test.cpp|\1|"
# echo 'target: ' ${target}


# targets_raw=$(find src/test -name '*_test.cpp')
# targets_raw=$(sed 's|src/\(.*\)_test.cpp|\1|' <<< $targets_raw)
targets_raw=$(cat all_targets.txt)
targets=($targets_raw)
target=${targets[$PBS_ARRAYID]}

## Run a target
# echo 'target is: ' ${target}
# echo 'number: ' $PBS_ARRAYID
# echo 'dir:    ' $PBS_O_WORKDIR
time make CC=clang++ ${target}
