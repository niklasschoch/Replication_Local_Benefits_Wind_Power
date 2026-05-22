*-------------------------------------------------------------------------------
set more off
clear all
log close _all

/*
ssc install ivreg2
ssc install xtivreg2
ssc install xtivreg28 
ssc install ranktest
ssc install fitstat
search linktest
*/

// ===========================================================
// ============== Data loading and Preparation ===============
// ===========================================================

* Load Dataset and set panel
use "../FinalPanel.dta", clear
drop if year==2006
drop if FormerMunicipality =="Københavns"  

*Missing Turbines installed = no turbines installed
local vars "Turbine_installed"
foreach VVV in `vars' {
replace `VVV'=0 if `VVV'==.
}

*---------------- Cluster ------------------------------------------------------
global cluster_mun_year "MUN_ID year"
*-------------------------------------------------------------------------------
* Generate Budget categories
*-------------------------------------------------------------------------------
gen Bdgt_890_T = Bdgt_890_Rev - Bdgt_890_Exp
gen Bdgt_892_T = Bdgt_892_Rev - Bdgt_892_Exp
gen Bdgt_893_T = Bdgt_893_Rev - Bdgt_893_Exp
gen Bdgt_895_T = Bdgt_895_Rev - Bdgt_895_Exp
gen Bdgt_896_T = Bdgt_896_Rev - Bdgt_896_Exp

gen Bdgt_209_T = Bdgt_209_Exp - Bdgt_209_Rev
gen Bdgt_211_T = Bdgt_211_Exp - Bdgt_211_Rev
gen Bdgt_222_T = Bdgt_222_Exp - Bdgt_222_Rev

*-------------------------------------------------------------------------------
* Generate necessary lags before dropping anything
*-------------------------------------------------------------------------------

* Lags for GPS estimation
gen laggedAVGWindDensity=L2.AVG_WindDensity
gen laggedUnemplyRate = L.UmeplyRate

replace Emp_Tot_PC = Emp_Tot / Population
gen laggedEmployment = L.Emp_Tot_PC

gen laggedAgrSurface = L4_AgrSurface

gen lagged_Turbines = L3_Turbine_installed

replace New_Rev = 0 if missing(New_Rev)
replace New_Rev_PC = 0 if missing(New_Rev_PC)

* Lags for final Estimation
gen lagged_Rev_PC=L.New_Rev_PC
gen lagged_2_Rev_PC=L2.New_Rev_PC
gen lagged_3_Rev_PC=L3.New_Rev_PC

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

gen delta_Budget_890_T = D.Bdgt_890_T
gen delta_Budget_892_T = D.Bdgt_892_T
gen delta_Budget_893_T = D.Bdgt_893_T
gen delta_Budget_895_T = D.Bdgt_895_T
gen delta_Budget_896_T = D.Bdgt_896_T

gen delta_Budget_209_T = D.Bdgt_209_T
gen delta_Budget_211_T = D.Bdgt_211_T
gen delta_Budget_222_T = D.Bdgt_222_T
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

*Drop the years with zero as effect is identified on treatment intensity
drop if New_Rev == 0
drop if New_Rev_PC == 0
drop if year == 1994

// ===========================================================
// ============== 		GPS Estimation			==============
// ===========================================================
gen Rev_PC_int = int(New_Rev_PC)

centile Rev_PC_int, centile(25 50 75)
return list

gen cut=0
replace cut = r(c_1) if Rev_PC_int<=r(c_1)
replace cut = r(c_2) if Rev_PC_int>r(c_1) & Rev_PC_int<=r(c_2)
replace cut = r(c_3) if Rev_PC_int>r(c_2)


gpscore2 laggedAVGWindDensity lagged_Turbines laggedUnemplyRate, t(New_Rev_PC) gpscore(gpscore) link(log) family(gamma) predict(gpscore_predicted) sigma(ML) cutpoints(cut) index(mean) nq_gps(2) detail
eststo clear


* Check for multicollinearity
collin lagged_Rev_PC lagged_2_Rev_PC lagged_3_Rev_PC gpscore
*--> no collinearity

