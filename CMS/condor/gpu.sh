#!/bin/bash

#----------------------------------------------------------------------------------
# submit.sh
#
# Tutorial submit script
#
# This script will call condor_submit to submit NJOBS jobs of executable
# first_test.sh. Place this directory in a directory under /work/$USER.
# Then a simple ./submit.sh will create a job that returns an output in
# /work/$USER/output.
#----------------------------------------------------------------------------------

#### SETUP BEGIN ####

# Directory where this script is
THISDIR=$(cd $(dirname $0); pwd)

# Path to the executable script
EXECUTABLE=$THISDIR/first_test.sh

# $(Process) is replaced by the job serial id (0 - (NJOBS-1))
ARGUMENTS='$(Process)'

# Input files (comma-separated) to be transferred to the remote host
# Executable will see them copied in PWD
INPUT_FILES=$THISDIR/first_test_inputs.tar.gz

# Destination of output files (if using condor file transfer)
OUTDIR=output

# Output files (comma-separated) to be transferred back from completed
# jobs to $OUTDIR.  Condor will find these files in the initial PWD of
# the executable Since /work has a limited user quota, users are
# encouraged to not use the condor transfer mechanism but rather
# transfer the job outputs directly to some storage at the end of the jobs.
# If this is done, set this to "".
OUTPUT_FILES='first_test_output_$(Process).txt'

# Destination of log, stdout, stderr files
LOGDIR=logs

NJOBS=1

LOCALTEST=false

#### SETUP END ####

# Make directories if necessary
if ! [ -d $LOGDIR ]
then
  mkdir -p $LOGDIR
fi

if ! [ -d $OUTDIR ]
then
  mkdir -p $OUTDIR
fi

# If LOCALTEST=true, configure the job as such
if $LOCALTEST
then
  read -d '' TESTSPEC << EOF
+Submit_LocalTest = 5
requirements = isUndefined(GLIDEIN_Site)
EOF
else
  TESTSPEC=''
fi

# Now submit the job
echo '
universe = vanilla
executable = '$EXECUTABLE'
should_transfer_files = YES
when_to_transfer_output = ON_EXIT
transfer_input_files = '$INPUT_FILES'
transfer_output_files = '$OUTPUT_FILES'
output = '$LOGDIR'/$(Process).stdout
error = '$LOGDIR'/$(Process).stderr
log = '$LOGDIR'/$(Process).log
initialdir = '$OUTDIR'
#Request_Memory          = 2.0 GB
#Request_Disk            = 3 GB
#RequestCpus = 2
Requirements = ( BOSCOCluster =!= "t3serv008.mit.edu" && BOSCOCluster =!= "ce03.cmsaf.mit.edu" && BOSCOCluster =!= "eofe8.mit.edu")
RequestGPus=1
use_x509userproxy = True
x509userproxy = /tmp/x509up_u'$(id -u)'
+AccountingGroup = "analysis.'$(id -un)'"
+REQUIRED_OS = "rhel7"
+DESIRED_Sites = "T2_US_MIT"
rank = Mips
arguments = "'$ARGUMENTS'"
'"$TESTSPEC"'
queue '$NJOBS | condor_submit
