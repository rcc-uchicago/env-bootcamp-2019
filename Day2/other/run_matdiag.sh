#/bin/bash

# LOAD THE PYTHON 3.5 MODULE
#module load python/3.5.2
module load Anaconda3

if [ "$#" -lt 1 ]; then
   echo "     USAGE: "
   echo "            ./run.sh <matrix dimension>  "
   echo " "
   echo "     REQUIRED ARGUMENTS:" 
   echo "            <matrix dimension> : N dimension of matrix "
   echo "     OPTIONAL ARGUMENTS:" 
   echo "            <num_threads>      : Number of threads to use (Default is 1) "
   echo "            ./run.sh <matrix dimension> <num_threads>"
   echo " "
   exit 1
else
   MAT_DIM=$1
fi
# GET MATRIX SIZE ARGUMENT IF SET
if [ "$#" -ge 2 ]; then
   NUM_THREADS=$2
else
   NUM_THREADS=1
fi
# SET NUMBER OF THREADS TO USE WITH UNDERLYING MATH LIBRARY
export OMP_NUM_THREADS=$NUM_THREADS
echo ""
echo "RUNNING $prog_name FOR MATRIX SIZE: [ $MAT_DIM x $MAT_DIM ] WITH $OMP_NUM_THREADS THREADS"
python matdiag.py $MAT_DIM
echo ""

# DOUBLE NUMBER OF THREADS TO USE WITH UNDERLYING MATH LIBRARY
export OMP_NUM_THREADS=$(($MAT_DIM * 2))
echo ""
echo "RUNNING $prog_name FOR MATRIX SIZE: [ $MAT_DIM x $MAT_DIM ] WITH $OMP_NUM_THREADS THREADS"
python matdiag.py $MAT_DIM
echo ""
