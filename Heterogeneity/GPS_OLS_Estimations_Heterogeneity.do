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
net describe collin, from(https://stats.idre.ucla.edu/stat/stata/ado/analysis)
net install collin
ssc install doseresponse2
search linktest
*/

// ===========================================================
// ============== Data loading and Preparation ===============
// ===========================================================

* Load Dataset and set panel
use FinalPanel_with_Capacity, clear
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

gen Rev_PC_int = int(New_Rev_PC)
centile Rev_PC_int, centile(25 50 75)
gen cut=0
replace cut = r(c_1) if Rev_PC_int<=r(c_1)
replace cut = r(c_2) if Rev_PC_int>r(c_1) & Rev_PC_int<=r(c_2)
replace cut = r(c_3) if Rev_PC_int>r(c_2)

gpscore2 laggedAVGWindDensity lagged_Turbines laggedUnemplyRate, t(New_Rev_PC) gpscore(gpscore) link(log) family(gamma) predict(gpscore_predicted) sigma(ML) cutpoints(cut) index(mean) nq_gps(2) detail
eststo clear

*-------------------------------------------------------------------------------
* Descriptive Statistics on Rev_PC
*-------------------------------------------------------------------------------
kdensity TurbineCapkW 

sum TurbineCapkW, detail
scalar turbines_25 = r(p25)
display turbines_25

scalar turbines_75 = r(p75)
display turbines_75
gen turbines_above_75 = (TurbineCapkW >= turbines_75)
gen turbines_below_25 = (TurbineCapkW <= turbines_25)

// ===========================================================
// ============== 		Heterogeniety - Scale	==============
// ===========================================================
preserve
drop if turbines_above_75 == 1

* Income
eststo clear
local outcomes_income_Delta "delta_income_Personal  delta_income_Entre delta_income_Wages delta_income_Pensions delta_income_Edu delta_income_Daily"
foreach VVV in `outcomes_income_Delta' {
qui: eststo: xtreg `VVV' lagged_Rev_PC lagged_2_Rev_PC lagged_3_Rev_PC i.year gpscore, vce(cluster MUN_ID)
qui: estadd local YFE "Yes"
}
estimates table est1 est2 est3 est4 est5 est6, star(0.1 0.05 0.01) stats(N, N_g, g_min, g_max, j, df_m, chi2, hansenp, han_df)

esttab using "Output\Incomes_75.tex", keep(lagged_Rev_PC lagged_2_Rev_PC lagged_3_Rev_PC gpscore) booktabs ///
varlabels(lagged_Rev_PC "\addlinespace \makecell{L.Revenue \\ per capita}" lagged_2_Rev_PC "\makecell{L(2).Revenue \\ per capita}" lagged_3_Rev_PC "\makecell{L(3).Revenue \\ per capita}" gpscore "GPS", elist(L.New_Rev_PC "\addlinespace" L2.New_Rev_PC "\addlinespace" L3.New_Rev_PC "\addlinespace" gpscore "\addlinespace" )) ///
posthead("\multicolumn{7}{l}{\parbox{11cm}{Outcome variable: Income by type, normalised per capita. }} \\ \multicolumn{7}{l}{\parbox{11cm}{Explanatory variables: Generalised Propensity Score, New revenues from wind power deployment}} \\ \midrule & Total & Entre. & Wages & Pensions & Educ. & Benefits \\ \toprule") ///
stat(YFE N, labels("\addlinespace Year FE" "\addlinespace \midrule \addlinespace Observations" "Adj. R-squared")) ///
p star(* 0.1 ** 0.05 *** 0.01) ///
title(Effect of Wind Power Deployment on the Personal Income - Excluding the top 25\% \label{incomeresults75}) ///
nomtitle nonumbers nonotes nogaps ///
note(p-values in parentheses, $^{*}\, p<0.1$, $^{**}\, p<0.05$, $^{***}\, p<0.01$) width(\hsize) replace

