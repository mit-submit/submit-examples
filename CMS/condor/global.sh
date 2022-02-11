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
#THIS NEED TO CHANGE
OUTDIR=output

# Output files (comma-separated) to be transferred back from completed
# jobs to $OUTDIR.  Condor will find these files in the initial PWD of
# the executable Since /work has a limited user quota, users are
# encouraged to not use the condor transfer mechanism but rather
# transfer the job outputs directly to some storage at the end of the jobs.
# If this is done, set this to "".
OUTPUT_FILES='first_test_output_$(Process).txt'

# Destination of log, stdout, stderr files
#THIS NEED TO CHANGE
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
Requirements = ( BOSCOCluster =!= "t3serv008.mit.edu" && BOSCOCluster =!= "ce03.cmsaf.mit.edu" && BOSCOCluster =!= "eofe8.mit.edu")
use_x509userproxy = True
x509userproxy = /tmp/x509up_u'$(id -u)'
+AccountingGroup = "analysis.'$(id -un)'"
+REQUIRED_OS = "rhel7"
+DESIRED_Sites = "T2_AT_Vienna,T2_BE_IIHE,T2_BE_UCL,T2_BR_SPRACE,T2_BR_UERJ,T2_CH_CERN,T2_CH_CERN_AI,T2_CH_CERN_HLT,T2_CH_CERN_Wigner,T2_CH_CSCS,T2_CH_CSCS_HPC,T2_CN_Beijing,T2_DE_DESY,T2_DE_RWTH,T2_EE_Estonia,T2_ES_CIEMAT,T2_ES_IFCA,T2_FI_HIP,T2_FR_CCIN2P3,T2_FR_GRIF_IRFU,T2_FR_GRIF_LLR,T2_FR_IPHC,T2_GR_Ioannina,T2_HU_Budapest,T2_IN_TIFR,T2_IT_Bari,T2_IT_Legnaro,T2_IT_Pisa,T2_IT_Rome,T2_KR_KISTI,T2_MY_SIFIR,T2_MY_UPM_BIRUNI,T2_PK_NCP,T2_PL_Swierk,T2_PL_Warsaw,T2_PT_NCG_Lisbon,T2_RU_IHEP,T2_RU_INR,T2_RU_ITEP,T2_RU_JINR,T2_RU_PNPI,T2_RU_SINP,T2_TH_CUNSTDA,T2_TR_METU,T2_TW_NCHC,T2_UA_KIPT,T2_UK_London_IC,T2_UK_SGrid_Bristol,T2_UK_SGrid_RALPP,T2_US_Caltech,T2_US_Florida,T2_US_MIT,T2_US_Nebraska,T2_US_Purdue,T2_US_UCSD,T2_US_Vanderbilt,T2_US_Wisconsin,T3_CH_CERN_CAF,T3_CH_CERN_DOMA,T3_CH_CERN_HelixNebula,T3_CH_CERN_HelixNebula_REHA,T3_CH_CMSAtHome,T3_CH_Volunteer,T3_US_HEPCloud,T3_US_NERSC,T3_US_OSG,T3_US_PSC,T3_US_SDSC"
rank = Mips
arguments = "'$ARGUMENTS'"
'"$TESTSPEC"'
queue '$NJOBS | condor_submit
