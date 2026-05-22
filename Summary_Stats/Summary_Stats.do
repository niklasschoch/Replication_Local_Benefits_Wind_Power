*-------------------------------------------------------------------------------
set more off
clear all
log close _all

/*
For the code to run, you need to install the following packages:
ssc install ivreg2
ssc install xtivreg2
ssc install xtivreg28 
ssc install ranktest
ssc install fitstat
ssc install texsave
ssc install estout
search linktest
net describe collin, from(https://stats.idre.ucla.edu/stat/stata/ado/analysis)
net install collin
ssc install doseresponse2
*/

// ===========================================================
// ============== Data loading and Preparation ===============
// ===========================================================

* Load Dataset and set panel
use "../FinalPanel.dta", clear
drop if year==2006
drop if FormerMunicipality =="Københavns"

*Set Panel
xtset MUN_ID year, yearly
sort MUN_ID year 

*Missing Turbines installed = no turbines installed
local vars "Turbine_installed"
foreach VVV in `vars' {
replace `VVV'=0 if `VVV'==.
}

*---------------- Cluster ------------------------------------------------------
global cluster_mun_year "MUN_ID year"

*-------------------------------------------------------------------------------
* Generate necessary lags before dropping anything
*-------------------------------------------------------------------------------

* Lags for GPS estimation
gen laggedAVGWindDensity=L2.AVG_WindDensity
gen laggedUnemplyRate = L.UnemplyRate

replace Emp_Tot_PC = Emp_Tot / Population
gen laggedEmployment = L.Emp_Tot_PC

gen lagged_Turbines = L3_Turbine_installed

replace New_Rev = 0 if missing(New_Rev)
replace New_Rev_PC = 0 if missing(New_Rev_PC)

* Lags for final Estimation
gen lagged_Rev_PC=L.New_Rev_PC
gen lagged_2_Rev_PC=L2.New_Rev_PC
gen lagged_3_Rev_PC=L3.New_Rev_PC

*Adjust the units
replace Inc_Pers_Tot = Inc_Pers_Tot/1000000
replace Inc_Entrepr_Tot = Inc_Entrepr_Tot/1000000
replace Bdgt_Total_T = Bdgt_Total_T/1000000


*-------------------------------------------------------------------------------
* Generate necessary FD before dropping anything
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* Income
*-------------------------------------------------------------------------------
gen delta_income_Personal = D.Inc_Pers_Tot_PC
gen delta_income_Entre = D.Inc_Entrepr_Tot_PC
gen delta_income_Wages = D.Inc_Wages_Tot_PC
gen delta_income_Pensions = D.Inc_Pnsns_Tot_PC
gen delta_income_Edu = D.Inc_EduGrant_PC
gen delta_income_Daily = D.Inc_DailyBnfts_Tot_PC
*-------------------------------------------------------------------------------
* Budget
*-------------------------------------------------------------------------------

gen delta_Budget_T = D.Bdgt_Total_T_PC
gen delta_Budget_Admin = D.Bdgt_Admin_T_PC
gen delta_Budget_Edu = D.Bdgt_Edu_T_PC
gen delta_Budget_Health = D.Bdgt_Health_T_PC
gen delta_Budget_Housing = D.Bdgt_HousingAmenities_T_PC
gen delta_Budget_UT = D.Bdgt_Public_Ut_T_PC
gen delta_Budget_Tra = D.Bdgt_Traffic_T_PC

*-------------------------------------------------------------------------------
* Employment
*-------------------------------------------------------------------------------
*Scale to avoid numerical issues
gen Emp_Tot_PC_10k = Emp_Tot_PC*10000
gen Emp_8539_PC_10k = Emp_8539_PC*10000
gen Emp_2709_PC_10k = Emp_2709_PC*10000 
gen Emp_4500_PC_10k = Emp_4500_PC*10000 
gen Emp_109_PC_10k =  Emp_109_PC*10000
gen Emp_8000_PC_10k = Emp_8000_PC*10000 
gen Emp_5200_PC_10k = Emp_5200_PC*10000
*Generate FD
gen delta_Emp_Tot_PC = D.Emp_Tot_PC_10k
gen delta_Emp_8539_PC = D.Emp_8539_PC_10k
gen delta_Emp_2709_PC = D.Emp_2709_PC_10k
gen delta_Emp_4500_PC = D.Emp_4500_PC_10k
gen delta_Emp_109_PC = D.Emp_109_PC_10k
gen delta_Emp_8000_PC = D.Emp_8000_PC_10k
gen delta_Emp_5200_PC = D.Emp_5200_PC_10k

