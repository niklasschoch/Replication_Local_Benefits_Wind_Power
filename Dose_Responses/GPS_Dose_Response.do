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
ssc install doseresponse2
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

*Drop the years with zero as effect is identified on treatment intensity
drop if New_Rev == 0
drop if New_Rev_PC == 0
drop if year == 1994

drop if missing(lagged_2_Rev_PC)
drop if missing(lagged_3_Rev_PC)
*-------------------------------------------------------------------------------
* Descriptive Statistics on Rev_PC
*-------------------------------------------------------------------------------
hist New_Rev_PC, frequency ytitle(Number of observations) xtitle(New_Rev_PC) ylabel(0(200)400, format(%20s) nogrid) width(10) graphregion(color(white) lcolor(black) lwidth(medium)) color(forest_green)
graph export "..\Output\Distribution-Treatment.png", replace

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


// =======================================================
// ============== 			Incomes			==============
// =======================================================

preserve
matrix define tp = (40\60\80\100\120\140\160)
doseresponse2 laggedAVGWindDensity laggedUnemplyRate lagged_Turbines, outcome(delta_income_Personal) t(New_Rev_PC) dose_response(dose_response) gpscore(gpscore) link(log) family(gamma) predict(gpscore_predicted) sigma(ML) cutpoints(cut) index(mean) tpoints(tp) delta(1) reg_type_t(cubic) reg_type_gps(cubic) nq_gps(2) detail  bootstrap(yes) boot_reps(50) analysis(yes) analysis_level(0.9)
graph save Graph "Relevant\doseresponse_total.gph", replace
graph export "Relevant\doseresponse_total.png", replace
restore

preserve
matrix define tp = (40\60\80\100\120\140\160)
doseresponse2 laggedAVGWindDensity laggedUnemplyRate lagged_Turbines, outcome(delta_income_Entre) t(New_Rev_PC) dose_response(dose_response) gpscore(gpscore) link(log) family(gamma) predict(gpscore_predicted) sigma(ML) cutpoints(cut) index(mean) tpoints(tp) delta(1) reg_type_t(cubic) reg_type_gps(cubic) nq_gps(2) detail  bootstrap(yes) boot_reps(50) analysis(yes) analysis_level(0.9)
graph save Graph "Relevant\doseresponse_entrepreneurial.gph", replace
graph export "Relevant\doseresponse_entrepreneurial.png", replace
restore

preserve
matrix define tp = (40\60\80\100\120\140\160)
doseresponse2 laggedAVGWindDensity laggedUnemplyRate lagged_Turbines, outcome(delta_income_Daily) t(New_Rev_PC) dose_response(dose_response) gpscore(gpscore) link(log) family(gamma) predict(gpscore_predicted) sigma(ML) cutpoints(cut) index(mean) tpoints(tp) delta(1) reg_type_t(cubic) reg_type_gps(cubic) nq_gps(2) detail  bootstrap(yes) boot_reps(50) analysis(yes) analysis_level(0.9)
graph save Graph "Relevant\doseresponse_benefits.gph", replace
graph export "Relevant\doseresponse_benefits.png", replace

restore

// =======================================================
// ============== 			Budget			==============
// =======================================================

preserve
matrix define tp = (40\60\80\100\120\140\160)
doseresponse2 laggedAVGWindDensity laggedUnemplyRate lagged_Turbines, outcome(delta_Budget_T) t(New_Rev_PC) dose_response(dose_response) gpscore(gpscore) link(log) family(gamma) predict(gpscore_predicted) sigma(ML) cutpoints(cut) index(mean) tpoints(tp) delta(1) reg_type_t(cubic) reg_type_gps(cubic) nq_gps(2) detail  bootstrap(yes) boot_reps(50) analysis(yes) analysis_level(0.9)
graph save Graph "Relevant\doseresponse_Budget_Tot.gph", replace
graph export "Relevant\doseresponse_Budget_Tot.png", replace
restore

