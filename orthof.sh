#!/bin/bash
#SBATCH -N 2
#SBATCH --mem=400GB
#SBATCH -p LM
#SBATCH --ntasks-per-node 28
#SBATCH -t 12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user

# echo commands to stdout
set -x

#working dir
cd /pylon2/bi4ifup/caplins

#get dependencies set up ****note*** this requires having a local instal of python and dlcpar installed into that local python

#Blast dependency
module load blast
#to find the dlcpar dependency
export PATH=/pylon2/bi4ifup/caplins/python/:$PATH
#to make the local python the only python version used
export PYTHONPATH=/pylon2/bi4ifup/caplins/python
#check to see which python is being used. should print the above path
which python
#mcl
PATH=$PATH:$HOME/local/bin
#fastme
PATH=$PATH:$HOME/bin/bin
#dlcpar
PATH=$PATH:/pylon2/bi4ifup/caplins/dlcpar-1.0/bin/

##for -t parallelises BLAST and tree inference and gene tree reconciliation. Use as many threads as there are cores available. For -a saves time when using pre-computed blast results

OrthoFinder-1.1.2/orthofinder -f orthofind_new_willowi/pep_Alderia_Ecorn/ -t 56 -a 28
