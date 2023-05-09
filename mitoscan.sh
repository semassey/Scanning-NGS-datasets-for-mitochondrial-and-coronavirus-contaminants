#!/usr/bin/bash

# removing reads < 20 bp in length will improve mapping accuracy

reformat.sh minlength=20 in=*.fastq.gz out=*.filt.fastq

# an additional potential step is to add a masking procedure to remove low-complexity regions, this may remove false mapping positives
# bbmask.sh can be used for this h/t Henjin

bowtie2 -x yourpath/mitochondrion.cat.genomic.fna.index -U yourpath/*.filt.fastq.gz -S file.sam

rm *.filt.fastq

samtools sort file.sam -o file.sorted.sam

rm file.sam

samtools coverage file.sorted.sam -o coverage.out

rm file.sorted.sam

sed -i "1d" coverage.out 

awk -F '\t' '{print($1"\t"$4"\t"$6)}' coverage.out | sort > nusorted

join -t $'\t' nusorted yourpath/sortedtaxa | tee joined

sort -t $'\t' -k3 -rn joined > mito-reads-cov

sed -i "1 i Accession\t#Reads\t%Coverage\tSpecies" mito-reads-cov

rm joined
rm coverage.out
rm nusorted
