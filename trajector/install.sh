#!/bin/bash
# ----------------------------------------------------------------------------
# Setup the right environment
# ----------------------------------------------------------------------------
PWD=`pwd`
echo " Base directory is: $PWD"

# setting up all the good links (boost and gsl for gcc9)
source /cvmfs/sft.cern.ch/lcg/releases/LCG_97/Boost/1.72.0/x86_64-centos7-gcc9-opt/Boost-env.sh
source /cvmfs/sft.cern.ch/lcg/releases/LCG_97/GSL/2.5/x86_64-centos7-gcc9-opt/GSL-env.sh

# ----------------------------------------------------------------------------
# pythia
# ----------------------------------------------------------------------------

# Install 8303 release (https://pythia.org/)

if ! [ -d "pythia8303" ]
then

  wget --no-check-certificate https://pythia.org/download/pythia83/pythia8303.tgz

  # untar the software package
  tar fzx pythia8303.tgz
  rm pythia8303.tgz
  
  # go to the root directory of pythia
  cd pythia8303
  
  # configure (mostly just gcc compiler)
  ./configure --cxx-common='-std=c++11 -mfpmath=sse -O3 -fPIC'
  
  # build the package
  make
  
  cd ..
fi

# ----------------------------------------------------------------------------
# smash
# ----------------------------------------------------------------------------

if ! [ -d "smash" ]
then
  git clone https://github.com/smash-transport/smash.git
  cd    smash
  mkdir build
  cd    build
  # Careful, it looks like root and HepMc are not working properly
  cmake3 .. -DUSE_HEPMC=OFF -DUSE_ROOT=OFF -DPythia_CONFIG_EXECUTABLE=${PWD}/pythia8303/bin/pythia8-config
  make
  cd ../..
fi


# ----------------------------------------------------------------------------
# trajectum
# ----------------------------------------------------------------------------

if ! [ -d "trajectum-1.1" ]
then
    wget -O trajectum-1.1.tar.gz \
            http://t3serv001.mit.edu:/~paus/tmp/trajectum-1.1.tar.gz
    tar fzx trajectum-1.1.tar.gz
    rm trajectum-1.1.tar.gz
    cd trajectum-1.1
    ./configure --disable-nativecompilation pythiadir=${PWD}/pythia8303
    make
    cd ..
fi
