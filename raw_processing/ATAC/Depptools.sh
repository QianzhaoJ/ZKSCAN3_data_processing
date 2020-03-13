#!/bin/bash
tar=/data2/liuzunpeng/05_Results/03_ATAC/ZK3
raw=/data2/liuzunpeng/02_Data/ZK3/ATAC3

trim=$tar/02_trim
mapping=$tar/03_mapping
uni=$tar/04_unique
deep=$tar/08_deeptools

for sample in {APOE,WT}
do
echo -e '#!/bin/bash'\\nsample=${sample}\\ntar=${tar}\\nraw=${raw}'
uni=$tar/04_unique
deep=$tar/08_deeptools
echo Deeptools: $sample is Starting
srt_rmdup_bam=$uni/${sample}/${sample}_merge.extract.bam
#########################
bin=10
result=$deep/${sample}/bin${bin}
mkdir -p $result
bw=$result/${sample}_bin${bin}_extend_250.bw
bg=$result/${sample}_bin${bin}_extend_250.bedGraph
log=$deep/logs/${sample}_bin${bin}.log
echo binSize=10  normalization= RPKM  extendReads=250   Application= Track 
bamCoverage -p 20 -b $srt_rmdup_bam -o $bw --normalizeUsingRPKM --binSize $bin --extendReads 250 --ignoreForNormalization chrX chrM chrY 2>$log &&
bamCoverage -p 20 -b $srt_rmdup_bam --outFileFormat bedgraph -o $bg --normalizeUsingRPKM --binSize $bin --extendReads 250 --ignoreForNormalization chrX chrM chrY 2>>$log
echo binSize=$bin is Done
########################
bin=100
result=$deep/${sample}/bin${bin}
mkdir -p $result
bw=$result/${sample}_bin${bin}_extend_250.bw
bg=$result/${sample}_bin${bin}_extend_250.bedGraph
log=$deep/logs/${sample}_bin${bin}.log
echo binSize=$bin  normalization= RPKM  extendReads=250   Application= TSS
bamCoverage -p 20 -b $srt_rmdup_bam -o $bw --normalizeUsingRPKM --binSize $bin --extendReads 250 --ignoreForNormalization chrX chrM chrY 2>$log &&
bamCoverage -p 20 -b $srt_rmdup_bam --outFileFormat bedgraph -o $bg --normalizeUsingRPKM --binSize $bin --extendReads 250 --ignoreForNormalization chrX chrM chrY 2>>$log 
echo binSize=$bin is Done
#######################
bin=2000
result=$deep/${sample}/bin${bin}
mkdir -p $result
bw=$result/${sample}_bin${bin}.bw
bg=$result/${sample}_bin${bin}.bedGraph
log=$deep/logs/${sample}_bin${bin}.log
echo binSize=$bin  normalization= RPKM  extendReads= no  Application= replication
bamCoverage -p 20 -b $srt_rmdup_bam -o $bw --normalizeUsingRPKM --binSize $bin --ignoreForNormalization chrX chrM chrY 2>$log &&
bamCoverage -p 20 -b $srt_rmdup_bam --outFileFormat bedgraph -o $bg --normalizeUsingRPKM --binSize $bin --ignoreForNormalization chrX chrM chrY 2>>$log 
echo binSize=$bin is Done
echo Deeptools: $sample is Ending' > $deep/scripts/${sample}_deep.sh

done

echo '#!/bin/bash
scripts=./scripts
cd $scripts
for i in `ls *.sh`

do
   echo Starting: $sh 
   sh $i 

done' >$deep/run_deep.sh
