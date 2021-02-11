# Frequently Asked Question catalog

### Does the subMIT setup support "MPI"?

The short answer to this question is no. There are two limitations to using MPI on the computing Tier-2 computing center at Bates. First, there is limited interconnectivity between worker nodes (typically 1 Gb/sec = "weak coupling") and secondly our batch system (HTCondor) does not support the allocation of several workernodes in parallel. Condor could be set up to use MPI but we don’t do this because MPI would not run efficiently.

If needed we can set up a job to use order of 40 cores on one machine but this would need to be carefully coordinated.

### Can one mount a Docker file via Singularity?

“I want to say yes but am not 100% sure”
Let’s try to do it, and if it doesn’t work, we can work on this to get it to work
Should probably work but we should try this

### Does CVFMS have a local MIT server or global?
These are both available
Are WM allocated one per job, or is it possible that multiple jobs share the node
One node can have multiple jobs run on it.  Each job runs in its own area so they don’t interfere

### Can we freely access the large hadoop storage space?

The disk is harder to deal with than CPUs
Can always use idle CPU but cannot remove data from existing disk
If you want a lot of disk space, buy it
We can make some limited amount of space available
LNS could probably fund a standard disk to use within reasonable limits
Could buy a 10 TB disk for about $300 -- should not be a problem for experimental groups
Need to figure out the landscape to see how much space there is available
The space /mnt/T2_US_MIT/hadoop looks like a directory but is actually distributed over the network -- cannot write directly into it (and reading directly from it is bad)

### If one submits a job, by default, does it go to MIT T2 or potentially other centers such as OSG?

### Independently, when a job is submitted to OSG, does it have any higher priority compared to directly accessing OSG resource by their login nodes?

you can change which clusters you wanna access by changing a line in the condor submit requirements. you can also connect them with logical OR if you don’t care
priorities at OSG are difficult to predict or how they compare to what you suggest to do (which I don’t exactly understand :) )

### Is there a preference between using a simple submit script and a DAGman?

One condor_submit script is the simplest and in many cases sufficient solution for your task. DAGman gives you more options but is also more complicated.

### How do you guarantee the worker nodes you submit to have my software (ex. Julia) installed?

If some of the worker nodes do not have the proper software installed (ex. Julia) this needs to be brought to the attention of the system administrators so the problem can be fixed. This should not be the case though. A quick patch if this only applies to few machines, would be to submit twice as many jobs as needed to have enough output in case half fail or explicitely exclude the failing worker nodes by using the requirements.

A much better solution is to use a [singularity image which has your software installed (ex. julia)](https://support.opensciencegrid.org/support/solutions/articles/12000073449) installed. This means any machine will have your software (ex. Julia) through the mounted CVMFS image. The main failure mode then would be that the CVMFS mount fails.

### What happens if a job fails?

Look at the error file -- this generally has enough information to debug. Sometimes it is hard to track down what happens and a simple resubmission might do the trick.

### Can one resubmit a job automatically?

It is possible but you would not want this to be automatic because it could go into an infinite loop. Some software exists but is application-specific. DAGman produces rescue files and can restart from a failed state.

### Why do some jobs fail on certain machines?

Some machines are well over 10 yearss old and do not support SSE4 instructions. The library might be available on such old machines but it does no provide the assembly instructions needed to execute the given library. You can add a requirement for SSE4 instructions to be present on the workers were your job is executed:

     requirements = has_sse4_1 && ...

### Who has access to the GPUs on subMIT?

Anyone who has access to subMIT can submit to BOSCOGroup to get GPU access



Could there be an LNS Slack cluster channel to ask questions?
Currently a Slack for subMIT with a help channel but not open to everyone yet
We could make this open to everyone if there is interest
We can help each other and only elevate to higher-ups if necessary
Is there a resource to look up nodes and memory resources?
condor_status doesn’t give much information
All nodes have “at least 2 GB”; do some have 3 GB?
There are nodes with 3 GB
10 GB is too big but 3 GB would be acceptable
Is there a place to see how many have 3 GB?
Condor has some information; unclear if this specific info is available (probably yes but not 100% sure)
Does anyone do ML at MIT right now, and what resources are you currently using?
Complete hodgepodge of places to get GPUs -- pain to deal with all these
Is there a difference between using Condor to submit 100 jobs at once and just submitting the 100 jobs individually?
Different syntax but final result is the same
Different queuing systems are pretty similar under the hood
What is the best procedure to tell someone that a certain folder should be synchronized?
There was a change in paths when subMIT was upgraded; maintainers need to check this
Currently, CVMFS is implemented in a suboptimal way (involves emailing people)
Better possible solution: Organize subMIT users into groups where group folder is mirrored to CVMFS server
Need to make sure that there isn’t too much data being synchronized
Currently things are done in terms of user directories (bad since users leave)
Within 40 minutes, folders should be synchronized to CVMFS
This may change in the future
If something is not working (e.g. folder not synchronized), Slack will ultimately be right place to notify people
How do we move files around?
Is there a better solution than copying around SSH keys that doesn’t involve buying a hard drive?
Solution depends on how much space is needed
For O(100 GB), people should be given space on a drive accessible to worker nodes
For small amounts of storage like this, discussing this wastes more money (in terms of labor costs) than the disk would cost
GridFTP is a more secure way to do this than copying SSH keys (but requires OSG certificate that one can apply for)
Certificate is a bit of a pain to get but also allows other things (submitting to other clusters)
What applications might require >2 GB of RAM?
Lattice QCD
IceCube simulations took several GB, even after splitting up the runs into smaller ones
Are there constraints on cores available, especially given the 24 hour limit?
Most cores/node is 48 (with 2 GB each)
Memory is not physically assigned to a specific core (machine has a bunch of memory combined that is allocated to specific cores)
Memory is not strictly enforced but jobs can be killed if they use too much
Usually failure mode is that worker node dies if too much memory is used and then node has to be power cycled (and then there will be an investigation into what went wrong)
Do not spawn multiple jobs to try to get more resources (since this will crash the entire cluster); you will get banned from the cluster if you do this
Always test a few dozen jobs or so before trying to run several thousand
If you submit from submit.mit.edu, jobs will be automatically monitored for excessive memory usage and will be killed if they use too much memory
This is designed as a production cluster (running close to 24/7), so people will be unhappy if you crash the server
When the computing system is heterogenous, there is usually a set of attributes to request specific architectures.  Can you do this on submit.mit.edu?
There is an intermediate machine, so it’s not possible to see machine attributes directly
One really only needs to check user inputs against machine attributes
One solution: submit a test job and use this to get information about target machine
Is there a per-user limit on concurrently running jobs?
Short answer: no
However, you cannot get all nodes on a specific machine (jobs are farmed out to random machines)
One could set this up to get a specific machine, but this is not currently set up
Does condor support job dependency?
DAGman will do this (see Spencer’s talk)
I set the requirements as BOSCOGroup == "bosco_reserve" && BOSCOCluster == "ce03.cmsaf.mit.edu" and use the GPU example “condor_tensorflow.py”. I got “lbgpu0001.cmsaf.mit.edu \n Flase”. Should I set some environments before I use this example?
See examples in GitHub (https://github.com/mit-submit/submit-examples/blob/main/condor_gpu/condor.sub)
