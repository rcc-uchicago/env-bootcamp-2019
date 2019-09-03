#!/bin/bash

# This bash script illustrates how to use the sbatch command in SLURM
# to submit a job to the broadwl partition.

#SBATCH --partition=broadwl
#SBATCH --time=00:10:00
#SBATCH --cpus-per-task=8

# For reproducibility, add version number to "module load" call.
module load Anaconda3/5.1.0

# Run the python script.
echo "Running matrixdemo.py"
export OMP_NUM_THREADS=8
python matrixdemo.py
