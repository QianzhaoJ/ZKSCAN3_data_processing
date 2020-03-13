#!/bin/bash

function SubSample {

## Calculate the sampling factor based on the intended number of reads:
FACTOR=$(samtools idxstats $1 | cut -f3 | awk -v COUNT=$2 'BEGIN {total=0} {total += $1} END {print COUNT/total}')

if [[ $FACTOR > 1 ]]
  then 
  echo '[ERROR]: Requested number of reads exceeds total read count in' $1 '-- exiting' && exit 1
fi

sambamba view -s $FACTOR -f bam -l 9 -t 20 $1

}

path=/data2/liuzunpeng/05_Results/03_ATAC/APOE/04_unique
for sample in {WT,ZK3}
do

sample=APOE
inbam=$path/${sample}/${sample}_merge.bam
n=
outbam=$path/${sample}/${sample}_merge.extract.bam

SubSample $inbam $n > $outbam

sambamba flagstat -t 5 $outbam > $path/${sample}/${sample}_merge.extract.bam.flagstat
 
done
