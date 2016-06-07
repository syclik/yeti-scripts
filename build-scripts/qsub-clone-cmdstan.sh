#!/bin/sh

: {$CMDSTAN_HASH=''}
: {$PWD=''}

# Directives
#PBS -N clone-cmdstan-${CMDSTAN_HASH}
#PBS -W group_list=yetistats
#PBS -l nodes=1,walltime=00:10:00,mem=1gb
#PBS -M dl2604@columbia.edu
#PBS -m abe
#PBS -V

# Set output and error directories
#PBS -o localhost:/vega/stats/users/dl2604/
#PBS -e localhost:/vega/stats/users/dl2604/

echo '------------------------------------------------------------'
echo 'Cloning CmdStan: '

git clone https://github.com/stan-dev/cmdstan $PWD/../cmdstan-$CMDSTAN_HASH
pushd $PWD/../cmdstan-$CMDSTAN_HASH
git checkout $CMDSTAN_HASH
git submodule update --init --recursive
popd

echo 'Done cloning'

