# CMS work on JupyterHub

This directory has a few examples on how to analyze NanoAOD ROOT files from CMS. The first example is a simple way to read a file with uproot and operate on the data and plot. There is also a dask example using coffea to analyze many files. We will use Dask in conjunction with the Slurm Cluster on SubMIT machines. 
One of the advantages of the Slurm cluster on SubMIT is that is has access to your HOME directory. 
We can take advantage of this with Conda to have control of the environment that you use to scale up with Dask.
If you do not have a conda environment set up you can follow the instructions below.

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
conda create --name coffea python=3.9
# activate environment `coffea`
conda activate coffea
```
Install coffea, xrootd, and more.
```
conda install coffea
conda install -c conda-forge xrootd
conda install -c conda-forge ca-certificates
conda install -c conda-forge ca-policy-lcg
conda install -c conda-forge dask-jobqueue
conda install -c anaconda bokeh 
conda install -c conda-forge 'fsspec>=0.3.3'
conda install dask
pip install vector
```

## If you want to reform the samples.json (Not required)

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
