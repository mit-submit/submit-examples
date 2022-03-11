#!/bin/bash
#
#SBATCH --job-name=test
#SBATCH --output=res_%j.txt
#SBATCH --error=err_%j.txt
#
#SBATCH --time=10:00
#SBATCH --mem-per-cpu=100
#SBATCH --partition=submit-gpu
#SBATCH --gres=gpu:2  
#SBATCH --cpus-per-gpu=4

srun hostname
python cuda_example.py
