#!/bin/bash
path=/data2/liuzunpeng/05_Results/03_ATAC/ZK3/04_unique
for sample in {ZK3,WT}
do 
echo  $sample : 'Merge is Starting'

bam1=$path/${sample}_1/${sample}_1_no_chrY_chrM.sort.rmdup.bam
bam2=$path/${sample}_2/${sample}_2_no_chrY_chrM.sort.rmdup.bam
bam3=$path/${sample}_3/${sample}_3_no_chrY_chrM.sort.rmdup.bam
bam4=$path/${sample}_4/${sample}_4_no_chrY_chrM.sort.rmdup.bam

out=$path/${sample}
mkdir -p $out

samtools merge -@ 20 $out/${sample}_merge.bam \
$bam1 \
$bam2 \
$bam3 \
$bam4
 
echo  $sample : 'Merge is Done'

samtools index -@ 20 $out/${sample}_merge.bam
samtools flagstat $out/${sample}_merge.bam > $out/${sample}_merge.bam.flagstat
echo  $sample : 'INDEX is Done'

done
