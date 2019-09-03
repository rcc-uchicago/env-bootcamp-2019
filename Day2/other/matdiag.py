import sys
import time
import numpy as np
import scipy.linalg

# scipy linalg and numpy linalg routines should perform
# nearly identically if they are both built with the same
# blas and lapack. 
# NOTE: This is not the case for some midway python modules. 
#       The Anaconda distribution always comes withthe mkl
#       binaries in the lib folder so that numpy and scipy
#       in Anaconda come linked to these fast math libraries
#       which are setup to take advantage of threading. You
#       can uncomment the numpy linalg code block below to 
#       compare timing for your scipy and numpy builds

if len (sys.argv) == 2 :
   mat_size = int(sys.argv[1])
else:
   mat_size = 10 

# Set matrix dimensions
# Use seed for reproducible random numbers
np.random.seed(0)
rand_mat = np.random.rand(mat_size, mat_size)

# Create symmetric matrix from random matrix
sym_mat = np.dot(rand_mat,rand_mat.T)

# NUMPY LINALG
# UNCOMMENT THE FOLLOWING TWO LINES FOR INFO ON MATH LIBRARIES LINKED
#print("NUMPY CONFIGURATION:")
#print(np.__config__.show())

# Compute eigenvalues using numpy linalg function eigvals
#t = time.time()
#eigvals = np.linalg.eigvals(sym_mat)
#elapsed_time = time.time() - t
#print('USING NUMPY EIGVALS FUNCTION:')
#print('  TIME ELAPSED:  %s SECONDS.' % (elapsed_time))

# SCIPY LINALG
# UNCOMMENT THE FOLLOWING TWO LINES FOR INFO ON MATH LIBRARIES LINKED
# print("SCIPY CONFIGURATION:")
# print(scipy.__config__.show())

# Compute eigenvalues using scipy linalg function  eigvals
t = time.time()
eigvals = scipy.linalg.eigvals(sym_mat)
elapsed_time = time.time() - t
print('USING SCIPY EIGVALS FUNCTION:')
print('  TIME ELAPSED:  %s SECONDS.' % (elapsed_time))
print('MAX EIGENVALUE: %s' % (np.real(eigvals.max()) ))
print('MIN EIGENVALUE: %s' % (np.real(eigvals.min()) ))
# EOF
