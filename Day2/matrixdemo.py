#!/usr/bin/env python

# We use this short Python script to explore the computation involved
# in an operation (multiplication) on a large matrix; this sort of
# computation would be needed, for example, to estimate the p x p
# covariance matrix for a large number of variables (p).
import sys
import time
import numpy

# Set the matrix dimensions.
if len (sys.argv) == 3:
   n = int(sys.argv[1])
   p = int(sys.argv[2])
else:
   n = 8000
   p = 12000

# CREATE DATA
# -----------
# Create a random matrix, X.
print('Creating %d x %d matrix, X.' % (n,p))
X = numpy.random.random_sample((n,p))

# MATRIX COMPUTATION
# ------------------
# Compute X'*X.
print('Computing X\'*X (transpose of X times X).')
t = time.time()
R = X.T @ X
print('Computation took %0.2f seconds.' % (time.time() - t))