tabulate New_Rev_PC

// ===========================================================
// ============== 	Placebo Tests	==========
// ===========================================================
*--------------------------------------
*Set Panel
xtset MUN_ID year, yearly
sort MUN_ID year 

* Income

local reps 500 // Set the number of repetitions
matrix results = J(`reps', 2, .) // Create a matrix to store coefficients; replace _b with the number of coefficients

local outcomes "delta_income_Personal delta_income_Entre delta_income_Daily delta_Budget_T delta_Budget_Admin delta_Emp_Tot_PC delta_Emp_7009_PC delta_Emp_2600_PC delta_Emp_1709_PC delta_Emp_4009_PC delta_Emp_9800_PC delta_Emp_500_PC delta_Emp_1009_PC delta_Emp_5000_PC delta_Emp_2009_PC delta_Emp_5500_PC delta_Emp_6509_PC delta_Emp_2309_PC delta_Emp_3600_PC delta_Emp_6400_PC delta_Emp_7209_PC delta_Emp_7500_PC delta_Emp_5100_PC delta_Emp_8519_PC delta_Emp_6009_PC delta_Emp_9009_PC delta_Emp_1509_PC delta_Emp_Tot_PC delta_Emp_8539_PC delta_Emp_2709_PC delta_Emp_4500_PC delta_Emp_109_PC delta_Emp_8000_PC delta_Emp_5200_PC delta_Budget_T delta_Budget_Admin delta_Budget_Edu delta_Budget_Health delta_Budget_Housing delta_Budget_UT delta_Budget_Tra delta_income_Personal  delta_income_Entre delta_income_Wages delta_income_Pensions delta_income_Edu delta_income_Daily"
foreach VVV in `outcomes' {
	preserve
	forval i = 1/`reps' {
    // Generate a new placebo revenue variable
    gen Placebo_Revenue_`i' = rnormal(39, 76)
	
		// Run the regression and store the coefficients
		qui: xtreg `VVV' Placebo_Revenue_`i' i.year gpscore laggedUnemplyRate lagged_Turbines, vce(cluster MUN_ID)
		 // Collect the coefficients from the regression
		matrix results[`i', 1] = _b[Placebo_Revenue_`i'] // Store coefficient of lagged_Rev_PC
		
	    local b = _b[Placebo_Revenue_`i']	
		local se = _se[Placebo_Revenue_`i']
		local t_stat = `b' / `se'
		local p_value = 2 * ttail(e(df_m), abs(`t_stat'))
		
		matrix results[`i', 2] = `p_value' // P-value for Placebo_Revenue_`i'
	
    // Drop the placebo variable if needed for the next iteration
    drop Placebo_Revenue_`i'
	eststo clear
	}
	// Display or save the results matrix
	matlist results // View the matrix

	// Optionally, export to a file
	outsheet using "Random_Assingment_Graphs/placebo_results_`VVV'.csv", replace

	clear
	svmat results, names(col) // Converts the matrix into a variable in the dataset

	// Rename the variable to something meaningful
	rename c1 Placebo_Revenue_Coeff
	rename c2 Placebo_Revenue_pValue

	kdensity Placebo_Revenue_Coeff, lcolor(blue) lwidth(medium) lpattern(solid) ///
        title("Density of Placebo Revenue Coefficients") ///
        xtitle("Coefficient Value") ytitle("Density") ///
        name(density_plot, replace)
		
	scatter Placebo_Revenue_pValue Placebo_Revenue_Coeff, ///
        msymbol(o) mcolor(red) ///
        ytitle("P-Value") xtitle("Coefficient Value") ///
        title("P-Values of Placebo Revenue Coefficients") ///
        ylabel(0(.5) 1) yscale(range(0 1)) ///
        name(scatter_plot, replace)
	// Combine the Plots
	graph combine density_plot scatter_plot, title("Combined Plot: Coefficients and P-Values")
	// Save
	graph save "Random_Assingment_Graphs/Combined_Plot_`VVV'.gph", replace
	restore
}