*Scale to avoid numerical issues
gen Emp_7209_PC_10k = Emp_7209_PC*10000
gen Emp_7500_PC_10k = Emp_7500_PC*10000
gen Emp_5100_PC_10k = Emp_5100_PC*10000 
gen Emp_8519_PC_10k = Emp_8519_PC*10000 
gen Emp_6009_PC_10k = Emp_6009_PC*10000
gen Emp_9009_PC_10k = Emp_9009_PC*10000 
gen Emp_1509_PC_10k = Emp_1509_PC*10000
*Generate FD
gen delta_Emp_7209_PC = D.Emp_7209_PC_10k
gen delta_Emp_7500_PC = D.Emp_7500_PC_10k
gen delta_Emp_5100_PC = D.Emp_5100_PC_10k
gen delta_Emp_8519_PC = D.Emp_8519_PC_10k
gen delta_Emp_6009_PC = D.Emp_6009_PC_10k
gen delta_Emp_9009_PC = D.Emp_9009_PC_10k
gen delta_Emp_1509_PC= D.Emp_1509_PC_10k

*Scale to avoid numerical issues
gen Emp_5000_PC_10k = Emp_5000_PC*10000
gen Emp_2009_PC_10k = Emp_2009_PC*10000
gen Emp_5500_PC_10k = Emp_5500_PC*10000 
gen Emp_6509_PC_10k = Emp_6509_PC*10000 
gen Emp_2309_PC_10k = Emp_2309_PC*10000
gen Emp_3600_PC_10k = Emp_3600_PC*10000 
gen Emp_6400_PC_10k = Emp_6400_PC*10000
*Generate FD
gen delta_Emp_5000_PC = D.Emp_5000_PC_10k
gen delta_Emp_2009_PC = D.Emp_2009_PC_10k
gen delta_Emp_5500_PC = D.Emp_5500_PC_10k
gen delta_Emp_6509_PC = D.Emp_6509_PC_10k
gen delta_Emp_2309_PC = D.Emp_2309_PC_10k
gen delta_Emp_3600_PC = D.Emp_3600_PC_10k
gen delta_Emp_6400_PC = D.Emp_6400_PC_10k

*Scale to avoid numerical issues
gen Emp_7009_PC_10k = Emp_7009_PC*10000
gen Emp_2600_PC_10k = Emp_2600_PC*10000
gen Emp_1709_PC_10k = Emp_1709_PC*10000 
gen Emp_4009_PC_10k = Emp_4009_PC*10000 
gen Emp_9800_PC_10k = Emp_9800_PC*10000
gen Emp_500_PC_10k = Emp_500_PC*10000 
gen Emp_1009_PC_10k = Emp_1009_PC*10000
*Generate FD
gen delta_Emp_7009_PC = D.Emp_7009_PC_10k
gen delta_Emp_2600_PC = D.Emp_2600_PC_10k
gen delta_Emp_1709_PC = D.Emp_1709_PC_10k
gen delta_Emp_4009_PC = D.Emp_4009_PC_10k
gen delta_Emp_9800_PC = D.Emp_9800_PC_10k
gen delta_Emp_500_PC = D.Emp_500_PC_10k
gen delta_Emp_1009_PC = D.Emp_1009_PC_10k

* Generate indicator of whether the MUN_ID got new turbines installed in the study period
sort MUN_ID

* Generate a variable to track if New_Rev > 0 for each group
gen New_Rev_Pos = (New_Rev > 0)
bysort MUN_ID: egen Mun_Level_Pos = max(New_Rev_Pos)

***************** SUMMARY TABLES **************************
preserve
drop if year!=1993

	*Outcomes
	eststo sum_social : estpost tabstat Population Inc_Pers_Tot Inc_Entrepr_Tot Bdgt_Total_T Emp_Tot, ///
    by(Mun_Level_Pos) statistics(mean sd min max) columns(statistics)

	esttab sum_social using "Output\Sum_Social_1993.tex", replace booktabs compress nonumber label cells("mean(fmt(%15.2fc)) sd(fmt(%15.2fc)) p50(fmt(%15.0fc)) min(fmt(%15.0fc)) max(fmt(%15.0fc))") collabels(\multicolumn{1}{c}{{Mean}} \multicolumn{1}{c}{{SD}} \multicolumn{1}{c}{{Median}} \multicolumn{1}{c}{{Min}} \multicolumn{1}{c}{{Max}})	

	
	* Geographical Features
	eststo sum_physical : estpost tabstat AgrSurface AVG_WindDensity Turbine_installed, ///
    by(Mun_Level_Pos) statistics(mean sd min max) columns(statistics)

	esttab sum_physical using "Output\Sum_Physical_1993.tex", replace booktabs compress nonumber label cells("mean(fmt(%15.2fc)) sd(fmt(%15.2fc)) p50(fmt(%15.0fc)) min(fmt(%15.0fc)) max(fmt(%15.0fc))") collabels(\multicolumn{1}{c}{{Mean}} \multicolumn{1}{c}{{SD}} \multicolumn{1}{c}{{Median}} \multicolumn{1}{c}{{Min}} \multicolumn{1}{c}{{Max}})	
