# Intro to Julia

Options for both HTCondor and Slurm

## Running HTCondor

```
condor_submit submit
```

## Running Slurm

```
sbatch submit
```

### If you want control of your own Julia packages in Slurm you can use conda

```
conda create -n julia -c conda-forge julia
```

You can then activate this environment with

```
conda activate julia
```

For the Slurm submissions you merely need to uncomment the 2 lines in the submit file in order to use your conda environment in your slurm job.
