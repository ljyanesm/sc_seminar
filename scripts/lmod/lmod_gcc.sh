#!/bin/bash

# No hay gcc
gcc --version
sleep 1
## source gcc 4.9.1
echo "ml gcc/4.9.1"
ml gcc/4.9.1
gcc --version
sleep 1
## source gcc 5.2.0
echo "ml gcc/5.2.0"
ml gcc/5.2.0
gcc --version
sleep 1
## Back to 4.9.1
echo "Back to 4.9.1"
echo "ml gcc/4.9.1"
ml gcc/4.9.1
gcc --version
echo "Correct version of GCC now"
