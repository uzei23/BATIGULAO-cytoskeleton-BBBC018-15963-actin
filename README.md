# Cytoskeleton and Cell Morphology

**Student ID:** 202400711  
**Name:** BATIGULAO, JEHIAH BLESS T.  
**Date Completed:** October 27, 2026  
**Phenotype:** Peripheral Actin  
**Image Field ID:** 15963

**Goal:** Download and select fluorescence microscopy images of HT29 human colon cancer cells from the BBBC018 dataset, identify a phenotype, measure five cells using Fiji/ImageJ, analyze the measurements in R, generate two plots, and document the individual work in a GitHub repository.

## Process

### 1. Download and Install Fiji/ImageJ

Fiji/ImageJ was downloaded from the official Fiji website. The Windows version compatible with the computer was selected and installed.

<img width="1272" height="820" alt="Screenshot 2026-10-27 133855" src="https://github.com/user-attachments/assets/a69298b2-9820-4c9d-8939-c7356646ec7f" />

*Figure 1. Fiji/ImageJ download page showing the software download option for Windows.*

<img width="756" height="127" alt="image" src="https://github.com/user-attachments/assets/1143f9eb-5ae9-4d1e-90d9-efe6dce91352" />

*Figure 2. Fiji/ImageJ installed and ready to use.*

### 2. Download the BBBC018 Dataset and Select a Phenotype

The BBBC018 dataset contains fluorescence microscopy images of HT29 human colon cancer cells. The dataset was used to select an image field for examining the actin cytoskeleton.

The selected phenotype for this activity was **Peripheral Actin**, using image field **15963**. This was my own visual classification based on the actin fluorescence pattern and should not be treated as a verified dataset label.

**Dataset page:** https://bbbc.broadinstitute.org/BBBC018

**Dataset download:** https://data.broadinstitute.org/bbbc/BBBC018/BBBC018_v1_images.zip

<img width="1892" height="1010" alt="image" src="https://github.com/user-attachments/assets/a04dd82b-425b-4731-b5db-01b7c8c71e0b" />

*Figure 3. BBBC018 dataset page or reference image used during phenotype selection.*

### 3. Open the Fluorescence Images in Fiji

The images corresponding to field 15963 were opened in Fiji/ImageJ. The actin channel was used to examine F-actin distribution, while the DNA channel helped identify nuclei and distinguish neighboring cells. The pH3 channel was available as an optional reference for cells associated with mitosis.

The following files correspond to the selected image field:

| Channel | Filename | Purpose |
|---|---|---|
| Actin | `15963-actin.DIB` | Shows the distribution of filamentous actin (F-actin) and cell outlines. |
| DNA | `15963-DNA.DIB` | Shows nuclear DNA and helps locate nuclei. |
| pH3 | `15963-pH3.DIB` | Optional reference for identifying cells associated with mitosis. |

The actin image was the primary image used for tracing and measuring cells.


<img width="1307" height="702" alt="Screenshot 2026-10-27 114903" src="https://github.com/user-attachments/assets/ff3cc661-ef92-4b75-af17-ffef3ae0b535" />

*Figure 4. Opening the actin, DNA, and optional pH3 images corresponding to field 15963 in Fiji/ImageJ.*

<img width="1107" height="1062" alt="image" src="https://github.com/user-attachments/assets/61685ac3-a40a-401d-bd75-631adc66c271" />

*Figure 5. Actin channel of field 15963 before cell measurement.*

<img width="1012" height="1067" alt="image" src="https://github.com/user-attachments/assets/b38781a1-a328-482c-873d-2aa36a4130be" />

*Figure 6. DNA channel used as a reference for locating nuclei.*

<img width="1007" height="1060" alt="image" src="https://github.com/user-attachments/assets/54f5244d-364b-4897-a3fe-841e4abf160b" />

*Figure 7. Optional pH3 channel for reference.*

### 4. Measure Five Cells in Fiji/ImageJ

Five cells with sufficiently clear boundaries were selected from the actin image. Regions of interest (ROIs) were drawn around the selected cells to obtain measurements of their size, shape, and mean fluorescence intensity.

In Fiji/ImageJ, the measurement settings were configured through **Analyze > Set Measurements**. The following options were selected:

- Area
- Mean gray value
- Shape descriptors
- Display label

