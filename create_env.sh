#!/bin/sh

conda create -n denovobs -y -c r -c conda -c anaconda -c conda-forge -c bioconda r-dplyr bioconductor-edger r-reshape2 r-ggplot2 r-reshape r-nlme r-readr r-data.table r-ggally bioconductor-complexheatmap r-rcolorbrewer r-irkernel bedtools
