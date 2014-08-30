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
## create 
job_stanc=$(qsub -v ID=develop -W depend=afterok:${job_libstanc} /u/9/d/dl2604/yeti-scripts/qsub-stanc.sh)
## generate all tests
job_generate_tests=$(qsub -v ID=develop /u/9/d/dl2604/yeti-scripts/qsub-generate-tests.sh)

qstat -f ${job_generate_tests}
## wait until all tests are done
## (use qstat -f to see if the job still exists)
while [ $? -eq 0 ]; do
    sleep 10
    qstat -f ${job_generate_tests}
done

echo 'all tests generated'

while [ $(ls bin/*.a | wc -l) -ne 2 ]; do
    echo 'waiting for libraries'
    sleep 10
done

while [ $(ls test/test-models/stanc | wc -l) -ne 1 ]; do
    echo 'waiting for stanc'
    sleep 10
done

## generate all test targets
targets=($(find src/test -name '*_test.cpp' | sed 's|src/\(.*\)_test.cpp|\1|'))


# ## loop over each test and queue up a target
# for (( n = 0; n < ${#targets[@]}; n++ )) do
#   qsub -v ID=develop,TARGET=${targets[$n]} /u/9/d/dl2604/yeti-scripts/qsub-compile-and-run-test.sh
# done





qsub -v ID=develop,TARGET=${targets[0]} /u/9/d/dl2604/yeti-scripts/qsub-compile-and-run-long-test.sh
#### run as an array
qsub -v ID=develop,targets=${targets} -t 1-${#targets[@]} /u/9/d/dl2604/yeti-scripts/qsub-array-compile-and-run-tests.sh

echo 'the job for tests is: ' ${job_run_tests}

qsub -v ID=develop -W depend=afteranyarray:${job_run_tests} /u/9/d/dl2604/yeti-scripts/qsub-notify.sh