After selecting each ROI, **Analyze > Measure** was used to record its measurements. The results were then saved as a CSV file for analysis in R.


<img width="567" height="670" alt="image" src="https://github.com/user-attachments/assets/655fea38-2544-45dd-90fc-b503f1e411dd" />

*Figure 8. Fiji/ImageJ measurement settings used to obtain area, mean gray value, shape descriptors, and cell labels.*

<img width="651" height="697" alt="Screenshot 2026-10-27 121236" src="https://github.com/user-attachments/assets/9d00ebb4-3852-46e6-9ca6-cc068de8be88" />

*Figure 9. Five selected cells traced on the actin channel of field 15963.*

<img width="918" height="358" alt="Screenshot 2026-10-27 121223" src="https://github.com/user-attachments/assets/215dc0a6-3e9d-4d67-bb66-72739d6a24e1" />

*Figure 10. ROI Manager or Fiji Results table showing the selected cells and their measurements.*

### 5. Export and Organize the Fiji Results

The Fiji measurements were exported as a CSV file named `fiji_results.csv`. The file was stored in the project's `data` folder and imported into R using the `readr` package.

The measurements included area, mean gray value, circularity, aspect ratio, roundness, and solidity. An additional row-number column was removed during processing because it was not needed for the analysis.

<img width="1687" height="875" alt="image" src="https://github.com/user-attachments/assets/92c3d2c8-e74a-4145-8541-e02c49ef20bf" />

*Figure 11. Fiji measurements exported to CSV and imported into R.*

### 6. Analyze the Measurements in R

R was used to summarize the measurements from the five selected cells. The analysis calculated the mean cell area, mean actin-channel intensity, mean circularity, and mean aspect ratio.

The following R code was used to load and prepare the measurements:

```r
library(readr)

phenotype <- "Peripheral actin"
image_id <- "15963"

d <- read_csv(
  "cytoskeleton-BBBC018-15963/data/fiji_results.csv",
  show_col_types = FALSE
)

d <- as.data.frame(d)
d <- d[, names(d) != "...1"]

needed <- c("Area", "Mean", "Circ.", "AR")
stopifnot(all(needed %in% names(d)))

d <- d[complete.cases(d[, needed]), ]

cat("Phenotype:", phenotype, "\n")
cat("Image ID:", image_id, "\n")
cat("Number of cells:", nrow(d), "\n")
cat("Mean area:", round(mean(d$Area), 2), "\n")
cat("Mean actin signal:", round(mean(d$Mean), 2), "\n")
cat("Mean circularity:", round(mean(d$`Circ.`), 3), "\n")
cat("Mean aspect ratio:", round(mean(d$AR), 3), "\n")
```

The analysis produced the following summary statistics:

| Measurement | Mean value |
|---|---:|
| Number of cells measured | 5 |
| Cell area | 1236.80 px² |
| Mean actin-channel intensity | 392.73 |
| Circularity | 0.702 |
| Aspect ratio | 1.430 |

The cleaned measurements were saved as `results/cell_summary.csv`.

### 7. Generate the Two Plots in R

Two plots were generated to visualize the measurements.

#### Figure 12. Mean Actin Fluorescence

**File:** `figures/actin_intensity.png`

This bar graph compares the mean gray value of the actin channel for the five measured cells. Cell 4 had the highest mean intensity at 465.767, while Cell 2 had the lowest at 335.816.

*Interpretation:* The measured cells showed variation in their mean actin-channel intensity. These values describe the average pixel intensity within each selected region and do not directly measure total actin protein abundance.

<img width="900" height="650" alt="actin_intensity" src="https://github.com/user-attachments/assets/2d83a774-4b51-4239-847f-17c871bd79d1" />

#### Figure 13. Cell Area Versus Circularity

**File:** `figures/area_vs_circularity.png`

This scatter plot compares the area and circularity of the five measured cells. Cell 4 had the largest area at 1832 px² and the lowest circularity at 0.543.

*Interpretation:* The measurements showed differences in cell size and shape. Lower circularity indicates a less circular outline, but it does not by itself establish the distribution of actin around the cell boundary.

<img width="900" height="650" alt="area_vs_circularity" src="https://github.com/user-attachments/assets/05b29a51-e865-4dd7-9434-1052d54724e2" />

### 8. Save the Results and Prepare the GitHub Repository