restore

preserve
drop if year!=1994
	*Outcomes
	eststo sum_social : estpost tabstat Population Inc_Pers_Tot Inc_Entrepr_Tot Bdgt_Total_T Emp_Tot, ///
    by(New_Rev_Pos) statistics(mean sd min max) columns(statistics)

	esttab sum_social using "Output\Sum_Social_1994.tex", replace booktabs compress nonumber label cells("mean(fmt(%15.2fc)) sd(fmt(%15.2fc)) p50(fmt(%15.0fc)) min(fmt(%15.0fc)) max(fmt(%15.0fc))") collabels(\multicolumn{1}{c}{{Mean}} \multicolumn{1}{c}{{SD}} \multicolumn{1}{c}{{Median}} \multicolumn{1}{c}{{Min}} \multicolumn{1}{c}{{Max}})	

	
	* Geographical Features
	eststo sum_physical : estpost tabstat AgrSurface AVG_WindDensity Turbine_installed, ///
    by(New_Rev_Pos) statistics(mean sd min max) columns(statistics)

	esttab sum_physical using "Output\Sum_Physical_1994.tex", replace booktabs compress nonumber label cells("mean(fmt(%15.2fc)) sd(fmt(%15.2fc)) p50(fmt(%15.0fc)) min(fmt(%15.0fc)) max(fmt(%15.0fc))") collabels(\multicolumn{1}{c}{{Mean}} \multicolumn{1}{c}{{SD}} \multicolumn{1}{c}{{Median}} \multicolumn{1}{c}{{Min}} \multicolumn{1}{c}{{Max}})	

restore


*-------------------------------------------------------------------------------
* Descriptive Statistics on Geographical Features
*-------------------------------------------------------------------------------


drop if year!=1993
eststo clear
// Create a variable for the row labels
gen strL variable = ""
replace variable = "Population" in 1
replace variable = "Inc_Pers_Tot" in 2
replace variable = "Inc_Entrepr_Tot" in 3
replace variable = "Bdgt_Total_T" in 4
replace variable = "Emp_Tot" in 5
replace variable = "Agr_Surface" in 6
replace variable = "Wind_Density" in 7
replace variable = "Stock_Turbines" in 8

matrix results = J(8, 5, .)

local row = 1
foreach var in Population Inc_Pers_Tot Inc_Entrepr_Tot Bdgt_Total_T Emp_Tot AgrSurface AVG_WindDensity Turbine_installed {
    ttest `var', by(Mun_Level_Pos)
    
    // Store t-test results in the matrix
    matrix results[`row', 1] = r(mu_1)  // Mean (Group 0)
    matrix results[`row', 2] = r(mu_2)  // Mean (Group 1)
    matrix results[`row', 3] = r(mu_2) - r(mu_1)  // Mean Difference
    matrix results[`row', 4] = r(t)  // T-Statistic
    matrix results[`row', 5] = r(p)  // P-Value

    local ++row
}

// Convert the matrix to a dataset
clear
svmat results

// Rename the columns
rename results1 Mean_No_Rev
rename results2 Mean_New_Rev
rename results3 Difference_Mean
rename results4 T_statistic
rename results5 P_Value

// Assign the row labels
gen strL Variable = ""
replace Variable = "Population" in 1
replace Variable = "Income, total" in 2
replace Variable = "Entrepreneurial Income" in 3
replace Variable = "Budget, total" in 4
replace Variable = "Employment, total" in 5
replace Variable = "Agr. Surface" in 6
replace Variable = "Avg. Wind Density" in 7
replace Variable = "Stock of installed Turbines" in 8

order Variable Mean_No_Rev Mean_New_Rev Difference_Mean T_statistic P_Value
format Mean_No_Rev Mean_New_Rev Difference_Mean T_statistic P_Value %9.1f

texsave * using "Output\ttest.tex", replace

	
