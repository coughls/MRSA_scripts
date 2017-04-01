#!#!/usr/bin/env gt

#Function that reads in file(s) of read lengths (lengths in one vertical column) and outputs stats on the lengths

#input file(s) format for 

#read_name  read_length
....

#output file format
#(filename average_read_length median_read_length minimum_read_length maximum_read_length number_of_reads standard_deviation_of_read_lengths

#Usage ./read_stats.py.py inputfile.txt outfile.txt

import sys, os

def read_stats(file,outfile):

        #append to output file
        outfile = open(outfile,"a")
        print (file)
        filehandle = open(file,"r")
        
        import numpy

        read_lengths = [ ]
        for line in filehandle:
                read_lengths += [ int(line.rstrip('\n')) ]

        avg = round((numpy.mean(read_lengths)),2)
        med = numpy.median(read_lengths)
        max_len = max(read_lengths)
        min_len = min(read_lengths)
        lens = len(read_lengths)
        sd = numpy.std(read_lengths) #standard deviatiuo
        outfile.write("%s\t%s\t%s\t%s\t%s\t%s\t%s\n" %(file,avg,med,min_len,max_len,lens,sd))

        #or uncomment the below lines to print to screen also 
        #print ("Mean: %s" % (round((numpy.mean(read_lengths)),2)))  #round mean to 2 decimal places
        #print ("Median: %s" %(numpy.median(read_lengths)))
        #print ("Max: %s" %(max(read_lengths)))
        #print ("Min: %s" %(min(read_lengths)))
        #print("Number of reads is %s" %(len(read_lengths)))
        #print("Standard deviation ins %s" %(numpy.std(read_lengths)))

#do for one file 
#read_stats(sys.argv[1],sys.argv[2])

#or multiple files
#stats for all files will be in one file, one row per file
outputfile = sys.argv[1]
#read in all files in this directory
filelist = os.listdir("./")
for file in filelist:
        if file.endswith('.lens'):
                read_stats(file,outputfile)
