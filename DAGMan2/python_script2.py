#!/usr/bin/env python 
from optparse import OptionParser
import os

usage = "usage: %prog [options] inputfile"
parser = OptionParser(usage)
parser.add_option("--infile",    type="str", default = '/work/saxani/test/output/outfile_1A.txt',
                        help = 'Input file example.')
parser.add_option("--outfile_name",    type="string", default = 'outfile_1B.txt',
                        help = 'Output file.')

(options,args) = parser.parse_args()
infile    = options.infile
infile_name = infile.split('/')[-1]
outfile_name        = options.outfile_name
cwd = os.getcwd()

if os.path.isfile(infile):
	f = open(infile, "r")
else:
	f = open(infile_name, "r")
read_value = float(f.read())

print('Value in infile:  '+str(read_value))
print('Writing value to outfile:  '+str(read_value*2))
# When running on the cluster, the directory /work/user/ doesn't exist.
# Your outfile is made in the working directory whereever the job is running.
# The submission script will the transfer any new or modified files from 
# the working dir to the initialdir = $(outfile_loc), which can be /work/user/...
f_out = open(cwd+'/'+outfile_name,'w')
f_out.write(str(2*read_value)+'\n')
f_out.close()

