# All relevant and up to date info can be found at:
#  https://pythia.org/

# Install the presently latest pythia release (August 18, 2021)

if ! [ -e "pythia8306.tgz" ]
then
  wget https://pythia.org/download/pythia83/pythia8306.tgz
fi

# untar the software package
tar fzx pythia8306.tgz

# go to the root directory of pythia
cd pythia8306

# configure (mostly just gcc compiler)
./configure

# build the package
make
