#!/bin/bash

# No hay gcc
gcc --version
sleep 1
## source gcc 4.9.1
echo "source gcc-4.9.1"
source gcc-4.9.1
gcc --version
sleep 1
## source gcc 5.2.0
echo "source gcc-5.2.0"
source gcc-5.2.0
gcc --version
sleep 1
## Back to 4.9.1
echo "Back to 4.9.1"
echo "source gcc-4.9.1"
source gcc-4.9.1
gcc --version
echo "Still in 5.2.0"
