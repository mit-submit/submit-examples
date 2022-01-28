#!/usr/bin/env python
import os,sys;

arg = sys.argv[1]

machine = os.getenv('HOSTNAME')
user = os.getenv('USER')
pwd = os.getenv('PWD')
print "\n Execute on %s by %s in directory %s\n Argument: %s\n"%(machine,user,pwd,arg)

cmd = "sed matrix_product_states.m-template -e s'/XX-MYID-XX/%s/' > matrix_product_states.m"%(arg)
os.system('ls -lhrt; %s'%(cmd));

cmd = "/data/t3home000/matlab/MATLAB/R2019b/bin/matlab -batch "
os.system('ls -lhrt; %s \"run ./matrix_product_states.m\"'%(cmd));

print "\n DONE.\n"
