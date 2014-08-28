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

qsub /u/9/d/dl2604/yeti-scripts/qsub-libstanc.sh
qsub /u/9/d/dl2604/yeti-scripts/qsub-libstan.sh
qsub /u/9/d/dl2604/yeti-scripts/qsub-generate-tests.sh
