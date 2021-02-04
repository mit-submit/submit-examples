#!/usr/bin/env python
import os;

machine = os.getenv('HOSTNAME')
user = os.getenv('USER')
pwd = os.getenv('PWD')

print "\n Execute on %s by %s in directory %s\n\n"%(machine,user,pwd)
cmd = "/data/t3home000/matlab/MATLAB/R2019b/bin/matlab -batch "
os.system('ls -lhrt; %s \"run ./do_something.m\"'%(cmd));

print "\n DONE.\n"