// =======================================================
// ============== 			Employment		==============
// =======================================================

preserve
matrix define tp = (40\60\80\100\120\140\160)
doseresponse2 laggedAVGWindDensity laggedUnemplyRate lagged_Turbines, outcome(delta_Emp_Tot_PC) t(New_Rev_PC) dose_response(dose_response) gpscore(gpscore) link(log) family(gamma) predict(gpscore_predicted) sigma(ML) cutpoints(cut) index(mean) tpoints(tp) delta(1) reg_type_t(cubic) reg_type_gps(cubic) nq_gps(2) detail  bootstrap(yes) boot_reps(50) analysis(yes) analysis_level(0.9)
graph save Graph "Relevant\doseresponse_Employment.gph", replace
graph export "Relevant\doseresponse_Employment.png", replace
restore


// =======================================================
// ============== 			All Responses	==============
// =======================================================


* Income
eststo clear
local outcomes_income_Delta "delta_income_Personal  delta_income_Entre delta_income_Wages delta_income_Pensions delta_income_Edu delta_income_Daily"
foreach VVV in `outcomes_income_Delta' {
preserve
matrix define tp = (40\60\80\100\120\140\160)
doseresponse2 laggedAVGWindDensity laggedUnemplyRate lagged_Turbines, outcome(`VVV') t(New_Rev_PC) dose_response(dose_response) gpscore(gpscore) link(log) family(gamma) predict(gpscore_predicted) sigma(ML) cutpoints(cut) index(mean) tpoints(tp) delta(1) reg_type_t(cubic) reg_type_gps(cubic) nq_gps(2) detail  bootstrap(yes) boot_reps(50) analysis(yes) analysis_level(0.9)
// Save the graph with the outcome name in the file
local filename_gph = "All_Responses/doseresponse_`VVV'.gph"
local filename_png = "All_Responses/doseresponse_`VVV'.png"  
graph save "`filename_gph'", replace
graph export "`filename_png'", replace
restore
}

local outcomes_Budget_Delta "delta_Budget_T delta_Budget_Admin delta_Budget_Edu delta_Budget_Health delta_Budget_Housing delta_Budget_UT delta_Budget_Tra"
foreach VVV in `outcomes_Budget_Delta' {
preserve
matrix define tp = (40\60\80\100\120\140\160)
doseresponse2 laggedAVGWindDensity laggedUnemplyRate lagged_Turbines, outcome(`VVV') t(New_Rev_PC) dose_response(dose_response) gpscore(gpscore) link(log) family(gamma) predict(gpscore_predicted) sigma(ML) cutpoints(cut) index(mean) tpoints(tp) delta(1) reg_type_t(cubic) reg_type_gps(cubic) nq_gps(2) detail  bootstrap(yes) boot_reps(50) analysis(yes) analysis_level(0.9)
// Save the graph with the outcome name in the file
local filename_gph = "All_Responses/doseresponse_`VVV'.gph"
local filename_png = "All_Responses/doseresponse_`VVV'.png"  
graph save "`filename_gph'", replace
graph export "`filename_png'", replace
restore
}

