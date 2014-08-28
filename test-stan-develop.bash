#!/bin/bash
# 1. Update repository.
echo '------------------------------------------------------------'
echo 'Updating Stan repository to develop branch'

pushd /vega/stats/users/dl2604/stan-develop
## this takes a long time:
# make clean-all

git clean -d -x -f
git checkout develop
git pull --ff

echo ''
echo 'Branch information'
git log -n 1

echo 'Stan develop branch updated'
echo ''

echo '------------------------------------------------------------'

qsub -v ID=develop /u/9/d/dl2604/yeti-scripts/qsub-libstanc.sh
qsub -v ID=develop /u/9/d/dl2604/yeti-scripts/qsub-libstan.sh
qsub -v ID=develop /u/9/d/dl2604/yeti-scripts/qsub-generate-tests.sh

targets=($(find src/test -name '*_test.cpp' | sed 's|src/\(.*\)_test.cpp|\1|'))

for (( n = 0; n < ${#targets[@]}; n++ )) do
    echo ' create individual qsub job for: ' ${targets[$n]}
done
    
    echo ${#targets[@]}
    
##qsub -v ID=develop /u/9/d/dl2604/yeti-scripts/qsub-compile-and-run-test.sh