eststo clear
local outcomes_Budget_Delta "delta_Budget_T delta_Budget_Admin delta_Budget_Edu delta_Budget_Health delta_Budget_Housing delta_Budget_UT delta_Budget_Tra"
foreach VVV in `outcomes_Budget_Delta' {
qui: eststo: xtreg `VVV' lagged_Rev_PC lagged_2_Rev_PC lagged_3_Rev_PC i.year gpscore, vce(cluster MUN_ID)
qui: estadd local YFE "Yes"
}
estimates table est1 est2 est3 est4 est5 est6 est7, star(0.1 0.05 0.01) stats(N, N_g, g_min, g_max, j, df_m, chi2, hansenp, han_df)

esttab using "Output\Budgets_Total_75.tex", keep(lagged_Rev_PC lagged_2_Rev_PC lagged_3_Rev_PC gpscore) booktabs ///
varlabels(lagged_Rev_PC "\addlinespace \makecell{L.Revenue \\ per capita}" lagged_2_Rev_PC "\makecell{L(2).Revenue \\ per capita}" lagged_3_Rev_PC "\makecell{L(3).Revenue \\ per capita}" gpscore "GPS", elist(L.New_Rev_PC "\addlinespace" L2.New_Rev_PC "\addlinespace" L3.New_Rev_PC "\addlinespace" gpscore "\addlinespace" )) ///
posthead("\multicolumn{8}{l}{\parbox{11cm}{Outcome variable: Municipal budget by type, normalised per capita.}} \\ \multicolumn{8}{l}{\parbox{11cm}{Explanatory variables: Generalised Propensity Score, New revenues from wind power deployment}} \\ \midrule & Total & Admin & Educ. & Health & Housing & Utilities & Infra \\ \toprule") ///
stat(YFE N, labels("\addlinespace Year FE" "\addlinespace \midrule \addlinespace Observations" "Adj. R-squared")) ///
p star(* 0.1 ** 0.05 *** 0.01) ///
title(Effect of Wind Power Deployment on the Municipal Budget - Excluding the top 25\% \label{budgetresults75}) ///
nomtitle nonumbers nonotes nogaps ///
note(p-values in parentheses, $^{*}\, p<0.1$, $^{**}\, p<0.05$, $^{***}\, p<0.01$) width(\hsize) replace

eststo clear
local outcomes_employment_Delta "delta_Emp_Tot_PC delta_Emp_8539_PC delta_Emp_2709_PC delta_Emp_4500_PC delta_Emp_109_PC delta_Emp_8000_PC delta_Emp_5200_PC"
foreach VVV in `outcomes_employment_Delta' {
qui: eststo: xtreg `VVV' lagged_Rev_PC lagged_2_Rev_PC lagged_3_Rev_PC i.year gpscore, vce(cluster MUN_ID)
qui: estadd local YFE "Yes"
}
estimates table est1 est2 est3 est4 est5 est6 est7, star(0.1 0.05 0.01) stats(N, N_g, g_min, g_max, j, df_m, chi2, hansenp, han_df)

esttab using "Output\Employment_detailed1_75.tex", keep(lagged_Rev_PC lagged_2_Rev_PC lagged_3_Rev_PC gpscore) booktabs ///
varlabels(lagged_Rev_PC "\addlinespace \makecell{L.Revenue \\ per capita}" lagged_2_Rev_PC "\makecell{L(2).Revenue \\ per capita}" lagged_3_Rev_PC "\makecell{L(3).Revenue \\ per capita}" gpscore "GPS", elist(L.New_Rev_PC "\addlinespace" L2.New_Rev_PC "\addlinespace" L3.New_Rev_PC "\addlinespace" gpscore "\addlinespace" )) ///
posthead("\multicolumn{8}{l}{\parbox{11cm}{Outcome variable: Employment by sector, normalised per 10.000 capita.}} \\ \multicolumn{8}{l}{\parbox{11cm}{Explanatory variables: Generalised Propensity Score, New revenues from wind power deployment}} \\ \midrule & Total & Social Institutions & Mfr. of basic metals & Construction & Agriculture & Education & Retail and Repair \\ \toprule")  ///
stat(YFE N, labels("\addlinespace Year FE" "\addlinespace \midrule \addlinespace Observations" "Adj. R-squared")) ///
p star(* 0.1 ** 0.05 *** 0.01) ///
title(Effect of Wind Power Deployment on Employment - Excluding the top 25\% \label{employmentresults75}) ///
nomtitle nonumbers nonotes nogaps ///
note(p-values in parentheses, $^{*}\, p<0.1$, $^{**}\, p<0.05$, $^{***}\, p<0.01$) width(\hsize) replace

