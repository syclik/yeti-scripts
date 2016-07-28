# yeti-scripts


Scripts to run on Yeti.


## Push-button script

Simple script that takes:

1. CmdStan commit hash
2. model
3. (optional) options to pass to CmdStan

Usage:
```
./run-cmdstan.sh <CmdStan commit hash> <Stan program path> <number of chains> <optional arguments to CmdStan>
```

Example:
```
./run-cmdstan.sh v2.11.0 my_model.stan 1000 data file=my_model.data.R sample
```
