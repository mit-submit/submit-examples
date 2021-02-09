#!/usr/bin/env python 
import os
retries = 1
njobs = 2

cwd = os.getcwd()

submit_script = cwd +'/scratch/dag.submit'
f_out = open(submit_script,'w')
outfile_loc  = cwd +'/output/' 

for job_num in range(njobs):
	
	job_name = str(job_num)+'A'
	outfile_name1 = 'outfile_'+str(job_name)+'.txt'
	condor_script = cwd+'/submit.condor'
	f_out.write("JOB\tjob" + str(job_name) +'\t' + condor_script+'\n')
	f_out.write("VARS\tjob" + str(job_name) +'\t' + 'input_float = "'+str(job_num) +'"\n')
	f_out.write("VARS\tjob" + str(job_name) +'\t' + 'outfile_loc = "'+str(outfile_loc) +'"\n')
	f_out.write("VARS\tjob" + str(job_name) +'\t' + 'outfile_name = "'+str(outfile_name1) +'"\n')
	f_out.write("RETRY\tjob" + str(job_name) +'\t' + str(retries)+'\n')

	job_name = str(job_num)+'B'
	outfile_name2 = 'outfile_'+str(job_name)+'.txt'
	condor_script = cwd+'/submit2.condor'
	f_out.write("JOB\tjob" + str(job_name) +'\t' + condor_script+'\n')
	f_out.write("VARS\tjob" + str(job_name) +'\t' + 'infile = "'+outfile_loc + '/' +outfile_name1 +'"\n')
	f_out.write("VARS\tjob" + str(job_name) +'\t' + 'outfile_loc = "'+str(outfile_loc) +'"\n')
	f_out.write("VARS\tjob" + str(job_name) +'\t' + 'outfile_name = "'+str(outfile_name2) +'"\n')
	f_out.write("RETRY\tjob" + str(job_name) +'\t' + str(retries)+'\n')
	f_out.write('PARENT job'+str(job_num)+'A CHILD job'+str(job_num)+'B\n')	
f_out.close()
print('Ouput: '+submit_script)
