#!/bin/bash

tar=/data2/liuzunpeng/05_Results/03_ATAC/ZK3
raw=/data2/liuzunpeng/02_Data/APOE/ZK3
trim=$tar/02_trim

for sample in `ls $raw`
do
echo '#!/bin/bash' >$trim/scripts/${sample}_trim.sh
echo -e sample=${sample}\\ntar=$tar\\nraw=$raw'

echo Trimming: $sample is Starting

trim=$tar/02_trim
log=$trim/logs

fq1=$raw/$sample/${sample}_1.fq.gz
fq2=$raw/$sample/${sample}_2.fq.gz

result=$trim/$sample
mkdir $result

trim_galore --fastqc --path_to_cutadapt /data1/liuzunpeng/04_Softwares/anaconda/bin/cutadapt --stringency 3 --paired --output_dir $result $fq1 $fq2 2>$log/${sample}.log

echo Trimming: $sample is Done' >> $trim/scripts/${sample}_trim.sh
done

echo '#!/bin/bash
scripts=./scripts
cd $scripts
for i in `ls *.sh`

do 
    nohup sh $i &

done' >$trim/run_trim.sh
