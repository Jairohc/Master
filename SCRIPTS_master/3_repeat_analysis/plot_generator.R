postscript("repeat-match-parser.ps")
getwd()
sorted_results <- read.table("sorted_results", quote="\"", comment.char="")
colors <- c("#999999", "#E69F00")
colors <- colors[as.numeric(sorted_results$V8)]
library(scatterplot3d)
scatterplot3d(sorted_results[5:7], color=colors, angle = 80, xlab = "Número de repetidos", ylab = "Normalización: repetidos / longitud del genoma", zlab = "Longitud promedio", pch = 16, type = "h", box = FALSE)
dev.off()
