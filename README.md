# Local Economic Impacts of Wind Power Deployment in Denmark — Replication Package

**Authors:** Claire Gavard, Jonas Göbel & Niklas Schoch\
**Title:** Local Economic Impacts of Wind Power Deployment in Denmark, *Environmental and Resource Economics*, Vol. 88, pp. 1679–1717 (2025)\
**Original Article:** <https://link.springer.com/article/10.1007/s10640-025-00982-2>

### Authors

1. Claire Gavard — ZEW Mannheim *Corresponding author.*
2. Jonas Göbel — Faculty of Arts, University of Groningen
3. Niklas Schoch — Department of Economics, Sciences Po Paris

### Abstract

An argument commonly used to support renewable energy is that it may contribute to job creation. On the other hand, these technologies often face local opposition. In the case of Denmark, the country with the longest wind power experience, we examine whether the installation of new turbines had local economic benefits. Using the Danish master data register of wind turbines and detailed data on the municipal budget, personal income and sectoral employment from Statistics Denmark, we build a panel covering 250 municipalities. We use a quasi-experimental set-up and exploit time and regional variations at the municipal level. We find that the deployment of wind power contributed to the increase in personal income for entrepreneurs and reduced dependence on social benefits. As municipalities received payments from wind investors ahead of the construction, the new wind revenues were also followed by increases in local public spending. We find only very minor effects on employment in some sectors, and the aggregate local employment does not change significantly. Heterogeneity analyses indicate that the increases in local entrepreneurial income are largely driven by small installations, whilst increases in municipal budget and reductions in the dependence on social benefits are induced by larger installations.

> This repository is the published replication package, also distributed by the journal alongside the article under "Supplementary Information".

## Citation

If you use this code or data, please cite the article:

```
Gavard, C., Göbel, J. & Schoch, N. (2025).
Local Economic Impacts of Wind Power Deployment in Denmark.
Environmental and Resource Economics, 88, 1679–1717.
https://doi.org/10.1007/s10640-025-00982-2
```

BibTeX:

```bibtex
@article{GavardGobelSchoch2025,
  author  = {Gavard, Claire and G{\"o}bel, Jonas and Schoch, Niklas},
  title   = {Local Economic Impacts of Wind Power Deployment in Denmark},
  journal = {Environmental and Resource Economics},
  volume  = {88},
  pages   = {1679--1717},
  year    = {2025},
  doi     = {10.1007/s10640-025-00982-2}
}
```

## Contact

For questions about this repo, please reach out to:

- **Niklas Schoch** — <niklas.schoch@sciencespo.fr>

## Overview

```
Data-Package-Local-Economic-Impacts-of-Wind-Power-Deployment/
├── FinalPanel.dta                                 # Final balanced municipality-year panel (251 municipalities)
├── GPS_OLS_Estimations.do                         # Main estimations (GPS + OLS)
├── MasterScript.do                                # [ADDED] Orchestrates the entire replication
├── README.md                                      # [ADDED] This file
│
├── Data/
│   ├── Code_Data.do                               # Code to build FinalPanel.dta from raw sources
│   ├── Data Sources and Panel.xls                 # All originally downloaded + GIS-modified data
│   ├── FinalPanel.dta                             # Copy of the final panel
│   ├── Overview Data Wind Power.xlsx              # Overview / documentation of the wind data
│   ├── TEMP/                                      # Temporary files produced by Code_Data.do
│   └── log/                                       # Stata log files
│
├── Summary_Stats/
│   ├── Summary_Stats.do                           # Descriptive statistics
│   └── Output/                                    # Tables produced by Summary_Stats.do
│
├── Dose_Responses/
│   ├── GPS_Dose_Response.do                       # Dose-response functions
│   ├── All_Responses/                             # Full set of dose-response figures
│   └── Relevant/                                  # Headline dose-response figures used in the paper
│
├── Heterogeneity/
│   ├── FinalPanel_with_Capacity.dta               # Panel augmented with installed-capacity variable
│   ├── GPS_OLS_Estimations_Heterogeneity.do       # Heterogeneity by capacity / interaction effects
│   └── Output/                                    # Heterogeneity tables and figures
│
├── Placebos/
│   ├── Placebos_Randomized_Treatment.do           # Placebo: randomly reassign treatment
│   ├── Placebos_Timing.do                         # Placebo: shift treatment timing
│   ├── Random_Assingment_Graphs/                  # Output graphs from the randomised placebo
│   └── Timing_Placebo_Tables/                     # Output tables from the timing placebo
│
├── Robustness/
│   ├── Controls_OLS_Estimations.do                # OLS with extended direct controls
│   ├── GPS_Controls_OLS_Estimations.do            # GPS + extended direct controls
│   ├── GPS_OLS_Estimations_Robustness_Copenhagen.do # Including the greater Copenhagen area
│   ├── GPS_OLS_Robustness_Lags.do                 # Alternative lag specifications
│   ├── Output/                                    # Robustness tables and figures
│   └── Tables_DirectControls/                     # Tables for the direct-controls specification
│
└── Output/                                        # Top-level figures and tables (main paper)
    ├── Budgets_Total.tex
    ├── Distribution-Treatment.png
    ├── Employment_detailed1.tex … Employment_detailed4.tex
    └── Incomes.tex
```

