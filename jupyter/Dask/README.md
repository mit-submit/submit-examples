# Dask on JupyterHub

This directory has an example on how to use Dask in conjunction with the Slurm Cluster on SubMIT machines. 
One of the advantages of the Slurm cluster on SubMIT is that is has access to your HOME directory. 
We can take advantage of this with Conda to have control of the environment that you use to scale up with Dask.
If you do not have a conda environment set up you can follow the instructions below.

## Requirements
### Dask packages installation with Miniconda

If you need to install conda do the following:

```
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
# Run and follow instructions on screen
bash Miniforge3-Linux-x86_64.sh
```
NOTE: always make sure that conda, python, and pip point to local Miniconda installation (`which conda` etc.).

You can either use the default environment`base` or create a new one:
```
# create new environment with python 3.9, e.g. environment of name `dask`
conda create --name dask python=3.9
# activate environment `dask`
conda activate dask
```
Install coffea, xrootd, and more. SUEP analysis uses Fastjet with awkward array input (fastjet>=3.3.4.0rc8) and vector:

```
conda install -c conda-forge dask-jobqueue
conda install dask
```

## How to modify for your own needs

This notebook showed a very simple example of how to use Dask. The example in the notebook was a simple addition use of dask. Of course this can be changed to do more complex operations or to interplay with other packages. The cluster setup can remain the same and you only need to modify the functions near the end of the notebook to get on your way.


