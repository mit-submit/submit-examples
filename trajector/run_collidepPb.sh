#!/bin/bash
# ----------------------------------------------------------------------------
# Setup the right environment
# ----------------------------------------------------------------------------
PWD=`pwd`

source /cvmfs/sft.cern.ch/lcg/releases/LCG_97/GSL/2.5/x86_64-centos7-gcc9-opt/GSL-env.sh 

if [ -d trajectum-1.1/src ]
then
  cd trajectum-1.1/src
  export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${PWD}/pythia8303/lib"
  ./collide ../data/collisionpPb.par
else
  echo " Dir trajectum-1.1/src does not exist. Start from base directory. "
fi
