#!/bin/bash

tar=/data2/liuzunpeng/05_Results/03_ATAC/ZK3
raw=/data2/liuzunpeng/02_Data/APOE/ZK3

for sample in `ls $raw`
do

echo -e '#!/bin/bash'\\ntar=${tar}\\nraw=${raw} >$tar/07_MACS2/scripts/${sample}_peak.sh
echo sample=$sample'
echo Peak calling: $sample is Starting
uni=$tar/04_unique/$sample
bed=$tar/05_bamtobed
remove_BL_bed=$bed/$sample/${sample}_no_chrM_chrY_unique.sort.rmdup.remove_BL.bed
macs_stat=/data2/liuzunpeng/03_Database/ATAC/macs_stat.pl

peak=$tar/07_MACS2/$sample
log=$tar/07_MACS2/logs

peaks_xls=$peak/${sample}_peaks.xls
peaks_bed=$peak/${sample}.macs2.peaks.bed
peak_stat=$peak/${sample}.MACS2_peak_stat.txt

mkdir -p $peak

macs2 callpeak -t $remove_BL_bed -f BED -g hs -B --nomodel --shift 0 --extsize 250 --call-summits -q 0.01 -n $sample --outdir $peak 2>$log/${sample}.log &&
echo Calling peak: $sample is Done &&
echo Stat: $sample is Starting &&
grep '"'"'^chr\S'"'"' $peaks_xls | awk '"'"'{print $1"\t"$2"\t"$3"\t"$10"\t"$8"\t""+"}'"'"' >$peaks_bed &&
perl $macs_stat $peaks_bed > $peak_stat &&

anno=$peak/anno 
mkdir -p $anno 
echo Homer annotion
annotatePeaks.pl $peaks_bed hg19 -genomeOntology $anno -annStats $anno/${sample}_stat.txt >$anno/${sample}_peak_anno.txt 2>>$log/${sample}.log

echo Stat: $sample is Done ' >>$tar/07_MACS2/scripts/${sample}_peak.sh
done

echo '#!/bin/bash
scripts=./scripts
cd $scripts
for i in `ls *.sh`

do 
    nohup sh $i &

done' >$tar/07_MACS2/run_peak.sh