restore

preserve
drop if turbines_below_25 == 1
* Income
eststo clear
local outcomes_income_Delta "delta_income_Personal  delta_income_Entre delta_income_Wages delta_income_Pensions delta_income_Edu delta_income_Daily"
foreach VVV in `outcomes_income_Delta' {
qui: eststo: xtreg `VVV' lagged_Rev_PC lagged_2_Rev_PC lagged_3_Rev_PC i.year gpscore, vce(cluster MUN_ID)
qui: estadd local YFE "Yes"
}
estimates table est1 est2 est3 est4 est5 est6, star(0.1 0.05 0.01) stats(N, N_g, g_min, g_max, j, df_m, chi2, hansenp, han_df)

esttab using "Output\Incomes_25.tex", keep(lagged_Rev_PC lagged_2_Rev_PC lagged_3_Rev_PC gpscore) booktabs ///
varlabels(lagged_Rev_PC "\addlinespace \makecell{L.Revenue \\ per capita}" lagged_2_Rev_PC "\makecell{L(2).Revenue \\ per capita}" lagged_3_Rev_PC "\makecell{L(3).Revenue \\ per capita}" gpscore "GPS", elist(L.New_Rev_PC "\addlinespace" L2.New_Rev_PC "\addlinespace" L3.New_Rev_PC "\addlinespace" gpscore "\addlinespace" )) ///
posthead("\multicolumn{7}{l}{\parbox{11cm}{Outcome variable: Income by type, normalised per capita. }} \\ \multicolumn{7}{l}{\parbox{11cm}{Explanatory variables: Generalised Propensity Score, New revenues from wind power deployment}} \\ \midrule & Total & Entre. & Wages & Pensions & Educ. & Benefits \\ \toprule") ///
stat(YFE N, labels("\addlinespace Year FE" "\addlinespace \midrule \addlinespace Observations" "Adj. R-squared")) ///
p star(* 0.1 ** 0.05 *** 0.01) ///
title(Effect of Wind Power Deployment on the Personal Income - Excluding the bottom 25\% \label{incomeresults25}) ///
nomtitle nonumbers nonotes nogaps ///
note(p-values in parentheses, $^{*}\, p<0.1$, $^{**}\, p<0.05$, $^{***}\, p<0.01$) width(\hsize) replace

eststo clear
local outcomes_Budget_Delta "delta_Budget_T delta_Budget_Admin delta_Budget_Edu delta_Budget_Health delta_Budget_Housing delta_Budget_UT delta_Budget_Tra"
foreach VVV in `outcomes_Budget_Delta' {
qui: eststo: xtreg `VVV' lagged_Rev_PC lagged_2_Rev_PC lagged_3_Rev_PC i.year gpscore, vce(cluster MUN_ID)
qui: estadd local YFE "Yes"
}
estimates table est1 est2 est3 est4 est5 est6 est7, star(0.1 0.05 0.01) stats(N, N_g, g_min, g_max, j, df_m, chi2, hansenp, han_df)

