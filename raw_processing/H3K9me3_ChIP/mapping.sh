#!/bin/bash
tar=/data2/liuzunpeng/05_Results/05_ChIP/ZK3/H3K9
raw=/data2/liuzunpeng/02_Data/ZK3/ChIP

trim=$tar/02_trim
mapping=$tar/03_mapping

for sample in `ls $trim | grep "_" |grep -v 'sh'`
do

echo -e sample=${sample}\\ntar=${tar}\\nraw=${raw}'

echo Mapping: $sample is Starting
trim=$tar/02_trim
mapping=$tar/03_mapping

clean1=$trim/$sample/${sample}*1.fq.gz
clean2=$trim/$sample/${sample}*2.fq.gz

index=/data2/liuzunpeng/03_Database/MIX_Bowtie2Index/MIX

result=$mapping/$sample
log=$mapping/logs

mkdir -p $result

bowtie2 -p 25 -x $index --no-mixed --no-discordant -t -1 $clean1 -2 $clean2 -S $result/${sample}_all.sam 2>$log/${sample}_all.log

echo Mapping is Done
echo Grep is Starting

grep "hg19" $result/${sample}_all.sam > $result/${sample}_hg19.sam &&
 
grep "dm3" $result/${sample}_all.sam > $result/${sample}_dm3.sam &&

sed -i "1s/^/@HD\\tVN:1.0\\tSO:unsorted\\n/" $result/${sample}_hg19.sam &&

sed -i "1s/^/@HD\\tVN:1.0\\tSO:unsorted\\n/" $result/${sample}_dm3.sam &&

rm $result/${sample}_all.sam

echo Grep: $sample is Done' > $mapping/scripts/${sample}_mapping.sh

done

echo '#!/bin/bash
scripts=./scripts
cd $scripts
for i in `ls *.sh`

do

   echo Starting: $sh 
   sh $i 

done' >$mapping/run_mapping.sh
