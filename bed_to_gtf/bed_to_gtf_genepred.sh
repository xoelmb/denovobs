#!/bin/sh

### BED TO GTF 
# Converts a BED file into a GTF file.
# This script takes the name of a bed input file as its unique argument.
# Requires two tools (bedToGenePred and genePredToGtf) from UCSC (http://hgdownload.cse.ucsc.edu/admin/exe)



# Check platform
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        platform='linux.x86_64'
elif [[ "$OSTYPE" == "darwin"* ]]; then
        platform='macOSX.x86_64'
fi

# Download tools if not present
if  ! test -f "./bedToGenePred";then
    echo "bedToGenePred not present. Downloading..."
    wget http://hgdownload.cse.ucsc.edu/admin/exe/$platform/bedToGenePred
    chmod +x ./bedToGenePred
fi

if  ! test -f "./genePredToGtf";then
    echo "genePredToGtf not present. Downloading..."
    wget http://hgdownload.cse.ucsc.edu/admin/exe/$platform/genePredToGtf
    chmod +x ./genePredToGtf
fi

# Create temporary files that split the records with and without UTR info
utr_tmp=$1'.utr.tmp'          # Fully-mapped (UTR info available)
no_utr_tmp=$1'.no_utr.tmp'    # Not fully-mapped

cat $1 | grep '^[^#]' | grep  -P '\t1000\t' > $utr_tmp
cat $1 | grep '^[^#]' | grep -v -P '\t1000\t' > $no_utr_tmp

# Convert to GTF
./bedToGenePred $utr_tmp stdout| ./genePredToGtf file stdin -source=$1_GENEPRED -addComments -utr stdout > $2
./bedToGenePred $no_utr_tmp stdout| ./genePredToGtf file stdin -source=$1_GENEPRED -addComments stdout >> $2

# Clean temporary
rm $utr_tmp
rm $no_utr_tmp
