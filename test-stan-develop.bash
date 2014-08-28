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

## create libstanc
job_libstanc=$(qsub -v ID=develop /u/9/d/dl2604/yeti-scripts/qsub-libstanc.sh)
## create libstan
job_libstan=$(qsub -v ID=develop /u/9/d/dl2604/yeti-scripts/qsub-libstan.sh)
## generate all tests
job_generate_tests=$(qsub -v ID=develop /u/9/d/dl2604/yeti-scripts/qsub-generate-tests.sh)

qstat -f ${job_generate_tests}
## wait until all tests are done
## (use qstat -f to see if the job still exists)
while [ $? -eq 0 ]; do
    sleep 1
    qstat -f ${job_generate_tests}
done

## generate all test targets
targets=($(find src/test -name '*_test.cpp' | sed 's|src/\(.*\)_test.cpp|\1|'))

## loop over each test and queue up a target
##for (( n = 0; n < ${#targets[@]}; n++ )) do
for (( n = 0; n < 5; n++ )) do
  qsub -v ID=develop,TARGET=${targets[$n]} -W depend=afterok:${job_libstanc} -W depend=afterok:${job_libstan} /u/9/d/dl2604/yeti-scripts/qsub-compile-and-run-test.sh
done

##qsub -v ID=develop /u/9/d/dl2604/yeti-scripts/qsub-compile-and-run-test.sh
