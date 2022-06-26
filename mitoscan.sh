#!/usr/bin/bash

reformat.sh minlength=20 in=*.fastq.gz out=*.filt.fastq

bowtie2 -x yourpath/mitochondrion.cat.genomic.fna.index -U yourpath/*.filt.fastq.gz -S file.sam

rm *.filt.fastq

samtools sort file.sam -o file.sorted.sam

rm file.sam

samtools coverage file.sorted.sam -o coverage.out

rm file.sorted.sam

sed -i "1d" coverage.out | awk -F '\t' '{print($1"\t"$6)}' coverage.out | sort > nusorted

join -t $'\t' nusorted yourpath/sortedtaxa | tee joined

sort -t $'\t' -k2 -rn joined > final-list

rm joined
rm coverage.out
rm nusorted
