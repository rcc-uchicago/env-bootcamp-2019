#!/bin/bash

# This bash script illustrates how to use the sbatch command in Slurm
# to submit a job to the edu partition.

#SBATCH --job-name=matrixdemo
#SBATCH --output=matrixdemo.out
#SBATCH --error=matrixdemo.err
#SBATCH --partition=edu
#SBATCH --account=env_bootcamp
#SBATCH --time=00:10:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G

# For reproducibility, add version number to "module load" call.
module load Anaconda3/2019.03

# Run the python script.
echo "Running matrixdemo.py"
export OMP_NUM_THREADS=1
python3 matrixdemo.py 8000 12000
