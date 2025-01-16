### Dask Gateway

These are some examples to use the submit dask-gateway. Jupyter notebooks are provided. Some instructions on how to build an example conda environment are below.

## Building a conda environment

To start from scratch you can build an environment to work with dask-gateway. The name of the conda environment will need to be matched in the notebooks.

```bash
conda create --name gateway python=3.9
conda activate gateway
conda install -c conda-forge dask-gateway
conda install ipywidgets
```

Please note that if you have multiple conda environments, this can cause issues for the gateway.

