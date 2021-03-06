#!/bin/sh

: {$ID='develop'}

# Directives
#PBS -N ${ID}-stan-generate-tests
#PBS -W group_list=yetistats
#PBS -l nodes=1,walltime=00:10:00,mem=1gb
#PBS -M dl2604@columbia.edu
#PBS -m abe
#PBS -V

# Set output and error directories
#PBS -o localhost:/vega/stats/users/dl2604/
#PBS -e localhost:/vega/stats/users/dl2604/

# 3. Generate all test files.
echo '------------------------------------------------------------'
echo 'Generating all tests'

time make CC=clang++ test/unit-distribution/generate_tests

tests=$(find src/test/unit-distribution -name '*_test.hpp')
for test in ${tests}
do
    test/unit-distribution/generate_tests ${test}
done
echo 'tests: ' ${tests}


# targets=$(find src/test/unit-distribution -name '*_test.hpp' | sed 's|\(.*\)_test.hpp|\1_00000_generated_test.cpp|')

# echo 'targets: ' ${targets}
# for target in ${targets} 
# do
#     make CC=clang++ ${target}
# done

echo ''
echo 'Done building all generated test files'

