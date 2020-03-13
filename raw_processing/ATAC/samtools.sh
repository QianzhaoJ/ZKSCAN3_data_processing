#!/bin/bash
tar=/data2/liuzunpeng/05_Results/03_ATAC/ZK3
raw=/data2/liuzunpeng/02_Data/APOE/ZK3

trim=$tar/02_trim
mapping=$tar/03_mapping

for sample in `ls $raw`
do

echo -e '#!/bin/bash'\\nsample=${sample}\\ntar=${tar}\\nraw=${raw}'

echo RMduplicates: $sample is Starting
mapping=$tar/03_mapping
uni=$tar/04_unique
picard=/data1/liuzunpeng/04_Softwares/picard.jar
sam=$mapping/$sample/${sample}.sam

result=$uni/$sample
mkdir -p $result
log=$uni/logs

bam=$result/${sample}_no_chrY_chrM.bam
unique_bam=$result/${sample}_no_chrY_chrM_unique.bam
srt_bam=$result/${sample}_no_chrY_chrM.sort.bam
srt_rmdup_bam=$result/${sample}_no_chrY_chrM.sort.rmdup.bam
METRICS_FILE=$result/${sample}.picard.matrix
idxstats_txt=$result/${sample}.sort.rmdup.idxstats.txt
flagstat_txt=$result/${sample}.sort.rmdup.flagstat.txt

awk '"'"'$3!="chrM" && $3!="chrY"'"'"' $sam | samtools view -@ 25 -S -b -q 20 > $bam 2>$result/${sample}.log &&
awk '"'"'$3!="chrM" && $3!="chrY"'"'"' $sam | grep -v 'XS:i:' | samtools view -@ 25 -bS -q 10 > $unique_bam 2>>$result/${sample}.log &&
samtools sort -@ 25 -l 9 $unique_bam -o $srt_bam 2>>$result/${sample}.log &&
java -jar $picard MarkDuplicates REMOVE_DUPLICATES=true INPUT=$srt_bam METRICS_FILE=$METRICS_FILE OUTPUT=$srt_rmdup_bam 2>>$result/${sample}.log &&
samtools index -@ 25 $srt_rmdup_bam 2>>$result/${sample}.log &&
samtools idxstats $srt_rmdup_bam > $idxstats_txt 2>>$result/${sample}.log &&
samtools flagstat  $srt_rmdup_bam > $flagstat_txt 2>>$result/${sample}.log &&

echo RMduplicates: $sample is Done'> $tar/04_unique/scripts/${sample}_unique.sh

done

echo '#!/bin/bash
scripts=./scripts
cd $scripts
for i in `ls *.sh`

do
   echo Starting: $sh 
   sh $i 

done' > $tar/04_unique/run_unique.sh
