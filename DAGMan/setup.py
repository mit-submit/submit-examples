#!/usr/bin/env python 

cwd = os.getcwd()
condor_script = cwd+'/submit.condor'
retries = 2
njobs = 3

submit_script = cwd+'/scratch/dag.submit'
f_out = open(submit_script,'w')
for job_num in range(njobs):
	outfile_name = 'outfile_'+str(job_num)+'A.txt'
	outfile_loc  = cwd+'/output/' 
	f_out.write("JOB\tjob" + str(job_num) +'\t' + condor_script+'\n')
	f_out.write("VARS\tjob" + str(job_num) +'\t' + 'input_float = "'+str(job_num) +'"\n')
	f_out.write("VARS\tjob" + str(job_num) +'\t' + 'outfile_loc = "'+str(outfile_loc) +'"\n')
	f_out.write("VARS\tjob" + str(job_num) +'\t' + 'outfile_name = "'+str(outfile_name) +'"\n')
	f_out.write("RETRY\tjob" + str(job_num) +'\t' + str(retries)+'\n')
	
f_out.close()
print('Ouput: '+submit_script)
