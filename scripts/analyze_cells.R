
library(readr)

# Selected phenotype and image
phenotype <- "Peripheral actin"
image_id <- "15963"

# Load Fiji results
d <- read_csv(
  "cytoskeleton-BBBC018-15963/data/fiji_results.csv",
  show_col_types = FALSE
)

# Remove the extra row-number column
d <- as.data.frame(d)
d <- d[, names(d) != "...1"]

# Check required columns
needed <- c("Area", "Mean", "Circ.", "AR")
stopifnot(all(needed %in% names(d)))

# Remove rows with missing measurements
d <- d[complete.cases(d[, needed]), ]

# Summary statistics
cat("Phenotype:", phenotype, "\n")
cat("Image ID:", image_id, "\n")
cat("Number of cells:", nrow(d), "\n")
cat("Mean area:", round(mean(d$Area), 2), "pixels squared\n")
cat("Mean actin signal:", round(mean(d$Mean), 2), "\n")
cat("Mean circularity:", round(mean(d$`Circ.`), 3), "\n")
cat("Mean aspect ratio:", round(mean(d$AR), 3), "\n")

# Create output folders if needed
dir.create("cytoskeleton-BBBC018-15963/figures",
           showWarnings = FALSE, recursive = TRUE)
dir.create("cytoskeleton-BBBC018-15963/results",
           showWarnings = FALSE, recursive = TRUE)

# Save cleaned cell measurements
write.csv(
  d,
  "cytoskeleton-BBBC018-15963/results/cell_summary.csv",
  row.names = FALSE
)

# Figure 1: Cell area versus circularity
png("cytoskeleton-BBBC018-15963/figures/area_vs_circularity.png",
    width = 900, height = 650)

plot(d$Area, d$`Circ.`,
     xlab = "Cell area (pixels squared)",
     ylab = "Circularity",
     main = paste(phenotype, "- Cell Area vs Circularity"),
     pch = 19)

dev.off()

# Figure 2: Relative actin signal
png("cytoskeleton-BBBC018-15963/figures/actin_intensity.png",
    width = 900, height = 650)

barplot(d$Mean,
        names.arg = seq_len(nrow(d)),
        col = "steelblue",
        xlab = "Measured cell",
        ylab = "Mean actin-channel intensity",
        main = paste(phenotype, "- Actin Signal"))

dev.off()
