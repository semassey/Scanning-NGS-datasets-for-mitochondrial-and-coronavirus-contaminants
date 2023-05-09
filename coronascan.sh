#!/usr/bin/bash

# the -a and --non-deterministic bowtie2 options improve multi-mapping of reads to multiple genomes in the dataset

bowtie2 -x Yourpath/allcoronavirus.fa.index -U Yourpath/*.fq -S file.sam -a --non-deterministic

samtools sort file.sam -o file.sorted.sam

rm file.sam

samtools coverage file.sorted.sam -o coverage.out

sed -i "1d" coverage.out 

awk -F '\t' '{print($1"\t"$4"\t"$6)}' coverage.out | sort -t $'\t' -k3 -rn > corona-reads-cov

sed -i "1 i Accession\t#Reads\t%Coverage" corona-reads-cov


rm joined
rm coverage.out
rm file.sorted.sam
