#!/bin/bash
#SBATCH -N 1
#SBATCH -p RM
#SBATCH -t 48:00:00
#SBATCH -n 28
#SBATCH --mail-user=sacaplins@ucdavis.edu
#SBATCH --mail-type=ALL

echo commands to stdout
set -x

cd /pylon5/bi4ifup/caplins/dnds_slugs/nt_trimmed_alignments/intermediatefiles

module load mafft

#define the names
for filename in ../alignments/fastagen_nt/*
do

        cd /pylon5/bi4ifup/caplins/dnds_slugs/nt_trimmed_alignments/intermediatefiles

        base=$(basename $filename)
        echo $base

#make directory for each name
mkdir ${base}

#within each directory do the thing
cd ${base}
perl ../../translatorx_vLocal.pl -i ../../alignments/fastagen_nt/${base} -o ${base}.out -p F -t F

done
