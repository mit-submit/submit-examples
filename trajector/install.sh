#!/bin/bash
# ----------------------------------------------------------------------------
# Setup the right environment
# ----------------------------------------------------------------------------

#source /cvmfs/sft.cern.ch/lcg/views/LCG_99/x86_64-centos7-gcc8-opt/setup.sh
#source /cvmfs/sft.cern.ch/lcg/views/LCG_99/x86_64-centos7-gcc10-opt/setup.sh 
source /cvmfs/sft.cern.ch/lcg/releases/LCG_97/GSL/2.5/x86_64-centos7-gcc9-opt/GSL-env.sh 

# ----------------------------------------------------------------------------
# pythia
# ----------------------------------------------------------------------------

PWD=`pwd`

# Install 8303 release (https://pythia.org/)

if ! [ -e "pythia8303.tgz" ]
then
  wget https://pythia.org/download/pythia83/pythia8303.tgz

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
  cmake .. -DUSE_HEPMC=OFF -DUSE_ROOT=OFF -DPythia_CONFIG_EXECUTABLE=${PWD}/pythia8303/bin/pythia8-config
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


# ----------------------------------------------------------------------------
# TEST
# ----------------------------------------------------------------------------
cd trajectum-1.1/src
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${PWD}/pythia8303/lib"
./collide ../data/collisionpPb.par
