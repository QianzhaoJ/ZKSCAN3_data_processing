#!/bin/bash
tar=/data2/liuzunpeng/05_Results/03_ATAC/ZK3
raw=/data2/liuzunpeng/02_Data/APOE/ZK3

trim=$tar/02_trim
mapping=$tar/03_mapping

for sample in `ls $raw`
do

echo '#!/bin/bash' >$mapping/scripts/${sample}_mapping.sh

echo -e sample=${sample}\\ntar=${tar}\\nraw=${raw}'

echo Mapping: $sample is Starting
trim=$tar/02_trim
mapping=$tar/03_mapping

clean1=$trim/$sample/${sample}*1.fq.gz
clean2=$trim/$sample/${sample}*2.fq.gz

index=/data1/liuzunpeng/03_Database/00_genome/01_hg19/03_Ensembl/01_fa_gtf_bed_chr/02_bowtie2_index/hg19

result=$mapping/$sample
log=$mapping/logs

mkdir -p $result

bowtie2 -p 20 -x $index --no-mixed --no-discordant -t -1 $clean1 -2 $clean2 -S $result/${sample}.sam 2>$log/${sample}.log

echo Mapping: $sample is Done

echo Stat: $sample is Starting

awk '"'"'$3!="chrM" && $3!="chrY" && $9 !="0" {print $9}'"'"' $mapping/$sample/${sample}.sam | grep -v "-" > $mapping/$sample/${sample}_length.txt &&

Rscript $tar/scripts/length_plot.r -i $mapping/$sample/ -s $sample

echo Stat: $sample is done' >> $mapping/scripts/${sample}_mapping.sh

done

echo '#!/bin/bash
scripts=./scripts
cd $scripts
for i in `ls *.sh`

do
   echo Starting: $sh 
   sh $i 

done' >$mapping/run_mapping.sh
