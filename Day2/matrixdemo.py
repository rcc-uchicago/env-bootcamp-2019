#!/usr/bin/env python

# SET UP ENVIRONMENT
# ------------------
# We use this short Python script to explore the computation involved
# in an operation (multiplication) on a large matrix; this sort of
# computation would be needed, for example, to estimate the p x p
# covariance matrix for a large number of variables (p).
import sys
import time
import numpy

# SCRIPT PARAMETERS
# -----------------
# Set the matrix dimensions.
n = int(sys.argv[1])
p = int(sys.argv[2])

# CREATE DATA
# -----------
# Create a random matrix, X.
print('Creating %d x %d matrix, X.' % (n,p))
X = numpy.random.random_sample((n,p))

# COMPUTE RESULTS
# ---------------
# Compute X'*X.
print('Computing X\'*X (transpose of X times X).')
t = time.time()
R = X.T @ X
print('Computation took %0.2f seconds.' % (time.time() - t))

# SESSION INFO
# ------------
# TO DO.
