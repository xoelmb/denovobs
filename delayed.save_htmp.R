options <- commandArgs(trailingOnly = TRUE)
options

load(options[1])
suppressPackageStartupMessages(library(ComplexHeatmap))

# print(options)
# print(ls())
save_htmp <- function(htmp, path, nc, nr, plot.format='png'){
  height = if (nr/nc < 2) 20 else if (nr/nc < 40) 30 else 40
  width = if (nc < 90) 15 else 25
  
    if (plot.format == 'pdf'){
      pdf(path, width = width, height = height )
    } else if (plot.format == 'png'){
      png(path, width = width, height = height,
          units = 'in', res = 100)
    }
  draw(htmp)
  exit <- dev.off()
  return(exit)
}


path <- paste0('./plots/',basename(path))
print(c(path, save_htmp(htmp, path, nc, nr, plot.format)))

file.remove(options[1])
