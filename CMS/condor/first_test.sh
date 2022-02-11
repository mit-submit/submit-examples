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

tar xzf first_test_inputs.tar.gz

ls -l test/

# choose the file
FILENAME=$(($I%10)).txt

# append the host name
hostname >> test/$FILENAME

cp test/$FILENAME first_test_output_$I.txt

