# Differential Expression Analysis of Unannotated Proteins in the BrainSpan RNA-Seq dataset


Description of the expression analysis performed on the BrainSpan bulk mRNA-Seq dataset. The genes analysed were those identified as human and primate origin by a phylostratography analysis.  
  
  
# Data  
  
The data you need to run this analysis are:
- data/**COUNTS**_DEC2021: folder containing counts per sample in text files, of the form {GENE_ID}\t{N_COUNTS}\n   
- data/counts.2021.csv: CSV file of counts of all samples, created by the scripts    
- data/**Hs_Ens89+2102_PS_seq_etc_hg38**: bed files and annotation of the genes mapped in the counts, including phylostratum

You need to download the reference fasta sequence:  
- data/hg38.fa: genomic reference human sequence  
- data/hg38.fa.fai: index of fa file, created by the script  

# Scripts not included  
Downloadable from UCSC Tools:
- bed_to_gtf/bedToGenePred  
- bed_to_gtf/genePredToGtf  

# Running

## First steps  

### GTF files
We need to create GTF files of the bed files in the annotation folder. This is done by bed_to_gtf/**bed_to_gtf_batch.sh**. You'll need the reference fasta files in the data folder.  
Usage:  
```
bash bed_to_gtf_batch.sh YOUR_FOLDER FA_SEQUENCE

Converts all .bed files in a specified folder (YOUR_FOLDER) into .gtf files
Also, creates annotated GTF-like files using a FA SEQUENCE

Includes two methods (subfolders): manual conversion or GenePred-based conversion (UCSC Tools)
```

This will create folders with the GTF files of the beds in the folder. 

### Dependencies  
The analysis is performed in R using several packages. You can create a minimum conda environment using the ```create_env.sh``` script, which can be used as a jupyter kernel to run the analysis. Jupyter (or any other method to run .ipynb files) won't be installed in the enviroment. If Jupyter is installed in a different environment, you will also need ```nb_conda_kernels```.


## Main script  
You should be ready to run **DEA.ipynb**. The first chunks of the code define the options of the run, which can be used to modulate the output of the run.


