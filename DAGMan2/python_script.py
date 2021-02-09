#!/usr/bin/env python 
from optparse import OptionParser
import os

usage = "usage: %prog [options] inputfile"
parser = OptionParser(usage)
parser.add_option("--input_float",    type="float", default = 2.141592,
                        help = 'Input example.')
parser.add_option("--outfile_name",    type="string", default = 'test_2.141592.txt',
                        help = 'Output file.')

(options,args) = parser.parse_args()
input_float    = options.input_float
outfile_name        = options.outfile_name

print('Hello World!')
print('Input Float:  '+str(input_float))

# When running on the cluster, the directory /work/user/ doesn't exist.
# Your outfile is made in the working directory whereever the job is running.
# The submission script will the transfer any new or modified files from 
# the working dir to the initialdir = $(outfile_loc), which can be /work/user/...
cwd = os.getcwd()
f_out = open(cwd+'/'+outfile_name,'w')
f_out.write(str(input_float)+'\n')
f_out.close()

