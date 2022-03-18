#!/bin/sh
# '''
# usage:

# bash bed_to_gtf_batch.sh YOUR_FOLDER FA_SEQUENCE

# Converts all .bed files in a specified folder (YOUR_FOLDER) into .gtf files
# Also, creates annotated GTF-like files using a FA SEQUENCE

# Includes two methods (subfolders): manual conversion or GenePred-based conversion (UCSC Tools)

# ___________________
# GENEPRED CONVERSION

# Converts a BED file to GTF through GenePred format, which is GTF-like, i.e. it is feature-based
# using bedToGenePred and genePredToGtf from UCSC Tools. It will download them if not present.
# LOCUS-TO-FEATURES: it creates the following features: transcript, exon, cds, start_codon, stop_codon. Can be modified to include also UTR. 
# FRAME: it also infers the frame of each of the features.
# SCORE: deletes scores


# _________________
# MANUAL CONVERSION

# Converts a BED file to a GTF file based on format documentation.
# LOCUS-TO-FEATURES: each locus record is processed into 1 transcript record and #blockCount number of exon records
# FRAME: it does not infer frame
# INDEXING: corrects coordinates by hand
# SCORE: keeps scores as is

# Can be modified to keep more information in attributes (like track color).

# '''



# ARGUMENTS
INFOLDER=$1 #'./data/Hs_Ens89+2102_PS_seq_etc_hg38/'
OUTFOLDER_MANUAL=$INFOLDER'GTF_MANUAL/'
OUTFOLDER_GENEPRED=$INFOLDER'GTF_GENEPRED/'
ANNOTATION=$2


# GENEPRED GTF
mkdir -p $OUTFOLDER_GENEPRED

# Iterate files
ls $INFOLDER | grep '.bed' | while read -r line ; do
    echo "GENEPRED: Processing" $INFOLDER$line
    bash ./bed_to_gtf_genepred.sh $INFOLDER$line $OUTFOLDER_GENEPRED${line%.*}.gtf
    bedtools nuc -fi $2 -bed $OUTFOLDER_GENEPRED${line%.*}.gtf > $OUTFOLDER_GENEPRED${line%.*}.ANNOTATION.txt
done


# MANUAL GTF
mkdir -p $OUTFOLDER_MANUAL 

# Iterate files
ls $INFOLDER | grep '.bed' | while read -r line ; do
    echo "MANUAL: Processing" $INFOLDER$line
    python3 ./bed_to_gtf_manual.py -i $INFOLDER$line -o $OUTFOLDER_MANUAL${line%.*}.gtf
    bedtools nuc -fi $2 -bed $OUTFOLDER_MANUAL${line%.*}.gtf > $OUTFOLDER_MANUAL${line%.*}.ANNOTATION.txt
done
