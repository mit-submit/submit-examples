# Dask on JupyterHub

This directory has a few examples on how to use Dask in conjunction with the Slurm Cluster on SubMIT machines. 
One of the advantages of the Slurm cluster on SubMIT is that is has access to your HOME directory. 
We can take advantage of this with Conda to have control of the environment that you use to scale up with Dask.
If you do not have a conda environment set up you can follow the instructions below.

## How to modify for your own needs (General: Dask_Slurm_Example.ipynb)

This notebook showed a very simple example of how to use Dask. The example in the notebook was a simple addition use of dask. Of course this can be changed to do more complex operations or to interplay with other packages. The cluster setup can remain the same and you only need to modify the functions near the end of the notebook to get on your way.

## How to modify for your own needs (CERN specific: Dask_Slurm_Coffea.ipynb)

This is an easy place to start for studies. If you want to modify this, there are only a few changes that need to be done. To make an analysis you need to modify the code in the Simple_Process. In the processor you can control the histograms that you want to write out as well as modifying the code to analyze the NanoAOD files. 

The only other change that is necessary is that you can form the sample.json file to analyze the datasets that you are interested in. In order to make this json file follow the instructions below in the  Rucio_JSON_Maker directory.

Check to see if you have rucio available
```
pip install rucio
pip install rucio-clients
```

Set up the Rucio to use

```
export RUCIO_ACCOUNT=yourcernusername
source /cvmfs/cms.cern.ch/rucio/setup-py3.sh
```

And then run to create a sample.json

```
python3 listSources.py --dsets listofdatasets.txt --json sample.json
```

## Requirements
### Coffea installation with Miniconda

If you need to install conda do the following:

```
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
# Run and follow instructions on screen
bash Miniforge3-Linux-x86_64.sh
```
NOTE: always make sure that conda, python, and pip point to local Miniconda installation (`which conda` etc.).

You can either use the default environment`base` or create a new one:
```
# create new environment with python 3.9, e.g. environment of name `coffea`
conda create --name dask python=3.9
# activate environment `coffea`
conda activate dask
```
Install coffea, xrootd, and more. SUEP analysis uses Fastjet with awkward array input (fastjet>=3.3.4.0rc8) and vector:
```
conda install coffea
conda install -c conda-forge xrootd
conda install -c conda-forge ca-certificates
conda install -c conda-forge ca-policy-lcg
conda install -c conda-forge dask-jobqueue
conda install -c anaconda bokeh 
conda install -c conda-forge 'fsspec>=0.3.3'
conda install dask
conda install pytables
pip install --pre fastjet
pip install vector