The output files were organized in the project directory. The repository documents the data used for analysis, the R script, the summary measurements, and the generated figures.

The project structure is organized as follows:

```text
cytoskeleton-BBBC018-15963/
├── README.md
├── data/
│   └── fiji_results.csv
├── scripts/
│   └── analyze_cells.R
├── results/
│   └── cell_summary.csv
└── figures/
    ├── actin_intensity.png
    ├── area_vs_circularity.png
    └── measured_cells.png
```


<img width="991" height="390" alt="image" src="https://github.com/user-attachments/assets/12f17e20-8891-49c1-a116-09eb9f5c46ed" />

*Figure 14. Organized project files containing the Fiji measurements, R script, results, and figures.*

<img width="1256" height="507" alt="image" src="https://github.com/user-attachments/assets/fac97a35-58db-4f80-935b-44669dac953f" />

*Figure 15. Individual GitHub repository containing the cytoskeleton analysis and documentation.*

## Analyses & Answers



| Item | Answer |
|---|---|
| Phenotype chosen (visual classification) | Peripheral Actin |
| Image-field ID | 15963 |
| Actin filename | `15963-actin.DIB` |
| DNA filename | `15963-DNA.DIB` |
| Optional pH3 filename | `15963-pH3.DIB` |
| Dataset page | https://bbbc.broadinstitute.org/BBBC018 |
| Download link | https://data.broadinstitute.org/bbbc/BBBC018/BBBC018_v1_images.zip |
| Number of cells measured | 5 |
| Visible features supporting the phenotype | The actin channel was examined for fluorescence concentrated near the cell periphery. This classification is based on visual inspection and is not a verified dataset label. |

### Explain your results

**1. Which specific phenotype did you choose, and what visible features support that choice?**

I chose Peripheral Actin as my own visual classification for field 15963. The actin channel was examined for fluorescence concentrated near the cell boundaries, which is consistent with peripheral actin organization. The classification should be based on the visible fluorescence distribution rather than on the numerical measurements alone.

**2. Were your five cells mostly round or elongated? Refer to your circularity and aspect-ratio results.**

The five cells showed variation in shape. Four cells had aspect ratios between 1.038 and 1.276, indicating relatively modest elongation, while Cell 4 had an aspect ratio of 2.452 and a circularity of 0.543, indicating a more elongated or irregular shape. The mean circularity was 0.702, and the mean aspect ratio was 1.430.

**3. What role does actin play in maintaining cell shape and in cell movement (Karp Chapter 9)?**

Actin filaments form part of the cytoskeleton and help support the cell cortex, maintain cell shape, and generate force for movement. Actin polymerization can push the plasma membrane outward to form protrusions, while interactions with myosin and cell attachments contribute to cell contraction and crawling.

**4. Why can a single fixed fluorescence image NOT show how fast a cell moves?**

A single fixed fluorescence image captures cells at one moment and does not show changes in their positions over time. Measuring cell speed requires observations at multiple time points so that the distance traveled and elapsed time can be determined. Therefore, a fixed image can show cell morphology but cannot directly measure movement speed.

## Conclusion

This activity used Fiji/ImageJ and R to quantify the morphology and actin-channel intensity of five cells from image field 15963, selected for the Peripheral Actin phenotype. The mean cell area was 1236.80 px², mean actin-channel intensity was 392.73, mean circularity was 0.702, and mean aspect ratio was 1.430.

The results showed variation in cell size, shape, and fluorescence intensity. Cell 4 was the largest and most elongated of the five measured cells and also had the highest mean actin-channel intensity. These findings demonstrate how fluorescence microscopy and image analysis can be combined to quantify cellular features. However, the phenotype classification depends primarily on visual inspection of the actin distribution, and the conclusions are limited by the small number of cells analyzed.

## References

- Broad Bioimage Benchmark Collection (BBBC). BBBC018 dataset page: https://bbbc.broadinstitute.org/BBBC018
- BBBC018 dataset download: https://data.broadinstitute.org/bbbc/BBBC018/BBBC018_v1_images.zip
- Fiji/ImageJ. https://imagej.net/software/fiji/
- R Project for Statistical Computing. https://www.r-project.org/
- `readr` package documentation. https://readr.tidyverse.org/
- Karp, G. *Cell and Molecular Biology: Concepts and Experiments*. Chapter 9, Cytoskeleton and Cell Morphology. 
