This is a set of scripts used to analyze transcriptomic data for signals of positive selection (dn/ds >1)

# ID Orthogroups
using the program orthofinder to find orthogroups


# One-to-One orthologs R script

use script `extractfastas.R` to identify all 1:1:1 orthogroups, to match sequence files with orthogroups, and make individual fasta files for each orthogroup. This code is via http://arken.nmbu.no/~larssn/teach/bin310/week8.html, with modifications. 


# nt and aa alignments plus trees

use program Translatorx via shell script `tx_align_aa_nt.sh` to convert nt files to aa and make alignments in Mafft

# run paml 





