#!/usr/bin/env

def get_seq_len_fastq(infastq,outfile):

#read in fastq file and output tab delimited file containing read name and read lengths
        from Bio import SeqIO

        infile = SeqIO.parse(open(infastq,"r"),"fastq")
        outfile = open(outfile,"w")

        for record in infile:
                outfile.write("%s\n" %(len(record.seq)))

import sys
get_seq_len_fastq(sys.argv[1],sys.argv[2])
