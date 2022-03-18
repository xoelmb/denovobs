#!/bin/sh
# '''
# usage:

# bash filterExons YOUR_FOLDER 

# Filter-out any feature != "exon" of all GTF files in a folder, saving them as .EXONS.gtf

# 5.4 years ago
# RoryC ▴ 30
# So after coming back to this some time after I think I've found a relatively simple way of doing this. First use bedtools merge with -o count to merge overlapping elements and add a fourth column which shows how many original elements contributed to the new elements. Then use a command prompt to remove any rows that have a number greater than 1 in the fourth column, thus removing anything that originally overlapped and was merged. For example with a bed file (the same could be done with gtf):
# 
# bedtools merge -i file.bed -c 1 -o count | awk ' { if($4==1) print $0} ' > newfile.bed

# '''



# ARGUMENTS
INFOLDER=$1 #'./data/seqs_maps_info_Hs_20210220/GTF_GENEPRED/'

# Iterate files
ls $INFOLDER | grep '.gtf' | grep -v 'EXONS' | while read -r line ; do
    echo "Filtering" $INFOLDER$line
    cat $INFOLDER$line | awk '{ if ($3 == "exon") { print } }' > $INFOLDER"${line%.gtf}.EXONS.gtf"
done