local outcomes_employment_Delta "delta_Emp_Tot_PC delta_Emp_8539_PC delta_Emp_2709_PC delta_Emp_4500_PC delta_Emp_109_PC delta_Emp_8000_PC delta_Emp_5200_PC"
foreach VVV in `outcomes_employment_Delta' {
preserve
matrix define tp = (40\60\80\100\120\140\160)
doseresponse2 laggedAVGWindDensity laggedUnemplyRate lagged_Turbines, outcome(`VVV') t(New_Rev_PC) dose_response(dose_response) gpscore(gpscore) link(log) family(gamma) predict(gpscore_predicted) sigma(ML) cutpoints(cut) index(mean) tpoints(tp) delta(1) reg_type_t(cubic) reg_type_gps(cubic) nq_gps(2) detail  bootstrap(yes) boot_reps(50) analysis(yes) analysis_level(0.9)
// Save the graph with the outcome name in the file
local filename_gph = "All_Responses/doseresponse_`VVV'.gph"
local filename_png = "All_Responses/doseresponse_`VVV'.png"  
graph save "`filename_gph'", replace
graph export "`filename_png'", replace
restore
}
local outcomes_employment_Delta2 "delta_Emp_7209_PC delta_Emp_7500_PC delta_Emp_5100_PC delta_Emp_8519_PC delta_Emp_6009_PC delta_Emp_9009_PC delta_Emp_1509_PC"
foreach VVV in `outcomes_employment_Delta2' {
preserve
matrix define tp = (40\60\80\100\120\140\160)
doseresponse2 laggedAVGWindDensity laggedUnemplyRate lagged_Turbines, outcome(`VVV') t(New_Rev_PC) dose_response(dose_response) gpscore(gpscore) link(log) family(gamma) predict(gpscore_predicted) sigma(ML) cutpoints(cut) index(mean) tpoints(tp) delta(1) reg_type_t(cubic) reg_type_gps(cubic) nq_gps(2) detail  bootstrap(yes) boot_reps(50) analysis(yes) analysis_level(0.9)
// Save the graph with the outcome name in the file
local filename_gph = "All_Responses/doseresponse_`VVV'.gph"
local filename_png = "All_Responses/doseresponse_`VVV'.png"  
graph save "`filename_gph'", replace
graph export "`filename_png'", replace
restore
}
local outcomes_employment_Delta3 "delta_Emp_5000_PC delta_Emp_2009_PC delta_Emp_5500_PC delta_Emp_6509_PC delta_Emp_2309_PC delta_Emp_3600_PC delta_Emp_6400_PC"
foreach VVV in `outcomes_employment_Delta3' {
preserve
matrix define tp = (40\60\80\100\120\140\160)
doseresponse2 laggedAVGWindDensity laggedUnemplyRate lagged_Turbines, outcome(`VVV') t(New_Rev_PC) dose_response(dose_response) gpscore(gpscore) link(log) family(gamma) predict(gpscore_predicted) sigma(ML) cutpoints(cut) index(mean) tpoints(tp) delta(1) reg_type_t(cubic) reg_type_gps(cubic) nq_gps(2) detail  bootstrap(yes) boot_reps(50) analysis(yes) analysis_level(0.9)
// Save the graph with the outcome name in the file
local filename_gph = "All_Responses/doseresponse_`VVV'.gph"
local filename_png = "All_Responses/doseresponse_`VVV'.png"  
graph save "`filename_gph'", replace
graph export "`filename_png'", replace
restore
}
local outcomes_employment_Delta4 "delta_Emp_7009_PC delta_Emp_2600_PC delta_Emp_1709_PC delta_Emp_4009_PC delta_Emp_9800_PC delta_Emp_500_PC delta_Emp_1009_PC"
foreach VVV in `outcomes_employment_Delta4' {
preserve
matrix define tp = (40\60\80\100\120\140\160)
doseresponse2 laggedAVGWindDensity laggedUnemplyRate lagged_Turbines, outcome(`VVV') t(New_Rev_PC) dose_response(dose_response) gpscore(gpscore) link(log) family(gamma) predict(gpscore_predicted) sigma(ML) cutpoints(cut) index(mean) tpoints(tp) delta(1) reg_type_t(cubic) reg_type_gps(cubic) nq_gps(2) detail  bootstrap(yes) boot_reps(50) analysis(yes) analysis_level(0.9)
// Save the graph with the outcome name in the file
local filename_gph = "All_Responses/doseresponse_`VVV'.gph"
local filename_png = "All_Responses/doseresponse_`VVV'.png"  
graph save "`filename_gph'", replace
graph export "`filename_png'", replace
restore
}
