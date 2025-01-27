#!/bin/bash

#----------------------------------------------------------------------------------
# first_test.sh
#
# A tutorial script to learn condor job submission
#
# The script expects a tarball of input files named first_test_inputs.tar.gz and an
# integer as an argument. A file for the integer argument $I is selected from the
# unpacked tarball, and is renamed as first_test_output_$I.txt with the name of the
# execution host appended at the end.
# The output file is transferred back to the submission node by condor unless the
# job was submitted with transfer_output_files = "".
#----------------------------------------------------------------------------------

# argument
I=$1

# unpack the tarball - will create a directory named inputs with files 0, 1, 2, ...
tar xzf first_test_inputs.tar.gz

# list the contents of the directory -> will be written to path specified in the
# "output" line in the condor job description.
ls -l test/

# choose the file
FILENAME=$(($I%10)).txt

# append the host name
hostname >> test/$FILENAME
rpm -qa | grep osg-release >> test/$FILENAME

#export XrdSecDEBUG=2
#xrdcp root://xrootd.cmsaf.mit.edu//store/user/paus/nanosu/A00/SUEP-m750-generic+RunIIAutumn18-private+MINIAODSIM/SUEP-m750-generic-28.root temp.root
#xrdcp root://t3serv017.mit.edu//scratch/wangzqe/list.txt first_test_output_$I.txt
# rename the file for pickup by condor
cp test/$FILENAME first_test_output_$I.txt

# if not using condor transfer for outputs

# option 1: scp
# You can ship a password-unprotected ssh private key together with the job (security risk!!) for password-less transfer.
#
# scp -i id_rsa first_test_output_$I.txt some_host:destination_directory/first_test_output_$I.txt

# option 2: grid file transfer tool
# If you have a grid certificate and a dedicated storage element, tools like lcg-cp and gfal-copy are useful here.
# You will need to ship your X509 proxy together with the job.
#
# export X509_USER_PROXY=$(ls x509up_*)
# lcg-cp -v -D srmv2 -b file://$PWD srm://my_se:8443/srm/v2/server?SFN=destination_full_path
# or
# gfal-copy file://$PWD srm://my_se:8443/srm/v2/server?SFN=destination_full_path

# option 3: DropBox / Google Drive / ...
