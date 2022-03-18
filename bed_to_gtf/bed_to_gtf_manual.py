#!/bin/python3
# coding: utf-8

# In[27]:


#!/usr/bin/env python3
import argparse
import pandas as pd
import csv
import sys


# In[56]:


# fake_args= ['python3', '-i', '/mnt/data/Code/repositories/denovobs/data/seqs_maps_info_Hs_20210220/Hs_Ens89_hg19_partial_maps.bed']
# sys.argv = fake_args


# In[88]:


parser = argparse.ArgumentParser(description='Generates a feature-based GTF from a BED file')

parser.add_argument('-i', '--infile', type=argparse.FileType('r'), required=True, help='Filename of input BED file (11 column). Use  "-i -" for piped STDIN filenames ')
parser.add_argument('-o', '--outfile', type=str, default=sys.stdout, required=False, help='Filename of output GTF file. Defaults to STDOUT.')
parser.add_argument('-s', '--source', type=str, required=False, help='Source tag for source column in the resulting GTF file. Defaults to input filename')


# In[89]:


def bed_to_gtf_df(bed_df, multiprocessing=None):
        
    gtf_df = []

    if multiprocessing:
        # MULTI-THREADED
        myPool = mp.Pool(processes=mp.cpu_count()+4)
        for gtf_subrecords in myPool.imap(bed_to_gtf_record, [row for i, row in bed_df.iterrows()]):
            gtf_df.extend(gtf_subrecords)

    else:
        # ONE THREAD
        for i, bed_record in bed_df.iterrows():
            gtf_df.extend(bed_to_gtf_record(bed_record))
    
   
    gtf_df = pd.DataFrame(gtf_df, columns=gtf_cols).fillna('.')
    gtf_df['source'] = args.source if args.source else args.infile.name+'_MANUAL'
     
    return gtf_df


# In[90]:


def bed_to_gtf_record(bed_record, source=None):
    '''
    Takes a bed record and returns a list of GTF-formatted records for all the blocks in the original record.
    Input: dict, series
    '''

    # List to buffer all the results
    gtf_records = []

    # Create record with common info
    common_record = {
        'seqname': bed_record['chrom'],
        'start': str(int(bed_record['chromStart'])+1),  # GTF and BED use different indexing
        'end': bed_record['chromEnd'],
        'score': bed_record['score'],  # Not kept in original script, probably because bed is int and gtf should be float
        'strand': bed_record['strand'],
        'source': source,
        'attribute': 'gene_id "'+bed_record['name']+'"; transcript_id "'+bed_record['name']+'";'
        }
    
    
    # Create record of TRANSCRIPT
    transcript_record = {'feature': 'transcript'}
    transcript_record.update(common_record)

    gtf_records.append(transcript_record)


    if int(bed_record['blockCount']) > 0: # Check records with no blocks
        
        # Iterate blocks (i.e. exons)
        for (ex_idx, (bsize, bstart)) in enumerate(zip(bed_record['blockSizes'].split(','), bed_record['blockStart'].split(','))):
            
            if ex_idx + 1 < int(bed_record['blockCount']):
                
                # Create record of each EXON
                exon_record = {}
                exon_record.update(common_record)
                exon_record.update({
                    'feature': 'exon',
                    'start': int(exon_record['start']) + int(bstart),
                    'end': int(exon_record['end']) + int(bstart) + int(bsize) - 1                
                })
                exon_record['attribute'] += f' ; exon_number "{ex_idx+1}"; exon_id "'+bed_record['name']+f'.{ex_idx+1}";'
                gtf_records.append(exon_record)
        
    return gtf_records


# In[91]:


# BED. Per locus table
bed_cols = ['chrom', 'chromStart', 'chromEnd', 'name', 'score', 'strand', 'thickStart', 'thickEnd', 'itemRgb', 'blockCount', 'blockSizes', 'blockStart']


# GTF. Per feature table

gtf_cols = [     # BED EQUIVALENCE
    'seqname',   # chrom
    'source',    # None. It will default to filename
    'feature',   # None. It will be transcript for each locus, exon for each block in the locus
    'start',     # chromStart +1
    'end',       # chromEnd
    'score',     # score float
    'strand',    # strand
    'frame',     # None
    'attribute'  # Name of transcript, gene and/or exon
]


# In[67]:


if __name__ == '__main__':
    
    args = parser.parse_args()
    
    bed_df = pd.read_csv(args.infile, sep='\t', header=None, comment='#')
    bed_df.columns = bed_cols
    args.infile.close()
    
        
    multiprocessing = len(bed_df) > 1000
    if multiprocessing:
        import multiprocessing as mp
    
        
    gtf_df = bed_to_gtf_df(bed_df, multiprocessing=multiprocessing)
    
    gtf_df.to_csv(args.outfile, index=False, header=False, sep='\t', quoting=csv.QUOTE_NONE)
    

