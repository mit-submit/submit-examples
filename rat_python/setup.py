#!/usr/bin/env python 
import os

cwd = os.getcwd()
submit_script = cwd+'/scratch/sub.submit'

run_program = cwd + '/run.sh'

njobs = 2
f_out = open(submit_script,'w')

f_out.write("Executable            = "+run_program+" \n") 
f_out.write("Universe              = vanilla"+'\n')
f_out.write("GetEnv                = True"+'\n')
f_out.write("transfer_input_files  = "+cwd+"/electron-demo.mac"+'\n')
f_out.write("should_transfer_files = YES"+'\n')
f_out.write("initialdir            = "+cwd+"/output/\n")
f_out.write("WhenToTransferOutput  = ON_EXIT_OR_EVICT"+'\n')
f_out.write('+SingularityImage     = "/cvmfs/singularity.opensciencegrid.org/opensciencegrid/osgvo-el7:latest"'+'\n')
f_out.write("\n")

for job_num in range(njobs):
	f_out.write('Arguments\t\t= electron-demo.mac -s '+str(job_num)+' -o outfile_'+str(job_num)+'.root\n')
        f_out.write("transfer_output_files\t= outfile_"+str(job_num)+'.root'+'\n')
        f_out.write("Output\t\t\t= "+ cwd+'/scratch/electron-demo_'+str(job_num)+'.out'+'\n')
	f_out.write("Log\t\t\t= "+ cwd+'/scratch/electron-demo_'+str(job_num)+'.log'+'\n')
	f_out.write("Error\t\t\t= "+ cwd+'/scratch/electron-demo_'+str(job_num)+'.err'+'\n')
	f_out.write("Queue\n\n")

f_out.close()
print('Ouput: '+submit_script)
