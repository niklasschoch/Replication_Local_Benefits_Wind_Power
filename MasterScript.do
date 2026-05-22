*-------------------------------------------------------------------------------
* Master Script - Local Economic Impacts of Wind Power Deployment in Denmark
* Replication package
*
* This script runs every step of the replication package in order.
* All paths are RELATIVE to the folder that contains this file
* (Wind_Data_Package). You do not need to edit anything to run it -
* just open it in Stata and click "Do", or run:
*     do MasterScript.do
*
* Each step is wrapped in a skip flag at the top of the file, so you can
* re-run only the parts you need. Set the corresponding local to 1 to skip.
*-------------------------------------------------------------------------------

version 14
clear all
set more off
log close _all

*-------------------------------------------------------------------------------
* Resolve the root directory of the replication package (folder of this script)
*-------------------------------------------------------------------------------
local ROOT : pwd
global ROOT "`ROOT'"
display as text "Replication package root: $ROOT"

*-------------------------------------------------------------------------------
* Skip flags - set to 1 to skip a step, 0 to run it.
* The panel-building step is OFF by default because the final panel
* (FinalPanel.dta) is already shipped with the package. Turn it on only if
* you want to rebuild the panel from the raw sources.
*-------------------------------------------------------------------------------
local skip_build_panel       = 1
local skip_summary_stats     = 0
local skip_main_estimations  = 0
local skip_dose_responses    = 0
local skip_heterogeneity     = 0
local skip_placebos          = 0
local skip_robustness        = 0

*-------------------------------------------------------------------------------
* Step 0 (optional): Rebuild FinalPanel.dta from the raw data sources
*-------------------------------------------------------------------------------
if `skip_build_panel' == 0 {
    display as result _newline "=== Step 0: Building FinalPanel.dta from raw data ==="
    cd "$ROOT/Data"
    do "Code_Data.do"
    cd "$ROOT"
}

*-------------------------------------------------------------------------------
* Step 1: Summary statistics
*-------------------------------------------------------------------------------
if `skip_summary_stats' == 0 {
    display as result _newline "=== Step 1: Summary statistics ==="
    cd "$ROOT/Summary_Stats"
    do "Summary_Stats.do"
    cd "$ROOT"
}

*-------------------------------------------------------------------------------
* Step 2: Main estimations (GPS + OLS) - produces the headline results
*-------------------------------------------------------------------------------
if `skip_main_estimations' == 0 {
    display as result _newline "=== Step 2: Main GPS + OLS estimations ==="
    cd "$ROOT"
    do "GPS_OLS_Estimations.do"
    cd "$ROOT"
}

*-------------------------------------------------------------------------------
* Step 3: Dose-response functions
*-------------------------------------------------------------------------------
if `skip_dose_responses' == 0 {
    display as result _newline "=== Step 3: Dose-response functions ==="
    cd "$ROOT/Dose_Responses"
    do "GPS_Dose_Response.do"
    cd "$ROOT"
}

*-------------------------------------------------------------------------------
* Step 4: Heterogeneity analysis (uses FinalPanel_with_Capacity.dta)
*-------------------------------------------------------------------------------
if `skip_heterogeneity' == 0 {
    display as result _newline "=== Step 4: Heterogeneity analysis ==="
    cd "$ROOT/Heterogeneity"
    do "GPS_OLS_Estimations_Heterogeneity.do"
    cd "$ROOT"
}

*-------------------------------------------------------------------------------
* Step 5: Placebo tests (randomized treatment + timing)
*-------------------------------------------------------------------------------
if `skip_placebos' == 0 {
    display as result _newline "=== Step 5: Placebo tests ==="
    cd "$ROOT/Placebos"
    do "Placebos_Randomized_Treatment.do"
    do "Placebos_Timing.do"
    cd "$ROOT"
}

*-------------------------------------------------------------------------------
* Step 6: Robustness checks (controls, Copenhagen inclusion, alternative lags)
*-------------------------------------------------------------------------------
if `skip_robustness' == 0 {
    display as result _newline "=== Step 6: Robustness checks ==="
    cd "$ROOT/Robustness"
    do "Controls_OLS_Estimations.do"
    do "GPS_Controls_OLS_Estimations.do"
    do "GPS_OLS_Estimations_Robustness_Copenhagen.do"
    do "GPS_OLS_Robustness_Lags.do"
    cd "$ROOT"
}

display as result _newline "=== Replication finished. Outputs are in each subfolder's Output/. ==="
