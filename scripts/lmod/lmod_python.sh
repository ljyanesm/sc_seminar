#!/usr/bin/bash

echo -e "\nWhich python version is available?"
which python

sleep 1

echo -e "\nLet's change it to HPC python 2.7"
ml python/2.7
which python

sleep 1

echo -e "\nNow we will load numpy (latest version available is the default)"
echo -e "ml numpy"
ml numpy

echo -e "\nLet's see what modules I have now"
echo -e "ml"

ml
sleep 1

echo -e "\nOk, now I want to check which modules I can load based on my current ones"
echo -e "ml avail"

ml avail
sleep 5

echo -e "\nNow I want python 3.5 instead of 2.7, let's see what happens..."
ml python/3.5
which python
