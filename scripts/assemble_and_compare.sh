#!/usr/bin/env

#Requires 
#SPAdes assembler (http://cab.spbu.ru/software/spades/)
#QUAST to compare assembly with a reference genome and output assembly metrics (can also use without a reference genome by altering code) (http://quast.sourceforge.net/quast)
#Go to directory with data that has passed quality control and trimming

mkdir ASSEMBLIES #assemblies output directory

for i in $(ls *_paired.fastq | rev | cut -c 26- | rev | uniq)
do
##will have to change number after -c for different filenames
#uses paired and unpaired reads
echo "$i"
spades.py -k 21,33,55,77,99,127 --careful -o ASSEMBLIES/${i}_assembly -1 ${i}_L001_R1_001_paired.fastq -2 ${i}_L001_R2_001_paired.fastq --pe1-s ${i}_L001_R1_001_unpaired.fastq --pe1-s ${i}_L001_R2_001_unpaired.fastq

#run quast to compare with reference genome
#reference assembly files to compare to -can change to any reference required once there is a fasta and gff file available for it (fasta and gff file must be from the same version of the assembly)
REF_FASTA='NC_007793.fna' #used a USA300 reference genome
REF_GFF='NC_007793.gff'
python quast.py ASSEMBLIES/${i}_assembly/scaffolds.fasta -o ASSEMBLIES/${i}_assembly/quast_${i} -R $REF_FASTA -G $REF_GFF -O $REF_GFF --min-contig 500 -t 100 -T 12 -l $i -f -s

#-t 100 means calcualte stats on contigs over 100 bases in length
#-l is the label for the file -name of reads used
#-T is number of processors
done
