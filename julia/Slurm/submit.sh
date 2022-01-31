#!/bin/bash
#
#SBATCH --job-name=test
#SBATCH --output=res_%j.txt
#SBATCH --error=err_%j.txt
#
#SBATCH --time=10:00
#SBATCH --mem-per-cpu=100


#If you have a conda environment and want your specific packages
#source ~/.bashrc
#conda activate julia

which julia
julia julia_test.jl