## Requirements

### Software

- **Stata 14** or later (the `.do` files use `version 14` syntax features such as `xtset`, factor variables, and modern `estout` syntax)

### Stata Packages

The following user-written packages are required. The original `.do` files contain `ssc install` lines (commented out) at the top of each script. You can either uncomment them when first running each script, or install everything in one go from the Stata console:

```stata
ssc install ivreg2,         replace
ssc install xtivreg2,       replace
ssc install xtivreg28,      replace
ssc install ranktest,       replace
ssc install fitstat,        replace
ssc install doseresponse2,  replace
ssc install egenmore,       replace
ssc install mmerge,         replace
ssc install elabel,         replace
ssc install texsave,        replace
ssc install estout,         replace
net describe collin, from(https://stats.idre.ucla.edu/stat/stata/ado/analysis)
net install collin
```

## Data

All data used in the analysis are **publicly available without restrictions**. The package contains:

1. **Original sources** (`Data/Data Sources and Panel.xls`) — every raw download is kept on a dedicated sheet of this workbook, plus the GIS-modified wind-turbine and wind-density data. Original sources are:
   - **DIGDAG** (Digital Atlas of the Danish Historical-Administrative Geography) — municipal GIS borders
   - **Statistics Denmark** — income, municipal budget, sectoral employment, population, unemployment, agricultural land surface
   - **Master Data Register of Wind Turbines** (Danish Energy Agency) — turbine technical data, X-Y coordinates, commission / decommission dates (1977–2021)
   - **Dansk Energi** — electricity prices 1985–1999
   - **Energinet** — hourly wind production and electricity prices 2000–2010
   - **EnergiStyrelsen** — support-scheme history (price premium, feed-in tariffs, allowance)
   - **Global Wind Atlas** (Technical University of Denmark) — average wind density (GeoTIFF, processed in QGIS)

2. **Final panel** (`FinalPanel.dta`) — municipality × year, 251 municipalities, all variables labelled, monetary variables converted from DKK to EUR, per-capita variables computed.

3. **Panel with capacity** (`Heterogeneity/FinalPanel_with_Capacity.dta`) — same panel augmented with installed wind-turbine capacity, used for the heterogeneity analysis.

## Replication Instructions

### Master Script
For one-click replication, use master script:

```stata
* Open MasterScript.do in Stata and click "Do", or:
do MasterScript.do
```

### Manual step-by-step instructions

If you prefer to run scripts individually, the order below mirrors `MasterScript.do`. Each `.do` file expects Stata's working directory to be **the folder containing the file** (sub-folder scripts use `use "../FinalPanel.dta"`).

#### Step 0 (optional): Rebuild the panel

```stata
cd "Data"
do "Code_Data.do"
```

This regenerates `FinalPanel.dta` from the raw Excel sources in `Data Sources and Panel.xls`. The shipped `FinalPanel.dta` is already the output of this script, so this step is only needed if you want to audit the panel construction.

#### Step 1: Summary statistics

```stata
cd "Summary_Stats"
do "Summary_Stats.do"
```

#### Step 2: Main estimations

```stata
cd ".."  // back to the project root
do "GPS_OLS_Estimations.do"
```

#### Step 3: Dose-response functions

```stata
cd "Dose_Responses"
do "GPS_Dose_Response.do"
```

#### Step 4: Heterogeneity

```stata
cd "Heterogeneity"
do "GPS_OLS_Estimations_Heterogeneity.do"
```

#### Step 5: Placebos

```stata
cd "Placebos"
do "Placebos_Randomized_Treatment.do"
do "Placebos_Timing.do"
```

#### Step 6: Robustness

```stata
cd "Robustness"
do "Controls_OLS_Estimations.do"
do "GPS_Controls_OLS_Estimations.do"
do "GPS_OLS_Estimations_Robustness_Copenhagen.do"
do "GPS_OLS_Robustness_Lags.do"
```

## Output

All generated tables (`.tex`) and figures (`.png`) are written to:

- `Output/` (main paper figures and tables)
- `Summary_Stats/Output/`
- `Dose_Responses/All_Responses/` and `Dose_Responses/Relevant/`
- `Heterogeneity/Output/`
- `Placebos/Random_Assingment_Graphs/` and `Placebos/Timing_Placebo_Tables/`
- `Robustness/Output/` and `Robustness/Tables_DirectControls/`

The shipped package already contains the produced output files, so you can inspect them before re-running anything.

## License

The article (Gavard, Göbel & Schoch, 2025) is published **Open Access** under a **Creative Commons Attribution 4.0 International (CC BY 4.0)** licence — see <https://creativecommons.org/licenses/by/4.0/>. The replication package distributed by the journal as supplementary information is covered by the same terms: it may be used, shared, adapted and redistributed, including for commercial purposes, provided that appropriate credit is given to the original authors and a link to the licence is provided. Please always cite the original publication when using any part of this package.

The same package is also available on the journal's website at <https://link.springer.com/article/10.1007/s10640-025-00982-2> (under "Supplementary Information") — this GitHub repository is provided as a convenience mirror.
