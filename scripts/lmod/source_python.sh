#!/usr/bin/bash

# Loading spanki
echo -e "Starting interactive session\n"
echo -e "source spanki-0.5.0"
source spanki-0.5.0
echo -e "spankijunc -h"
spankijunc  -h

echo -e "\n\nSpanki seems to be working fine, what is my current python version?\n"
which python

sleep 1
clear
# Then trying to work with Mikado
echo -e "Ok, now I need to use Mikado\n"
echo "source mikado-0.19.2"
source mikado-0.19.2
echo "python -c \"import Mikado\""
python -c "import Mikado"

echo -e "\nMikado fails... Let's check the python version"
# Mikado fails, it might be the python version...
echo "which python\n"
which python

echo -e "\nIt seems like python 2.7 is still loaded. I'll source python 3.5"
# Oh yeah, it seems to be the python version. I'll change it
echo -e "source python-3.5.1"
source python-3.5.1
echo "python -c \"import Mikado\""
python -c "import Mikado"
# Mikado fails again... What happened?
echo "Faled to use Mikado again... What happened?"
echo "which python"
which python
echo "It seems like the python version never changed =("
#It didn't change the python version =(