esttab using "Output\Budgets_Total_25.tex", keep(lagged_Rev_PC lagged_2_Rev_PC lagged_3_Rev_PC gpscore) booktabs ///
varlabels(lagged_Rev_PC "\addlinespace \makecell{L.Revenue \\ per capita}" lagged_2_Rev_PC "\makecell{L(2).Revenue \\ per capita}" lagged_3_Rev_PC "\makecell{L(3).Revenue \\ per capita}" gpscore "GPS", elist(L.New_Rev_PC "\addlinespace" L2.New_Rev_PC "\addlinespace" L3.New_Rev_PC "\addlinespace" gpscore "\addlinespace" )) ///
posthead("\multicolumn{8}{l}{\parbox{11cm}{Outcome variable: Municipal budget by type, normalised per capita.}} \\ \multicolumn{8}{l}{\parbox{11cm}{Explanatory variables: Generalised Propensity Score, New revenues from wind power deployment}} \\ \midrule & Total & Admin & Educ. & Health & Housing & Utilities & Infra \\ \toprule") ///
stat(YFE N, labels("\addlinespace Year FE" "\addlinespace \midrule \addlinespace Observations" "Adj. R-squared")) ///
p star(* 0.1 ** 0.05 *** 0.01) ///
title(Effect of Wind Power Deployment on the Municipal Budget - Excluding the bottom 25\% \label{budgetresults25}) ///
nomtitle nonumbers nonotes nogaps ///
note(p-values in parentheses, $^{*}\, p<0.1$, $^{**}\, p<0.05$, $^{***}\, p<0.01$) width(\hsize) replace

eststo clear
local outcomes_employment_Delta "delta_Emp_Tot_PC delta_Emp_8539_PC delta_Emp_2709_PC delta_Emp_4500_PC delta_Emp_109_PC delta_Emp_8000_PC delta_Emp_5200_PC"
foreach VVV in `outcomes_employment_Delta' {
qui: eststo: xtreg `VVV' lagged_Rev_PC lagged_2_Rev_PC lagged_3_Rev_PC i.year gpscore, vce(cluster MUN_ID)
qui: estadd local YFE "Yes"
}
estimates table est1 est2 est3 est4 est5 est6 est7, star(0.1 0.05 0.01) stats(N, N_g, g_min, g_max, j, df_m, chi2, hansenp, han_df)

esttab using "Output\Employment_detailed1_25.tex", keep(lagged_Rev_PC lagged_2_Rev_PC lagged_3_Rev_PC gpscore) booktabs ///
varlabels(lagged_Rev_PC "\addlinespace \makecell{L.Revenue \\ per capita}" lagged_2_Rev_PC "\makecell{L(2).Revenue \\ per capita}" lagged_3_Rev_PC "\makecell{L(3).Revenue \\ per capita}" gpscore "GPS", elist(L.New_Rev_PC "\addlinespace" L2.New_Rev_PC "\addlinespace" L3.New_Rev_PC "\addlinespace" gpscore "\addlinespace" )) ///
posthead("\multicolumn{8}{l}{\parbox{11cm}{Outcome variable: Employment by sector, normalised per 10.000 capita.}} \\ \multicolumn{8}{l}{\parbox{11cm}{Explanatory variables: Generalised Propensity Score, New revenues from wind power deployment}} \\ \midrule & Total & Social Institutions & Mfr. of basic metals & Construction & Agriculture & Education & Retail and Repair \\ \toprule")  ///
stat(YFE N, labels("\addlinespace Year FE" "\addlinespace \midrule \addlinespace Observations" "Adj. R-squared")) ///
p star(* 0.1 ** 0.05 *** 0.01) ///
title(Effect of Wind Power Deployment on Employment - Excluding the bottom 25\% \label{employmentresults25}) ///
nomtitle nonumbers nonotes nogaps ///
note(p-values in parentheses, $^{*}\, p<0.1$, $^{**}\, p<0.05$, $^{***}\, p<0.01$) width(\hsize) replace
restore
