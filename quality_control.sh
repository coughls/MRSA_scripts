#Requires these tools:
#FASTQC
#Trimmomatic
#fastx_quality_stats fromn the FASTX toolit
#get_seq_len_fastq_2.py #(in this repository) 


#Run FASTQC
fastqc *.fastq -t 12 -o FASTQC #uses 12 threads

#Quality Trim
##parameters for trimmomatic
l=30   #quality score threshold to trim bases below
w=4  #windowsize
minlen=36  #min length of reads to retain. Reads discarded if they below this length after trimming
##can change the adapaters specified by changing the file after ILLLUMINACLIP


mkdir TRIMMED #directory for output files
#the number after -c may will also need to be changed if filenames are different
for i in $(ls *.fastq | rev | cut -c 19- | rev | uniq)
do
echo "$i"
java -jar trimmomatic-0.32.jar  PE -threads 12 -phred33 -trimlog ${i}.log ${i}_L001_R1_001.fastq ${i}_L001_R2_001.fastq TRIMMED/${i}_L001_R1_001_paired.fastq TRIMMED/${i}_L001_R1_001_unpaired.fastq TRIMMED/${i}_L001_R2_001_paired.fastq TRIMMED/${i}_L001_R2_001_unpaired.fastq ILLUMINACLIP:/home/simone/software/Trimmomatic-0.32/adapters/NexteraPE-PE.fa:2:30:10 LEADING:$l TRAILING:$l SLIDINGWINDOW:$w:$l MINLEN:$minlen
done

##Get some other quality metrics
#output directories
mkdir LENS
mkdir QUALSTATS

#make function to calculate quality statistics
quality_metrics(){
#Q of 33 needs to be changed for some files produced by different sequencers -fastqc can tell the illumina/solexa etc file type and googling will retrieve its phred qua
  lity encoding for that file type. Important that this is correct as the wrong phred encoding will mean your quality scores make no sense!
local file=$1

echo "Running quality stats on $i"
fastx_quality_stats -Q 33 -i $file -o QUALSTATS/$file.qualstats
echo "Running sequence length analysis on $i"
./get_seq_len_fastq_2.py $file LENS/$file.lens
}


#Run function on every fastq file in the directory
for fastq_file in *.fastq
do
quality_metrics $fastq_file
done
