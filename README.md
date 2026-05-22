# Local Economic Impacts of Wind Power Deployment in Denmark — Replication Package

**Authors:** Claire Gavard, Jonas Göbel & Niklas Schoch
**Title:** Local Economic Impacts of Wind Power Deployment in Denmark
**Journal:** *Environmental and Resource Economics*, Vol. 88, pp. 1679–1717 (2025)
**Published:** 29 April 2025 (Open Access)
**DOI:** [10.1007/s10640-025-00982-2](https://doi.org/10.1007/s10640-025-00982-2)
**Article:** <https://link.springer.com/article/10.1007/s10640-025-00982-2>

### Author affiliations

1. Claire Gavard — ZEW – Leibniz Centre for European Economic Research, L7 1, 68161 Mannheim, Germany ([ORCID 0000-0003-3089-4802](https://orcid.org/0000-0003-3089-4802)). *Corresponding author.*
2. Jonas Göbel — Faculty of Arts, University of Groningen, Oude Kijk in 't Jatstraat 26, 9712 Groningen, The Netherlands.
3. Niklas Schoch — Department of Economics, Sciences Po Paris, 27 Rue Saint-Guillaume, 75007 Paris, France.

> This repository is the published replication package, downloadable from the journal's supplementary materials. The same package is also distributed by the journal alongside the article on the Springer website (<https://link.springer.com/article/10.1007/s10640-025-00982-2>, under "Supplementary Information"). The folder structure, data files, and Stata `.do` files have **not** been modified here. Only two files have been added on top: this `README.md`, and a top-level `MasterScript.do` that runs all steps in sequence.

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

For questions about this **GitHub mirror** of the replication package (e.g. issues with `MasterScript.do` or the README), please reach out to:

- **Niklas Schoch** — <niklas.schoch@sciencespo.fr>

For questions about the **underlying paper or methodology**, please contact the corresponding author:

- **Claire Gavard** — ZEW Mannheim ([ORCID](https://orcid.org/0000-0003-3089-4802))

## Overview

```
Wind_Data_Package/
├── Read_Me.pdf                                    # Original replication README from the journal
├── FinalPanel.dta                                 # Final balanced municipality-year panel (251 municipalities)
├── GPS_OLS_Estimations.do                         # Main estimations (GPS + OLS)
├── MasterScript.do                                # [ADDED] Orchestrates the entire replication
├── README.md                                      # [ADDED] This file
│
├── Data/
│   └── Data/
│       ├── Code_Data.do                           # Code to build FinalPanel.dta from raw sources
│       ├── Data Sources and Panel.xls             # All originally downloaded + GIS-modified data
│       ├── FinalPanel.dta                         # Copy of the final panel
│       ├── Overview Data Wind Power.xlsx          # Overview / documentation of the wind data
│       ├── TEMP/                                  # Temporary files produced by Code_Data.do
│       └── log/                                   # Stata log files
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

1. **Original sources** (`Data/Data/Data Sources and Panel.xls`) — every raw download is kept on a dedicated sheet of this workbook, plus the GIS-modified wind-turbine and wind-density data. Original sources are:
   - **DIGDAG** (Digital Atlas of the Danish Historical-Administrative Geography) — municipal GIS borders
   - **Statistics Denmark** — income, municipal budget, sectoral employment, population, unemployment, agricultural land surface
   - **Master Data Register of Wind Turbines** (Danish Energy Agency) — turbine technical data, X-Y coordinates, commission / decommission dates (1977–2021)
   - **Dansk Energi** — electricity prices 1985–1999
   - **Energinet** — hourly wind production and electricity prices 2000–2010
   - **EnergiStyrelsen** — support-scheme history (price premium, feed-in tariffs, allowance)
   - **Global Wind Atlas** (Technical University of Denmark) — average wind density (GeoTIFF, processed in QGIS)

2. **Final panel** (`FinalPanel.dta`) — municipality × year, 251 municipalities, all variables labelled, monetary variables converted from DKK to EUR, per-capita variables computed.

3. **Panel with capacity** (`Heterogeneity/FinalPanel_with_Capacity.dta`) — same panel augmented with installed wind-turbine capacity, used for the heterogeneity analysis.

## Panel construction

The panel is built in three broad stages (see `Read_Me.pdf` Section 3 for the full description, and `Data/Data/Code_Data.do` for the code):

1. **Reshape each source into municipality-year format**, manually harmonise municipality names (Danish characters `ø å æ` are inconsistently handled across QGIS, Stata and Excel; spellings differ between Statistics Denmark and DIGDAG), and drop the island municipality of Christiansø (insufficient data).

2. **Three administrative edits**:
   - Merge the **21 urbanised small municipalities** of greater Copenhagen.
   - Merge **Marstal, Ærøskøbing and Ærø** (same municipality, name changed in 2005).
   - For **Bornholm** (Aakirkeby, Rønne, Nexø, Hasle, Allinge-Gudhjem) drop the five sub-municipalities and use the **county-level** data instead, since post-2002 sub-municipal data are incomplete.

3. **Merge all sources at the municipal level**, convert DKK → EUR, generate per-capita variables, delete temporary `TEMP_*` files, label variables. The result is a balanced panel of **251 municipalities**.

## Replication Instructions

### Quick start: Master Script

For one-click replication, use the added master script:

```stata
* Open MasterScript.do in Stata and click "Do", or:
do MasterScript.do
```

The master script:

- uses **relative paths** (no edits to paths required),
- has a **skip flag for every step** at the top — set a flag to `1` to skip,
- by default **does not rebuild the panel** (it uses the shipped `FinalPanel.dta`); set `skip_build_panel = 0` to rebuild from raw sources,
- runs the steps in the order: build panel (optional) → summary stats → main estimations → dose responses → heterogeneity → placebos → robustness.

### Manual step-by-step instructions

If you prefer to run scripts individually, the order below mirrors `MasterScript.do`. Each `.do` file expects Stata's working directory to be **the folder containing the file** (sub-folder scripts use `use "../FinalPanel.dta"`).

#### Step 0 (optional): Rebuild the panel

```stata
cd "Data/Data"
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

## Key variables

| Variable | Description |
|---|---|
| `MUN_ID` | Municipality identifier (panel id) |
| `year` | Year |
| `FormerMunicipality` | Municipality name (pre-2007 reform spelling) |
| `New_Rev`, `New_Rev_PC` | New revenues from newly commissioned turbines (total / per capita), in EUR |
| `Turbine_installed` | Number of turbines commissioned in the municipality-year |
| `L3_Turbine_installed` | 3-year lag of installed turbines (used in the GPS) |
| `AVG_WindDensity` | Average wind density (Global Wind Atlas, processed in QGIS) |
| `UnemplyRate` | Unemployment rate (Statistics Denmark) |
| `Emp_Tot`, `Emp_Tot_PC` | Total employment (level and per capita) |
| `Population` | Municipal population |
| Budget / income / sectoral employment variables | Statistics Denmark, converted from DKK to EUR and where relevant expressed per capita |

## Output

All generated tables (`.tex`) and figures (`.png`) are written to:

- `Output/` (main paper figures and tables)
- `Summary_Stats/Output/`
- `Dose_Responses/All_Responses/` and `Dose_Responses/Relevant/`
- `Heterogeneity/Output/`
- `Placebos/Random_Assingment_Graphs/` and `Placebos/Timing_Placebo_Tables/`
- `Robustness/Output/` and `Robustness/Tables_DirectControls/`

The shipped package already contains the produced output files, so you can inspect them before re-running anything.

## Notes

1. **File paths**: The `.do` files use Windows-style backslashes in some places. On macOS / Linux, Stata accepts forward slashes; the master script uses forward slashes for portability.
2. **Working directory**: Sub-folder `.do` files load the panel with `use "../FinalPanel.dta"`. They therefore must be run with Stata's working directory set to the **sub-folder containing the script**. The provided `MasterScript.do` handles this automatically via `cd`.
3. **Special characters**: Danish municipality names contain `ø å æ Æ Ø Å`. The data files use UTF-8 / Latin-1 encoding depending on the source; if you see mojibake when opening files in Stata, try `set fileencoding ISO-8859-1` or open the script in a UTF-8 aware editor.

## License

The article (Gavard, Göbel & Schoch, 2025) is published **Open Access** under a **Creative Commons Attribution 4.0 International (CC BY 4.0)** licence — see <https://creativecommons.org/licenses/by/4.0/>. The replication package distributed by the journal as supplementary information is covered by the same terms: it may be used, shared, adapted and redistributed, including for commercial purposes, provided that appropriate credit is given to the original authors and a link to the licence is provided. Please always cite the original publication when using any part of this package.

The same package is also available on the journal's website at <https://link.springer.com/article/10.1007/s10640-025-00982-2> (under "Supplementary Information") — this GitHub repository is provided as a convenience mirror.
