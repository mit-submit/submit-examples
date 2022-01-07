## Test all

Simple setup to run a lightweight test pf relevant components. 

### Installation

    clone git://github.com/mit-submit/submit-examples

### Generate a submit file (./submit) of jobs 1 to 10

* cd submit-examples/test-all
* ./generate_sub 1 10

### Submit the jobs

* condor_submit ./submit

### Check what is going on

* condor_q

### Output

Output will be created: test-all_{1-10}.{out,err}, test.log
