set more off 
clear all 
log close _all 
capture which egenmore  
if _rc ssc install egenmore
capture which egenmore  
if _rc ssc install mmerge  
capture which elabel  
if _rc ssc install elabel  
*------------------------------
*------------------------------
********************************************************************************
* Overview of temporary saved and used datasets :
* Temp1 - Temp 1_1 - 1_3 = Budget data (source: Statistics Denmark)
* Temp2 = Income data (source: Statistics Denmark) 
* Temp3 = Employment data, aggregated by workplace (source: Statistics Denmark) 
* Temp4 = Employment data, aggregated by residence (source: Statistics Denmark) 
* Temp5 = Unemployment data (source: Statistics Denmark)  
* Temp6 = Population data (source: Statistics Denmark) 
* Temp7 = Agricultural surface data from the census 1999 (source: Statistics Denmark) 
* Temp8 = Agricultural surface data on county level (source: Statistics Denmark) 
* Temp9 = Agricultural surface data on municipal level(combination of Temp8 + Temp9) 
* Temp10 = County data with minor edits (source: Statistics Denmark)  
* Temp11 = Average wind density (source: Global Wind Atlas & QGIS/DigDag) 
* Temp12 = Electricity Price 1985-1999 (source: Danish Energy Agency) 
* Temp13 = Hourly electricity price 2000-2010 (source: Danish Energy Agency) 
* Temp14 = Hourly wind production and electricity price 2000-2010 (source: Danish Energy Agency) 
* Temp15 = Yearly sum wind production 2000-2010 (source: Danish Energy Agency) 
* Temp16 = Electricity price 1985-2010 (source: Danish Energy Agency) 
* Temp17 = Municipalitie's corresponding electricity grid (source : QGIS/DigDag) 
* Temp18 = New Revenues and lagged number of turbine installations (source: DigDag and Danish Energy Agency)
* ElecSupport: Yearly electricity support in cEuro/kWh 1990-2006 (source: EnergiStyrelsen)
* TurbineMaster: Overview of the turbine data used to calculate the new revenues (source: EnergiStyrelsen, QGIS/DigDag and The Danish Energy Agency)
* CountyData: Overview of the municipalities and the corresponding county (source: Statistics Denmark) 
********************************************************************************
* The names of Danish Municipalities include special letters (like ø, å, æ) which are not always well handled by QGIS, Stata & Excel.
* Depending on the data source (Statistics Denmark, QGIS/DigDag) the spelling differs and the names hence have to be adjusted manually. 
* Edits for data obtained from Statistics Denmark: The predefined data cleaning program "DataCleaning" adjusts the names
* Edits for data obtained from QGIS/DigDag: The names are adjusted manually for each data set 
*********
* The island of Bornholm consists of the following municipalities: Aakrikreby, Rønne, Nexø, Hasle and Allinge-Gudhjem. 
* For these five municipalities, the data are sometime not available after 2002 (depending on the data source).
* We drop these five municipalities and instead use the county data (Bornholm) for which we have the complete data until 2006.
* This is done for the data sets Temp9, Temp11, Temp18.
*********
* In 2007, the 270 municipalities (except for Marstal and Aeroskobing) were consolidated into 98 larger regions. 
* The merging of Marstal and Ærøskøbing into the municipality of Ærø took place in 2005.
* We account for this and merge the data for Marstal, Ærøskøbing and Ærø into one sinlge municipality.
* This was done all data sets.  
*********
* The county of Copenhagen is consolidated into one single municipality called Københavns. 
* We finally exclude this municipality from the estimion as this urban area is significantly different from the others. 
********************************************************************************
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*							LOG START 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
log using "./log/Output.log", replace 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* The data sets Temp1, Temp2, Temp3, Temp4, Temp5, Temp6, Temp7, Temp10 come from the same source and thus are similar in reporting.  
* We define a Stata-Programm "DataCleaning" to harmonize the reporting with the other data sources 
*Predefined data cleaning program 
program DataCleaning
replace FormerMunicipality="BornholmsRegions" if FormerMunicipality=="Bornholm(excl.Christiansø)"
replace FormerMunicipality="Bornholm" if FormerMunicipality=="BornholmsRegions"
replace FormerMunicipality="Faxe" if FormerMunicipality=="Fakse"
replace FormerMunicipality="Fåborg" if FormerMunicipality=="Faaborg"
replace FormerMunicipality="Grenå" if FormerMunicipality=="Grenaa"
replace FormerMunicipality="Holmegård" if FormerMunicipality=="Holmegaard"
replace FormerMunicipality="Hårby" if FormerMunicipality=="Haarby"
replace FormerMunicipality="Åbenrå" if FormerMunicipality=="Aabenraa"
replace FormerMunicipality="Åbybro" if FormerMunicipality=="Aabybro"
replace FormerMunicipality="Ålborg" if FormerMunicipality=="Aalborg"
replace FormerMunicipality="Ålestrup" if FormerMunicipality=="Aalestrup"
replace FormerMunicipality="Års" if FormerMunicipality=="Aars"
replace FormerMunicipality="Årup"  if FormerMunicipality=="Aarup"
replace FormerMunicipality="Torslunde-Ishøj" if FormerMunicipality=="Ishøj" 
replace FormerMunicipality="NykøbingFalsters" if FormerMunicipality=="Nykøbing-Falster" 
replace FormerMunicipality="Nørreåby" if FormerMunicipality=="NørreAaby" 
replace FormerMunicipality="Sydlangelands" if FormerMunicipality=="Sydlangeland" 
replace FormerMunicipality="Aakrikreby" if FormerMunicipality=="Aakirkeby(-2002)"
replace FormerMunicipality="Allinge-Gudhjem" if FormerMunicipality=="Allinge-Gudhjem(-2002)"
replace FormerMunicipality="Hasle" if FormerMunicipality=="Hasle(-2002)"
replace FormerMunicipality="Nexø" if FormerMunicipality=="Nexø(-2002)"
replace FormerMunicipality="Rønne" if FormerMunicipality=="Rønne(-2002)"
replace FormerMunicipality="Marstal" if FormerMunicipality=="Marstal(-2005/2006)" 
*-------------------------- 
* Drop county data (we focus on the municipality data)
drop if FormerMunicipality=="Copenhagenregion"
drop if FormerMunicipality=="AllDenmark"
drop if FormerMunicipality=="ÅrhusCounty"
drop if FormerMunicipality=="CopenhagenCounty"
drop if FormerMunicipality=="CopenhagenandFrederiksberg"
drop if FormerMunicipality=="FrederiksborgCounty"
drop if FormerMunicipality=="FunenCounty"
drop if FormerMunicipality=="NorthJutlandCounty"
drop if FormerMunicipality=="RingkøbingCounty"
drop if FormerMunicipality=="RoskildeCounty"
drop if FormerMunicipality=="SouthJutlandCounty"
drop if FormerMunicipality=="StorstrømCounty"
drop if FormerMunicipality=="ViborgCounty"
drop if FormerMunicipality=="VejleCounty"
drop if FormerMunicipality=="WestZealandCounty"
drop if FormerMunicipality=="RibeCounty"
*---------------------------
drop if FormerMunicipality=="Christiansø(Outsidethemunicipalities)"
*---------------------------
* Drop outsiders
drop if FormerMunicipality=="OutsideDenmark"
drop if FormerMunicipality=="Municipalitynotstated"
drop if FormerMunicipality=="Greenland"
drop if FormerMunicipality=="FaroeIslands"
drop if FormerMunicipality=="Abroad/EUpension(997)"
drop if FormerMunicipality=="Abroad"
*----------------------------
* Drop council data (we focus on the municipality data)
drop if FormerMunicipality=="GreaterCopenhagenCouncil"
drop if FormerMunicipality=="TheGreaterCopenhagenDevelopmentCouncil"
drop if FormerMunicipality=="CopenhagenCountyCouncilDistrict"
drop if FormerMunicipality=="FrederiksborgCountyCouncilDistrict"
drop if FormerMunicipality=="RoskildeCountyCouncilDistrict"
drop if FormerMunicipality=="WestZealandCountyCouncilDistrict"
drop if FormerMunicipality=="StorstrømCountyCouncilDistrict"
drop if FormerMunicipality=="BornholmCountyCouncilDistrict"
drop if FormerMunicipality=="FunenCountyCouncilDistrict"
drop if FormerMunicipality=="SouthJutlandCountyCouncilDistrict"
drop if FormerMunicipality=="RibeCountyCouncilDistrict"
drop if FormerMunicipality=="VejleCountyCouncilDistrict"
drop if FormerMunicipality=="RingkøbingCountyCouncilDistrict"
drop if FormerMunicipality=="ÅrhusCountyCouncilDistrict"
drop if FormerMunicipality=="ViborgCountyCouncilDistrict"
drop if FormerMunicipality=="NorthJutlandCountyCouncilDistrict"
*----------------------------
end 
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
* The code proceeds as follows:
* First, we import the sheets from the Excel-File "Data Sources and Panel.xls". 
* Then we do the cleaning and editing needed in the names. We reshape the data into a municipality-year format.
* This is done separately for each data-sheet (Municipal Budget, Income, Employment, Unemployment,...).   
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*						 Data from Statistics Denmark  
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*							Municipal Budget 
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
import excel "./Data Sources and Panel.xls", sheet("Budget BUD1 Total") firstrow clear 
*---------------------
rename A TypeofBudget
replace TypeofBudget = subinstr(TypeofBudget," ","",.)
rename B FormerMunicipality
replace FormerMunicipality = subinstr(FormerMunicipality," ","",.)
*------------------------------------------------------------------------------*
gen TEMP_ID= _n
reshape long _,i(TEMP_ID) j(year)
*------------------------------------
egen Budget_ID=group(TypeofBudget) 
egen MUN_ID=group(FormerMunicipality)
*------------------------------------
drop TEMP_ID TypeofBudget
*------------------------------------
rename _ Budget_
reshape wide Budget_, i(MUN_ID year) j(Budget_ID) 
drop MUN_ID
*------------------------------------------------------------------------------*
* 	              Renaming  and labelling of the variables 
*------------------------------------------------------------------------------*
* label variables 
qui {
rename Budget_1 Bdgt_Admin_T
label var Bdgt_Admin_T "Budget, Total, Administration, in 1000 DK" 
rename Budget_2 Bdgt_Edu_T
label var Bdgt_Edu_T "Budget, Total, Education and culture, in 1000 DK"
rename Budget_3 Bdgt_Health_T
label var Bdgt_Health_T "Budget, Total, Health care activities, in 1000 DK" 
rename Budget_4 Bdgt_HousingAmenities_T 
label var Bdgt_HousingAmenities_T "Budget, Total, Housing and community amenities, in 1000 DK" 
rename Budget_5 Bdgt_Total_T
label var Bdgt_Total_T "Budget, Total, Total, in 1000 DK" 
rename Budget_6 Bdgt_Public_Ut_T
label var Bdgt_Public_Ut_T "Budget, Total, Public utilities, etc., in 1000 DK" 
rename Budget_7 Bdgt_Traffic_T
label var Bdgt_Traffic_T "Budget, Total, Traffic and infrastructure, in 1000 DK" 
} 
*------------------------------------------------------------------------------*
save "./TEMP/Temp1_1", replace 
*------------------------------------------------------------------------------*
import excel "./Data Sources and Panel.xls", sheet("Budget BUD1 Expenditure") firstrow clear 
*---------------------
rename A TypeofBudget
replace TypeofBudget = subinstr(TypeofBudget," ","",.)
rename B FormerMunicipality
replace FormerMunicipality = subinstr(FormerMunicipality," ","",.)
*------------------------------------------------------------------------------*
gen TEMP_ID= _n
reshape long _,i(TEMP_ID) j(year)
*------------------------------------
egen Budget_ID=group(TypeofBudget) 
egen MUN_ID=group(FormerMunicipality)
*------------------------------------
drop TEMP_ID TypeofBudget
*------------------------------------
rename _ Budget_
reshape wide Budget_, i(MUN_ID year) j(Budget_ID) 
drop MUN_ID
*------------------------------------------------------------------------------*
* 	              Renaming  and labelling of the variables 
*------------------------------------------------------------------------------*
* label variables 
qui {
rename Budget_1 Bdgt_Admin_Ex
label var Bdgt_Admin_Ex "Budget, Expenditure, Administration, in 1000 DK" 
rename Budget_2 Bdgt_Edu_Ex
label var Bdgt_Edu_Ex "Budget, Expenditure, Education and culture, in 1000 DK"
rename Budget_3 Bdgt_Health_Ex
label var Bdgt_Health_Ex "Budget, Expenditure, Health care activities, in 1000 DK" 
rename Budget_4 Bdgt_HousingAmenities_Ex 
label var Bdgt_HousingAmenities_Ex "Budget, Expenditure, Housing and community amenities, in 1000 DK" 
rename Budget_5 Bdgt_Total_Ex
label var Bdgt_Total_Ex "Budget, Expenditure, Total, in 1000 DK" 
rename Budget_6 Bdgt_Public_Ut_Ex
label var Bdgt_Public_Ut_Ex "Budget, Expenditure, Public utilities, etc., in 1000 DK" 
rename Budget_7 Bdgt_Traffic_Ex
label var Bdgt_Traffic_Ex "Budget, Expenditure, Traffic and infrastructure, in 1000 DK" 
}
*------------------------------------------------------------------------------*
save "./TEMP/Temp1_2", replace 
*------------------------------------------------------------------------------*
import excel "./Data Sources and Panel.xls", sheet("Budget BUD1 Revenue") firstrow clear 
*---------------------
rename A TypeofBudget
replace TypeofBudget = subinstr(TypeofBudget," ","",.)
rename B FormerMunicipality
replace FormerMunicipality = subinstr(FormerMunicipality," ","",.)
*------------------------------------------------------------------------------*
gen TEMP_ID= _n
reshape long _,i(TEMP_ID) j(year)
*------------------------------------
egen Budget_ID=group(TypeofBudget) 
egen MUN_ID=group(FormerMunicipality)
*------------------------------------
drop TEMP_ID TypeofBudget
*------------------------------------
rename _ Budget_
reshape wide Budget_, i(MUN_ID year) j(Budget_ID) 
drop MUN_ID
*------------------------------------------------------------------------------*
* 	              Renaming  and labelling of the variables 
*------------------------------------------------------------------------------*
* label variables 
qui {
rename Budget_1 Bdgt_Admin_Re
label var Bdgt_Admin_Re "Budget, Revenue, Administration, in 1000 DK" 
rename Budget_2 Bdgt_Edu_Re
label var Bdgt_Edu_Re "Budget, Revenue, Education and culture, in 1000 DK"
rename Budget_3 Bdgt_Health_Re
label var Bdgt_Health_Re "Budget, Revenue, Health care activities, in 1000 DK" 
rename Budget_4 Bdgt_HousingAmenities_Re 
label var Bdgt_HousingAmenities_Re "Budget, Revenue, Housing and community amenities, in 1000 DK" 
rename Budget_5 Bdgt_Total_Re
label var Bdgt_Total_Re "Budget, Revenue, Total, in 1000 DK" 
rename Budget_6 Bdgt_Public_Ut_Re
label var Bdgt_Public_Ut_Re "Budget, Revenue, Public utilities, etc., in 1000 DK" 
rename Budget_7 Bdgt_Traffic_Re
label var Bdgt_Traffic_Re "Budget, Revenue, Traffic and infrastructure, in 1000 DK" 
}
*------------------------------------------------------------------------------*
save "./TEMP/Temp1_3", replace 
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
use  "./TEMP/Temp1_1", clear 
mmerge FormerMunicipality year using "./TEMP/Temp1_2", type(1:1)
mmerge FormerMunicipality year using "./TEMP/Temp1_3", type(1:1)
sort _merge FormerMunicipality year
drop _merge
*------------------------------------------------------------------------------*
qui DataCleaning // execute predefined data cleaning program
save "./TEMP/Temp1", replace 
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
* 							Income Categories  
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
import excel "./Data Sources and Panel.xls", sheet("Income IB811") firstrow clear 
*-----------------------
rename A TypeofIncome
replace TypeofIncome = subinstr(TypeofIncome," ","",.)
rename B FormerMunicipality
replace FormerMunicipality = subinstr(FormerMunicipality," ","",.)
*------------------------------------------------------------------------------*
gen TEMP_ID= _n
reshape long _,i(TEMP_ID) j(year)
*------------------------------------
egen Income_ID=group(TypeofIncome) 
egen MUN_ID=group(FormerMunicipality)
*------------------------------------
drop TEMP_ID TypeofIncome
*------------------------------------
rename _ Income_
reshape wide Income_, i(MUN_ID year) j(Income_ID) 
drop MUN_ID
*------------------------------------------------------------------------------*
*                      Renaming and labelling of the variables				   *
*------------------------------------------------------------------------------*
* label variables 
qui {
rename Income_1 Inc_CrrntTrnsfrs  
label var Inc_CrrntTrnsfrs "Current transfers, etc., total, in 1000 DK"
rename Income_2 Inc_CashBenefits 
label var  Inc_CashBenefits "Cash benefits, in 1000 DK"
rename Income_3 Inc_Pnsns_CivilServant 
label var Inc_Pnsns_CivilServant "Civil servant pensions, in 1000 DK, documented from 2002 onwards"
rename Income_4 Inc_DailyBnfts_Tot
label var Inc_DailyBnfts_Tot "Daily benefits and etc., total, in 1000 DK" 
rename Income_5 Inc_Entrepr_Tot
label var Inc_Entrepr_Tot "Entrepreneurial income, total, in 1000 DK" 
rename Income_6 Inc_EarlyRtrmntPay 
label var Inc_EarlyRtrmntPay "Early retirement pay, in 1000 DK" 
rename Income_7 Inc_EduGrant
label var Inc_EduGrant "Education grants, in 1000 DK" 
rename Income_8 Inc_Entrepr 
label var Inc_Entrepr "Entrepreneurial income, in 1000 DK" 
rename Income_9 Inc_Gratuities 
label var Inc_Gratuities "Gratuities, in 1000 DK" 
rename Income_10 Inc_Dedctn
label var Inc_Dedctn "Income/Deduction, assisting spouse, in 1000 DK" 
rename Income_11 Inc_OtherBnfts
label var Inc_OtherBnfts "Ofther benefits, in 1000 DK" 
rename Income_12 Inc_PnsnsOther 
label var Inc_PnsnsOther "Other pensions, in 1000 DK" 
rename Income_13 Inc_Pnsns_Tot
label var Inc_Pnsns_Tot "Pensions, etc., total, in 1000 DK" 
rename Income_14 Inc_Pers_Tot
label var Inc_Pers_Tot"Personal income, total, in 1000 DK" 
rename Income_15 Inc_Prmry_Tot
label var Inc_Prmry_Tot "Primary income, total, in 1000 DK" 
rename Income_16 Inc_Pnsns_ATP
label var Inc_Pnsns_ATP "Pensions from ATP, in 1000 DK" 
rename Income_17 Inc_Remnrtn
label var Inc_Remnrtn "Remuneration, in 1000 DK" 
rename Income_18 Inc_PnsnsSoc
label var Inc_PnsnsSoc "Social pensions, in 1000 DK" 
rename Income_19 Inc_EarlyRtrmnt
label var Inc_EarlyRtrmnt "Special early retirement pay, in 1000 DK" 
rename Income_20 Inc_Pnsn_Supplmtn
label var Inc_Pnsn_Supplmtn "Supplements to social pensions, in 1000 DK" 
rename Income_21 Inc_TmprlyLeave
label var Inc_TmprlyLeave "Temporarely leave benefits, in 1000 DK" 
rename Income_22 Inc_UnemplymtnBnfts
label var Inc_UnemplymtnBnfts "Unemployment benefits and the like, in 1000 DK" 
rename Income_23 Inc_Wages
label var Inc_Wages "Wages, in 1000 DK" 
rename Income_24 Inc_Wages_Tot
label var Inc_Wages_Tot "Wages and salaries, total, in 1000 DK" 
}
*------------------------------------------------------------------------------*
qui DataCleaning // execute predefined data cleaning program
save "./TEMP/Temp2", replace 
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*					Sectoral Employment - aggregated by place of work 
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
import excel "./Data Sources and Panel.xls", sheet("Employment PEND11") firstrow clear 
*-----------------
rename A industry27grouping
replace industry27grouping = subinstr(industry27grouping," ","",.)
rename B FormerMunicipality
replace FormerMunicipality = subinstr(FormerMunicipality," ","",.)
*-----------------
gen TEMP_ID= _n
reshape long _,i(TEMP_ID) j(year)
rename _ Emp_WP_
*-----------------
egen industry=sieve(industry27grouping), keep(n) 
destring industry, replace
egen MUN_ID=group(FormerMunicipality)
*----------------
drop industry27grouping TEMP_ID P
*----------------
reshape wide Emp_WP_, i(MUN_ID year) j(industry) 
drop MUN_ID
*----------------
* computation of total employment (sum of all sectoral employment categories)
gen Emp_WP_Tot=(Emp_WP_109 + Emp_WP_500 + Emp_WP_1009 + Emp_WP_1509 + Emp_WP_1709 + Emp_WP_2009 + Emp_WP_2309 + Emp_WP_2600 + Emp_WP_2709 + Emp_WP_3600 + Emp_WP_4009 + Emp_WP_4500 + Emp_WP_5000 + Emp_WP_5100 + Emp_WP_5200 + Emp_WP_5500 + Emp_WP_6009 + Emp_WP_6400 + Emp_WP_6509 + Emp_WP_7009 + Emp_WP_7209 + Emp_WP_7500 + Emp_WP_8000 + Emp_WP_8519 + Emp_WP_8539 + Emp_WP_9009 + Emp_WP_9800)
*------------------------------------------------------------------------------*
*						Labelling the variables
*------------------------------------------------------------------------------*
* label variables 
qui {
label variable Emp_WP_Tot "Employment total, aggregated by workplace"
label variable Emp_WP_109 "0109 Agriculture, horticulture and forestry, by workplace"
label variable Emp_WP_500 "0500 Fishing, by workplace"
label variable Emp_WP_1009 "1009 Mining and quarrying, by workplace"
label variable Emp_WP_1509 "1509 Mfr. of food, beverages and tobacco, by workplace"
label variable Emp_WP_1709 "1709 Mfr. of textiles and leather, by workplace"
label variable Emp_WP_2009 "2009 Mfr. of wood products, printing and publ., by workplace"
label variable Emp_WP_2309 "2309 Mfr. of chemicals and plastic products, by workplace"
label variable Emp_WP_2600 "2600 Mfr. of other non-metallic mineral products, by workplace"
label variable Emp_WP_2709 "2709 Mfr. of basic metals and fabr. metal prod., by workplace"
label variable Emp_WP_3600 "3600 Mfr. of furniture; manufacturing n.e.c., by workplace"
label variable Emp_WP_4009 "4009 Electricity, gas and water supply, by workplace"
label variable Emp_WP_4500 "4500 Construction, by workplace"
label variable Emp_WP_5000 "5000 Sale and repair of motor vehicles sale of auto. fuel, by workplace"
label variable Emp_WP_5100 "5100 Wholesale except of motor vehicles, by workplace"
label variable Emp_WP_5200 "5200 Re. trade and repair work exc. of m. vehicles, by workplace"
label variable Emp_WP_5500 "5500 Hotels and restaurants, by workplace"
label variable Emp_WP_6009 "6009 Transport, by workplace"
label variable Emp_WP_6400 "6400 Post and telecommunications, by workplace"
label variable Emp_WP_6509 "6509 Finance and insurance, by workplace"
label variable Emp_WP_7009 "7009 Letting and sale of real estate, by workplace"
label variable Emp_WP_7209 "7209 Business activities, by workplace"
label variable Emp_WP_7500 "7500 Public administration, by workplace"
label variable Emp_WP_8000 "8000 Education, by workplace"
label variable Emp_WP_8519 "8519 Human health activities, by workplace"
label variable Emp_WP_8539 "8539 Social institutions etc., by workplace"
label variable Emp_WP_9009 "9009 Associations, culture and refuse disposal, by workplace"
label variable Emp_WP_9800 "9800 Activity not stated, by workplace"
}
*------------------------------------------------------------------------------*
qui DataCleaning // execute predefined data cleaning program 
save "./TEMP/Temp3", replace 
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*					Sectoral Employment - aggregated by residence  
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
import excel "./Data Sources and Panel.xls", sheet("Employment RASU2") firstrow clear 
*-----------------
rename A industry27grouping
replace industry27grouping = subinstr(industry27grouping," ","",.)
rename B FormerMunicipality
replace FormerMunicipality = subinstr(FormerMunicipality," ","",.)
*-----------------
gen TEMP_ID= _n
reshape long _,i(TEMP_ID) j(year)
rename _ Emp_
*-----------------
egen industry=sieve(industry27grouping), keep(n) 
destring industry, replace
egen MUN_ID=group(FormerMunicipality)
*----------------
drop industry27grouping TEMP_ID
*----------------
reshape wide Emp_, i(MUN_ID year) j(industry) 
drop MUN_ID
*----------------
* computation of total employment 
gen Emp_Tot=(Emp_109 + Emp_500 + Emp_1009 + Emp_1509 + Emp_1709 + Emp_2009 + Emp_2309 + Emp_2600 + Emp_2709 + Emp_3600 + Emp_4009 + Emp_4500 + Emp_5000 + Emp_5100 + Emp_5200 + Emp_5500 + Emp_6009 + Emp_6400 + Emp_6509 + Emp_7009 + Emp_7209 + Emp_7500 + Emp_8000 + Emp_8519 + Emp_8539 + Emp_9009 + Emp_9800)
*------------------------------------------------------------------------------*
*                        Labelling of the variables
*------------------------------------------------------------------------------*
* label variables 
qui {
label variable Emp_Tot "Employment total, aggregated by residence"
label variable Emp_109 "0109 Agriculture, horticulture and forestry, by residence"
label variable Emp_500 "0500 Fishing, by residence"
label variable Emp_1009 "1009 Mining and quarrying, by residence"
label variable Emp_1509 "1509 Mfr. of food, beverages and tobacco, by residence"
label variable Emp_1709 "1709 Mfr. of textiles and leather, by residence"
label variable Emp_2009 "2009 Mfr. of wood products, printing and publ., by residence"
label variable Emp_2309 "2309 Mfr. of chemicals and plastic products, by residence"
label variable Emp_2600 "2600 Mfr. of other non-metallic mineral products, by residence"
label variable Emp_2709 "2709 Mfr. of basic metals and fabr. metal prod., by residence"
label variable Emp_3600 "3600 Mfr. of furniture; manufacturing n.e.c., by residence"
label variable Emp_4009 "4009 Electricity, gas and water supply, by residence"
label variable Emp_4500 "4500 Construction, by residence"
label variable Emp_5000 "5000 Sale and repair of motor vehicles sale of auto. fuel, by residence"
label variable Emp_5100 "5100 Wholesale except of motor vehicles, by residence"
label variable Emp_5200 "5200 Re. trade and repair work exc. of m. vehicles, by residence"
label variable Emp_5500 "5500 Hotels and restaurants, by residence"
label variable Emp_6009 "6009 Transport, by residence"
label variable Emp_6400 "6400 Post and telecommunications, by residence"
label variable Emp_6509 "6509 Finance and insurance, by residence"
label variable Emp_7009 "7009 Letting and sale of real estate, by residence"
label variable Emp_7209 "7209 Business activities, by residence"
label variable Emp_7500 "7500 Public administration, by residence"
label variable Emp_8000 "8000 Education, by residence"
label variable Emp_8519 "8519 Human health activities, by residence"
label variable Emp_8539 "8539 Social institutions etc., by residence"
label variable Emp_9009 "9009 Associations, culture and refuse disposal, by residence"
label variable Emp_9800 "9800 Activity not stated, by residence"
}
*------------------------------------------------------------------------------*
qui DataCleaning // execute predefined data cleaning program 
save "./TEMP/Temp4", replace 
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*					Unemployment - aggregated by municipality of residence 
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
import excel "./Data Sources and Panel.xls", sheet("Unemployment AAR") firstrow clear 
*------------
rename A FormerMunicipality
replace FormerMunicipality = subinstr(FormerMunicipality," ","",.)
*------------
gen TEMP_ID= _n
reshape long _,i(TEMP_ID) j(year)
drop TEMP_ID 
*------------
rename _ Unemplymnt
label var Unemplymnt "Unemployment, aggregated by region" 
*------------------------------------------------------------------------------*
qui DataCleaning // execute predefined data cleaning program 
save "./TEMP/Temp5", replace 
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*					Population - aggregated by municipality of residence 
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
import excel "./Data Sources and Panel.xls", sheet("Population BEF1A") firstrow clear 
*------------
rename A FormerMunicipality
replace FormerMunicipality = subinstr(FormerMunicipality," ","",.)
*------------
gen TEMP_ID= _n
reshape long _,i(TEMP_ID) j(year)
drop TEMP_ID 
*------------
rename _ Population
label var Population "Population, aggregated by region" 
*------------------------------------------------------------------------------*
qui DataCleaning // execute predefined data cleaning program 
save "./TEMP/Temp6", replace 
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
* 					Agricultural Land Surface 
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
* The agricultural land surface in each municipality is computed with two data sets
* We have :
* - data on agricultural land surface at the county level (for 12 counties) for all years ("BDF1" in "Data Sources and Panel")
* - and data on agricultural land surface at the municipal level (for 251 municipalities) for the year 1999 only ("BDF5" in "Data Sources and Panel")
* ----------------------------
* As we do not have the data on agricultural land surface in all municipalities over time, we use the changes in the agricultural land surface at the county level to deduct a proxy for the changes in agricultural land surface in each municipality
*-----------------------------
* The computation is done in three steps: 
* Step 1 : Import, apply edits to municipality names, and join the two data sets  
* Step 2 : The share is calculated as followed: New var named "MUN_share1999" =  municipal agricultural surface ("Agr_Mun1999")/ county agricultural surface in the year 1999 ("_1999")
* New variable (AgrSurface) = multiplication of each municipality's individual share (assumed constant) with the yearly data of agricultural surface at the county level 
* Step 3 : 
*-------------------------------------------------------------------------------
*	Step 1: 	Agricultural area, from census 1999  // BDF5 
*-------------------------------------------------------------------------------
import excel "./Data Sources and Panel.xls", sheet("CountyData") firstrow clear 
save "./TEMP/CountyData",replace
*-------------------------------
import excel "./Data Sources and Panel.xls", sheet("Agricultural Area BDF5") firstrow clear 
*------------
rename B FormerMunicipality
replace FormerMunicipality = subinstr(FormerMunicipality," ","",.)
*------------ 
gen TEMP_ID= _n
reshape long _,i(TEMP_ID) j(year)
drop TEMP_ID  A
*------------
rename _ Agr1999
label var Agr1999  "Total agricultual area on the mun level in hectare from census 1999" 
*------------------------------------------------------------------------------*
* The names of Danish Municipalities include special letters (like ø, å, æ) which are not always well handled by GIS & Excel.
* Depending on the data (source: Statistics Denmark, QGIS/DigDag) the spelling differs and the names hence have to be adjusted manually. 
 qui {
replace FormerMunicipality="BornholmsRegions" if FormerMunicipality=="Bornholm(excl.Christiansø)" 
replace FormerMunicipality="Faxe" if FormerMunicipality=="Fakse"
replace FormerMunicipality="Fåborg" if FormerMunicipality=="Faaborg"
replace FormerMunicipality="Grenå" if FormerMunicipality=="Grenaa"
replace FormerMunicipality="Holmegård" if FormerMunicipality=="Holmegaard"
replace FormerMunicipality="Hårby" if FormerMunicipality=="Haarby"
replace FormerMunicipality="Åbenrå" if FormerMunicipality=="Aabenraa"
replace FormerMunicipality="Åbybro" if FormerMunicipality=="Aabybro"
replace FormerMunicipality="Ålborg" if FormerMunicipality=="Aalborg"
replace FormerMunicipality="Ålestrup" if FormerMunicipality=="Aalestrup"
replace FormerMunicipality="Års" if FormerMunicipality=="Aars"
replace FormerMunicipality="Årup"  if FormerMunicipality=="Aarup"
replace FormerMunicipality="Torslunde-Ishøj" if FormerMunicipality=="Ishøj" 
replace FormerMunicipality="NykøbingFalsters" if FormerMunicipality=="Nykøbing-Falster" 
replace FormerMunicipality="Nørreåby" if FormerMunicipality=="NørreAaby" 
replace FormerMunicipality="Sydlangelands" if FormerMunicipality=="Sydlangeland" 
replace FormerMunicipality="Aakrikreby" if FormerMunicipality=="Aakirkeby(-2002)"
replace FormerMunicipality="Allinge-Gudhjem" if FormerMunicipality=="Allinge-Gudhjem(-2002)"
replace FormerMunicipality="Hasle" if FormerMunicipality=="Hasle(-2002)"
replace FormerMunicipality="Nexø" if FormerMunicipality=="Nexø(-2002)"
replace FormerMunicipality="Rønne" if FormerMunicipality=="Rønne(-2002)"
replace FormerMunicipality="Marstal" if FormerMunicipality=="Marstal(-2005/2006)" 
} 
*-------------------------------------------------------------------------------
* In this step, we identify, for each municipality, the county to which it belongs
mmerge FormerMunicipality using "./TEMP/CountyData", type(1:1) 
drop _merge 
*----------------
egen County_ID=group(County) 
*----------------
qui DataCleaning // execute predefined data cleaning program
save "./TEMP/Temp7",replace
*------------------------------------------------------------------------------*
*			Agricultural area, at the County Level // BDF1 
*------------------------------------------------------------------------------*
import excel "./Data Sources and Panel.xls", sheet("Agricultural Area BDF1") firstrow clear 
*------------
rename B County
replace County="Bornholm County" if County=="Bornholm (excl. Christiansø)"
replace County="Copenhagen County" if County=="Copenhagen region"
drop if County=="All Denmark" 
*------------
joinby County using "./TEMP/Temp7", unmatched(both)
drop _merge A 
*-------------------------------------------------------------------------------
* Step 2 : Calculation of the share of agricultural surface of each municipality in the 
* agricultural surface of the corresponding county
*-------------------------------------------------------------------------------
gen MUN_share1999 = Agr1999/_1999 if year==1999 
label var MUN_share1999 "Share of the municipal agricultural land surface on the total county agricultural land surface in year 1999"
*-----------
foreach VVV in 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 {
gen year`VVV' = (_`VVV'* MUN_share1999) 
drop _`VVV'
rename year`VVV' _`VVV' 
label var _`VVV' "Assumed agricultural land surface in each municipality" 
}
*-----------
drop year 
reshape long _,i(FormerMunicipality) j(year)
rename _ AgrSurface  
label var AgrSurface "Agricultual land area in hectare"
drop Agr1999 MUN_share1999
*-------------------------
save "./TEMP/Temp8", replace 
*-------------------
drop County County_ID
save "./TEMP/Temp9", replace  
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* 				Average wind density (source: Global Wind Atlas & QGIS/DigDag) 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
import excel "./Data Sources and Panel.xls", sheet("WindPowerDensity_50m") firstrow clear 
drop fra til enhedid objectid enhedtype art Gridtype _median SHAPE_Area SHAPE_Leng fid
gen year=2021
rename navn FormerMunicipality
replace FormerMunicipality=subinstr(FormerMunicipality,"Kommune","",.)
replace FormerMunicipality = subinstr(FormerMunicipality," ","",.)
rename _mean AVG_WindDensity 
label var AVG_WindDensity "Average Wind Density in 50 meters hight and in W/m²"
*-------------------------
* The names of Danish Municipalities include special letters (like ø, å, æ) which are not always well handled by QGIS, Stata & Excel.
* Depending on the data (source: Statistics Denmark, QGIS/DigDag) the spelling differs and the names hence have to be adjusted manually. 

qui {
replace FormerMunicipality="Allerød" if FormerMunicipality=="AllerÃƒÂ¸d" 
replace FormerMunicipality="Albertslund" if FormerMunicipality=="Herstederne" 
replace FormerMunicipality="Blåbjerg" if FormerMunicipality=="BlÃƒÂ¥bjerg"
replace FormerMunicipality="Blåvandshuk" if FormerMunicipality=="BlÃƒÂ¥vandshuk"
replace FormerMunicipality="Bramsnæs" if  FormerMunicipality=="BramsnÃƒÂ¦s"
replace FormerMunicipality="Brædstrup" if  FormerMunicipality=="BrÃƒÂ¦dstrup"
replace FormerMunicipality="Brønderslev" if  FormerMunicipality=="BrÃƒÂ¸nderslev"
replace FormerMunicipality="Brørup" if  FormerMunicipality=="BrÃƒÂ¸rup"
replace FormerMunicipality="Børkop" if FormerMunicipality=="BÃƒÂ¸rkop"
replace FormerMunicipality="Ballerup" if FormerMunicipality == "Ballerup-MÃƒÂ¥lÃƒÂ¸v"

replace FormerMunicipality="Brøndby" if FormerMunicipality=="BrÃƒÂ¸ndbyÃƒÂ¸ster-BrÃƒÂ¸ndbyvester" 
replace FormerMunicipality="Birkerød" if FormerMunicipality=="BirkerÃƒÂ¸d" 
replace  FormerMunicipality="Nexø" if FormerMunicipality =="BornholmsRegionskommune"
replace FormerMunicipality ="Christiansø" if FormerMunicipality=="ChristiansÃƒÂ¸" 
replace FormerMunicipality="Copenhagen" if  FormerMunicipality=="KÃƒÂ¸benhavns"

replace FormerMunicipality="Dragør" if  FormerMunicipality=="DragÃƒÂ¸r"
replace FormerMunicipality="Fanø" if  FormerMunicipality=="FanÃƒÂ¸" 
replace FormerMunicipality="Farsø" if  FormerMunicipality=="FarsÃƒÂ¸" 
replace FormerMunicipality="Fladså" if  FormerMunicipality=="FladsÃƒÂ¥"
replace FormerMunicipality="Frederiksværk" if  FormerMunicipality=="FrederiksvÃƒÂ¦rk"
replace FormerMunicipality="Fåborg" if FormerMunicipality=="FÃƒÂ¥borg"
replace FormerMunicipality="Fredensborg-Humlebæk" if FormerMunicipality=="Fredensborg-HumlebÃƒÂ¦k" 

replace FormerMunicipality="Grenå" if   FormerMunicipality=="GrenÃƒÂ¥"
replace FormerMunicipality="Gråsten" if   FormerMunicipality=="GrÃƒÂ¥sten"
replace FormerMunicipality="Gundsø" if  FormerMunicipality=="GundsÃƒÂ¸"
replace FormerMunicipality="Gørlev" if  FormerMunicipality=="GÃƒÂ¸rlev"
replace FormerMunicipality="Græsted-Gilleleje" if FormerMunicipality =="GrÃƒÂ¦sted-Gilleleje"

replace FormerMunicipality="Hashøj" if   FormerMunicipality=="HashÃƒÂ¸j"
replace FormerMunicipality="Helsingør" if FormerMunicipality=="HelsingÃƒÂ¸r"
replace FormerMunicipality="Hillerød" if   FormerMunicipality=="HillerÃƒÂ¸d"
replace FormerMunicipality="Hjørring" if  FormerMunicipality=="HjÃƒÂ¸rring"
replace FormerMunicipality="Holbæk" if  FormerMunicipality=="HolbÃƒÂ¦k"
replace FormerMunicipality="Holmegård" if  FormerMunicipality=="HolmegÃƒÂ¥rd"
replace FormerMunicipality="Hvalsø" if  FormerMunicipality=="HvalsÃƒÂ¸"
replace FormerMunicipality="Hvidebæk" if  FormerMunicipality=="HvidebÃƒÂ¦k"
replace FormerMunicipality="Hårby" if  FormerMunicipality=="HÃƒÂ¥rby"
replace FormerMunicipality="HøjeTaastrup" if  FormerMunicipality=="HÃƒÂ¸jeTaastrup"
replace FormerMunicipality="Højer" if  FormerMunicipality=="HÃƒÂ¸jer"
replace FormerMunicipality="Højreby" if  FormerMunicipality=="HÃƒÂ¸jreby"
replace FormerMunicipality="Høng" if  FormerMunicipality=="HÃƒÂ¸ng"
replace FormerMunicipality="Hørning" if FormerMunicipality=="HÃƒÂ¸rning"
replace FormerMunicipality="Hørsholm" if FormerMunicipality=="HÃƒÂ¸rsholm" 

replace FormerMunicipality="Jernløse" if  FormerMunicipality=="JernlÃƒÂ¸se"
replace FormerMunicipality="Jægerspris" if  FormerMunicipality=="JÃƒÂ¦gerspris"
replace FormerMunicipality="Korsør" if FormerMunicipality=="KorsÃƒÂ¸r"
replace FormerMunicipality="Køge" if  FormerMunicipality=="KÃƒÂ¸ge"

replace FormerMunicipality="Langebæk" if FormerMunicipality=="LangebÃƒÂ¦k"
replace FormerMunicipality="Langå" if FormerMunicipality=="LangÃƒÂ¥"
replace FormerMunicipality="Ledøje-Smørum" if  FormerMunicipality=="LedÃƒÂ¸je-SmÃƒÂ¸rum"
replace FormerMunicipality="Læsø" if  FormerMunicipality=="LÃƒÂ¦sÃƒÂ¸"
replace FormerMunicipality="Løgstør" if  FormerMunicipality=="LÃƒÂ¸gstÃƒÂ¸r"
replace FormerMunicipality="Løgumkloster" if  FormerMunicipality=="LÃƒÂ¸gumkloster"
replace FormerMunicipality="Løkken-Vrå" if  FormerMunicipality=="LÃƒÂ¸kken-VrÃƒÂ¥"
replace FormerMunicipality="Lyngby-Taarbæk" if FormerMunicipality =="Lyngby-TÃƒÂ¥rbÃƒÂ¦k" 
replace FormerMunicipality="Morsø" if FormerMunicipality=="MorsÃƒÂ¸"

replace FormerMunicipality="Møldrup" if FormerMunicipality=="MÃƒÂ¸ldrup"
replace FormerMunicipality="Møn" if FormerMunicipality=="MÃƒÂ¸n"
replace FormerMunicipality="Nykøbing-Rørvig" if FormerMunicipality=="NykÃƒÂ¸bing-RÃƒÂ¸rvig" 
replace FormerMunicipality="NykøbingFalsters" if FormerMunicipality=="NykÃƒÂ¸bingFalsters"
replace FormerMunicipality="Næstved" if  FormerMunicipality=="NÃƒÂ¦stved"
replace FormerMunicipality="Nørager" if  FormerMunicipality=="NÃƒÂ¸rager"
replace FormerMunicipality="Nørhald" if FormerMunicipality=="NÃƒÂ¸rhald"
replace FormerMunicipality="NørreAlslev" if  FormerMunicipality=="NÃƒÂ¸rreAlslev"
replace FormerMunicipality="NørreDjurs" if  FormerMunicipality=="NÃƒÂ¸rreDjurs"
replace FormerMunicipality="NørreRangstrup" if  FormerMunicipality=="NÃƒÂ¸rreRangstrup"
replace FormerMunicipality="NørreSnede" if FormerMunicipality=="NÃƒÂ¸rreSnede"
replace FormerMunicipality="Nørreåby" if   FormerMunicipality=="NÃƒÂ¸rreÃƒâ€¦by"
replace FormerMunicipality="Præstø" if  FormerMunicipality=="PrÃƒÂ¦stÃƒÂ¸"
replace FormerMunicipality="Ramsø" if  FormerMunicipality=="RamsÃƒÂ¸"
replace FormerMunicipality="Ringkøbing" if FormerMunicipality=="RingkÃƒÂ¸bing"
replace FormerMunicipality="Rougsø" if FormerMunicipality=="RougsÃƒÂ¸"
replace FormerMunicipality="Rudkøbing" if  FormerMunicipality=="RudkÃƒÂ¸bing"
replace FormerMunicipality="Rødby" if  FormerMunicipality=="RÃƒÂ¸dby"
replace FormerMunicipality="Rødding" if FormerMunicipality=="RÃƒÂ¸dding"
replace FormerMunicipality="Rødekro" if  FormerMunicipality=="RÃƒÂ¸dekro"
replace FormerMunicipality="Rønde" if  FormerMunicipality=="RÃƒÂ¸nde"
replace FormerMunicipality="Rønnede" if  FormerMunicipality=="RÃƒÂ¸nnede"
replace FormerMunicipality="Rødovre" if  FormerMunicipality=="RÃƒÂ¸dovre"

replace FormerMunicipality="Sakskøbing" if  FormerMunicipality=="SakskÃƒÂ¸bing"
replace FormerMunicipality="Samsø" if  FormerMunicipality=="SamsÃƒÂ¸"
replace FormerMunicipality="Skælskør" if  FormerMunicipality=="SkÃƒÂ¦lskÃƒÂ¸r"
replace FormerMunicipality="Skærbæk" if  FormerMunicipality=="SkÃƒÂ¦rbÃƒÂ¦k"
replace FormerMunicipality="Skævinge" if  FormerMunicipality=="SkÃƒÂ¦vinge"
replace FormerMunicipality="Skørping" if  FormerMunicipality=="SkÃƒÂ¸rping"
replace FormerMunicipality="Solrød" if FormerMunicipality=="SolrÃƒÂ¸d"
replace FormerMunicipality="Sorø" if  FormerMunicipality=="SorÃƒÂ¸"
replace FormerMunicipality="Spøttrup" if FormerMunicipality=="SpÃƒÂ¸ttrup"
replace FormerMunicipality="Stenløse" if  FormerMunicipality=="StenlÃƒÂ¸se"
replace FormerMunicipality="Stubbekøbing" if FormerMunicipality=="StubbekÃƒÂ¸bing"
replace FormerMunicipality="Støvring" if  FormerMunicipality=="StÃƒÂ¸vring"
replace FormerMunicipality="Sundsøre" if  FormerMunicipality=="SundsÃƒÂ¸re"
replace FormerMunicipality="Suså" if  FormerMunicipality=="SusÃƒÂ¥"
replace FormerMunicipality="Sæby" if FormerMunicipality=="SÃƒÂ¦by"
replace FormerMunicipality="Sønderhald" if  FormerMunicipality=="SÃƒÂ¸nderhald"
replace FormerMunicipality="Søndersø" if  FormerMunicipality=="SÃƒÂ¸ndersÃƒÂ¸"
replace FormerMunicipality="Sønderborg" if FormerMunicipality== "SÃƒÂ¸nderborg"
replace FormerMunicipality="Søllerød" if FormerMunicipality=="SÃƒÂ¸llerÃƒÂ¸d" 

replace FormerMunicipality="Thyborøn-Harboøre" if  FormerMunicipality=="ThyborÃƒÂ¸n-HarboÃƒÂ¸re"
replace FormerMunicipality="Tårnby" if FormerMunicipality == "TÃƒÂ¥rnby"
replace FormerMunicipality="Torslunde-Ishøj" if  FormerMunicipality=="Torslunde-IshÃƒÂ¸j"
replace FormerMunicipality="Tranekær" if  FormerMunicipality=="TranekÃƒÂ¦r"
replace FormerMunicipality="Trehøje" if   FormerMunicipality=="TrehÃƒÂ¸je"
replace FormerMunicipality="Tølløse" if  FormerMunicipality=="TÃƒÂ¸llÃƒÂ¸se"
replace FormerMunicipality="Tønder" if FormerMunicipality=="TÃƒÂ¸nder"
replace FormerMunicipality="Tørring-Uldum" if  FormerMunicipality=="TÃƒÂ¸rring-Uldum"
replace FormerMunicipality="Vallø" if  FormerMunicipality=="VallÃƒÂ¸"
replace FormerMunicipality="Videbæk" if  FormerMunicipality=="VidebÃƒÂ¦k"
replace FormerMunicipality="Værløse" if FormerMunicipality == "VÃƒÂ¦rlÃƒÂ¸se"
replace FormerMunicipality="Vallensbæk" if FormerMunicipality=="VallensbÃƒÂ¦k" 

replace FormerMunicipality="Åbenrå" if  FormerMunicipality=="Ãƒâ€¦benrÃƒÂ¥"
replace FormerMunicipality="Åbybro" if  FormerMunicipality=="Ãƒâ€¦bybro"
replace FormerMunicipality="Ålborg" if  FormerMunicipality=="Ãƒâ€¦lborg"
replace FormerMunicipality="Ålestrup" if  FormerMunicipality=="Ãƒâ€¦lestrup"
replace FormerMunicipality="Århus" if  FormerMunicipality=="Ãƒâ€¦rhus"
replace FormerMunicipality="Års" if   FormerMunicipality=="Ãƒâ€¦rs"
replace FormerMunicipality="Årslev" if  FormerMunicipality=="Ãƒâ€¦rslev"
replace FormerMunicipality="Årup" if  FormerMunicipality=="Ãƒâ€¦rup"
replace FormerMunicipality="Åskov" if FormerMunicipality=="Ãƒâ€¦skov"
replace FormerMunicipality="Ærøskøbing(-2005/2006)" if  FormerMunicipality=="Ãƒâ€ rÃƒÂ¸skÃƒÂ¸bing"

replace FormerMunicipality="Ølgod" if FormerMunicipality=="ÃƒËœlgod"
replace FormerMunicipality="Ølstykke" if FormerMunicipality=="ÃƒËœlstykke"
replace FormerMunicipality="Ørbæk" if  FormerMunicipality=="ÃƒËœrbÃƒÂ¦k"
}
*-----------------------------
save "./TEMP/Temp11", replace 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* 			           Electricty Price Computation 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
import excel "./Data Sources and Panel.xls", sheet("ElecPrice1985_2001") firstrow clear 
gen Price_West=ElecPrice
gen Price_East=ElecPrice  
drop ElecPrice 
drop if year==2000
drop if year==2001 
* conversion from Ore/kwh into  Eurocents/kwh, with conversion rate of 7.46038 
replace Price_West=Price_West/(7.46038)
replace Price_East=Price_East/(7.46038)
save "./TEMP/Temp12", replace 
*-------------------------------------------------------------------------------
import excel "./Data Sources and Panel.xls", sheet("ElspotPrice2000_2010") firstrow clear 
rename WestDenmark ElecPrice_West 
rename EastDenmark ElecPrice_East 
drop UnitofElspotPriceisDKK_MWh F G
*----------------------------
save "./TEMP/Temp13", replace 
*-----------------------------
import excel "./Data Sources and Panel.xls", sheet("WindPowerProd2000_2010") firstrow clear 
rename A Year 
rename B HourOfDay 
rename WestDenmarkWindpowerproduct Prod_West 
rename EastDenmarkWindpowerproduct Prod_East 
drop UnitofproductionisinMWh_h F 
*-----------------------------
mmerge Year HourOfDay using "./TEMP/Temp13", type(1:1) 
drop _merge
*-----------------------------
gen year = yofd(Year)
drop Year
* The data on Eastern and Western electricty prices are available from January, 1st 2000 for the West part of the grid but from October, 1st 2000 for the East area. For this reason, for the time period between January, 1st to September, 30th 2000 we use the Western price as a proxy for the Eastern price
replace ElecPrice_East=ElecPrice_West if ElecPrice_East==. 
save "./TEMP/Temp14", replace 
*----------------------------
collapse(sum) Prod_West Prod_East, by(year) // computation of the sum of the yearly production 
rename Prod_West WestSUM 
rename Prod_East EastSUM 
save "./TEMP/Temp15", replace 
*-------------------------
use "./TEMP/Temp14", clear 
mmerge year using "./TEMP/Temp15", type(n:1) 
drop _merge 
*-------------------------
gen Price_West=0
replace Price_West=(ElecPrice_West*Prod_West)/WestSUM 
gen Price_East=0 
replace Price_East=(ElecPrice_East*Prod_East)/EastSUM
*-------------------------
collapse(sum) Price_West Price_East , by(year) 
* Conversion from DK/mWh to Euro/kWh -------------------------------------------
* Reminder: the production is in mWh and the price is in DK per mWh 
* Reminder: the conversion rate from DK to Euro is set to 7.46038
* I convert it into Euro. The next step of conversion into kWh per Eurocents is done in a following step. 
replace Price_West=Price_West/(7.46038) 
replace Price_East=Price_East/(7.46038) 
* Conversion from mWh to kWh  
replace Price_West=Price_West/1000	
replace Price_East=Price_East/1000
*------------------------
* Conversion from Euro/kWh to Eurocents/kwh 
replace Price_West=Price_West*100
replace Price_East=Price_East*100 
*------------------------
append using "./TEMP/Temp12" 
sort year
*------------------------
save "./TEMP/Temp16", replace 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* 						Electricity Support Policies 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* data set that contains the elec price from 1985-2010
use "./TEMP/Temp16", clear  
*--------------------------
* The computation of the electricity support policies is based on the English document "The history of Danish support for wind power ", later complemented by elements found in the original Danish version:
drop  Price_West
rename Price_East ElecPrice
* Text: From 1984 to 2001, the Danish support for production from wind turbines was based on an electricity price which was 85% of the local retail price of electricity excluding taxes (price set by the government). 
gen ElecSupport= (0.85*ElecPrice) if inrange((year),1984,1990)
* In 1991 a price premium of 3.6 cEuro/kWh was introduced, which was in place until 2001. 
replace ElecSupport= (0.85*ElecPrice)+3.6 if inrange((year),1991,1999)
* Text: Production from wind turbines connected to the grid from 2000 to 2002 is sold in the market 
* [...] and producers receive a fixed feed in tarif of 5.8cEuro/kWh [...]  and a price premium of 0.3cEuro/kWh is paid to cover balancing costs 
replace ElecSupport=6.1 if inrange((year),2000,2002)
* Text: For wind turines connected to the grid in 2003 or 2004, the producers [...] and receive a price premium of max 1.3 cEuro/kWh until the turbine is 20 years old. The sum of the market price and price premium is limited to maximum 4.8cEuro/kWh and producers recieve a price premium of 0.3cEuro/kWh to cover balancing costs 
replace ElecSupport=((ElecPrice)+1.6) if inrange((year),2003,2004)
replace ElecSupport=5.1 if inrange((year),2003,2004) & ElecSupport>5.1
*--------------------------------
keep if inrange((year),1990,2006)
drop ElecPrice
*--------------------------------
save "./TEMP/ElecSupport", replace 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* 		     GIS municipal data on electricity grid (West or East Denmark)
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
import excel "./Data Sources and Panel.xls", sheet("Kommune_and_Gridtype") firstrow clear 
*-------------------------------------------
collapse(mean) Gridtype, by (FormerMunicipality)
save "./TEMP/Temp17", replace 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* 			Turbine Data computation & Amount of operating wind turbines 
*	      (source : EnergiStyrelsen, The Danish Energy Agency & QGIS/DigDag) 
*-------------------------------------------------------------------------------
*------------------------------------------------------------------------------
import excel "./Data Sources and Panel.xls", sheet("Turbine_Master_Data_GIS") firstrow clear 
* data cleaning
drop  X_UTM32Eur Y_UTM32Eur // the coordinates were important for the GIS-Matching, but are not needed anymore  
* drop of false GIS matches (turbines that were not matched with a municipality due to incorrect X-Y coordinates) 
drop if navn =="false" 
drop if navn =="water"
drop if navn =="not defined "
*-----------------------------
rename navn FormerMunicipality
replace FormerMunicipality=subinstr(FormerMunicipality,"Kommune","",.)
replace FormerMunicipality = subinstr(FormerMunicipality," ","",.)
*------------------------------------------
gen CommissionDate= date(Commission, "DMY")
drop Commission
gen Commission = yofd(CommissionDate)
drop CommissionDate
*------------------------------------------
gen DecommissionDate= date(Decommission, "MDY")
drop Decommission
gen Decommission = yofd(DecommissionDate)
drop DecommissionDate
*------------------------------------------
order FormerMunicipality Commission  Decommission 
*------------------------------------------
gen TEMP_ID=_n 
gen Turbine_ID=_n
reshape long _, i(TEMP_ID) j(year)
drop TEMP_ID 
rename _ ElectricityProduced
label var ElectricityProduced "in kilowatthour" 
*-------------------------------------------------------------------------------
* The names of Danish Municipalities include special letters (like ø, å, æ) which are not always well handled by GIS & Excel. 
* Depending on the data (source: Statistics Denmark, QGIS/DigDag) the spelling differs and the names hence have to be adjusted manually. 
qui { 
replace  FormerMunicipality="Allerød" if FormerMunicipality =="AllerÃƒÂ¸d"
replace  FormerMunicipality="Blåbjerg" if FormerMunicipality =="BlÃƒÂ¥bjerg"
replace  FormerMunicipality="Blåvandshuk" if FormerMunicipality =="BlÃƒÂ¥vandshuk"
replace  FormerMunicipality="Nexø" if FormerMunicipality =="BornholmsRegionskommune"
replace  FormerMunicipality="Bramsnæs" if FormerMunicipality =="BramsnÃƒÂ¦s"
replace  FormerMunicipality="Brædstrup" if FormerMunicipality =="BrÃƒÂ¦dstrup"
replace  FormerMunicipality="Brønderslev" if FormerMunicipality =="BrÃƒÂ¸nderslev"
replace  FormerMunicipality="Brørup" if FormerMunicipality =="BrÃƒÂ¸rup"
replace  FormerMunicipality="Børkop" if FormerMunicipality =="BÃƒÂ¸rkop"
replace  FormerMunicipality="Copenhagen" if FormerMunicipality =="KÃƒÂ¸benhavns"
replace  FormerMunicipality="Dragør" if FormerMunicipality =="DragÃƒÂ¸r"
replace  FormerMunicipality="Fanø" if FormerMunicipality =="FanÃƒÂ¸"
replace  FormerMunicipality="Farsø" if FormerMunicipality =="FarsÃƒÂ¸"
replace  FormerMunicipality="Fladså" if FormerMunicipality =="FladsÃƒÂ¥"
replace  FormerMunicipality="Frederiksværk" if FormerMunicipality =="FrederiksvÃƒÂ¦rk"
replace  FormerMunicipality="Fåborg" if FormerMunicipality =="FÃƒÂ¥borg"
replace  FormerMunicipality="Grenå" if FormerMunicipality =="GrenÃƒÂ¥"
replace  FormerMunicipality="Gråsten" if FormerMunicipality =="GrÃƒÂ¥sten"
replace  FormerMunicipality="Græsted-Gilleleje" if FormerMunicipality =="GrÃƒÂ¦sted-Gilleleje"
replace  FormerMunicipality="Gundsø" if FormerMunicipality =="GundsÃƒÂ¸"
replace  FormerMunicipality="Gørlev" if FormerMunicipality =="GÃƒÂ¸rlev"
replace  FormerMunicipality="Hashøj" if FormerMunicipality =="HashÃƒÂ¸j"
replace  FormerMunicipality="Helsingør" if FormerMunicipality =="HelsingÃƒÂ¸r"
replace  FormerMunicipality="Hillerød" if FormerMunicipality =="HillerÃƒÂ¸d"
replace  FormerMunicipality="Hjørring" if FormerMunicipality =="HjÃƒÂ¸rring"
replace  FormerMunicipality="Holbæk" if FormerMunicipality =="HolbÃƒÂ¦k"
replace  FormerMunicipality="Holmegård" if FormerMunicipality =="HolmegÃƒÂ¥rd"
replace  FormerMunicipality="Hvalsø" if FormerMunicipality =="HvalsÃƒÂ¸"
replace  FormerMunicipality="Hvidebæk" if FormerMunicipality =="HvidebÃƒÂ¦k"
replace  FormerMunicipality="Hårby" if FormerMunicipality =="HÃƒÂ¥rby"
replace  FormerMunicipality="Højer" if FormerMunicipality =="HÃƒÂ¸jer"
replace  FormerMunicipality="Højreby" if FormerMunicipality =="HÃƒÂ¸jreby"
replace  FormerMunicipality="Høng" if FormerMunicipality =="HÃƒÂ¸ng"
replace  FormerMunicipality="Hørning" if FormerMunicipality =="HÃƒÂ¸rning"
replace  FormerMunicipality="Jernløse" if FormerMunicipality =="JernlÃƒÂ¸se"
replace  FormerMunicipality="Jægerspris" if FormerMunicipality =="JÃƒÂ¦gerspris"
replace  FormerMunicipality="Korsør" if FormerMunicipality =="KorsÃƒÂ¸r"
replace  FormerMunicipality="Køge" if FormerMunicipality =="KÃƒÂ¸ge"
replace  FormerMunicipality="Langebæk" if FormerMunicipality =="LangebÃƒÂ¦k"
replace  FormerMunicipality="Langå" if FormerMunicipality =="LangÃƒÂ¥"
replace  FormerMunicipality="Læsø" if FormerMunicipality =="LÃƒÂ¦sÃƒÂ¸"
replace  FormerMunicipality="Løgstør" if FormerMunicipality =="LÃƒÂ¸gstÃƒÂ¸r"
replace  FormerMunicipality="Løgumkloster" if FormerMunicipality =="LÃƒÂ¸gumkloster"
replace  FormerMunicipality="Løkken-Vrå" if FormerMunicipality =="LÃƒÂ¸kken-VrÃƒÂ¥"
replace  FormerMunicipality="Morsø" if FormerMunicipality =="MorsÃƒÂ¸"
replace  FormerMunicipality="Møldrup" if FormerMunicipality =="MÃƒÂ¸ldrup"
replace  FormerMunicipality="Møn" if FormerMunicipality =="MÃƒÂ¸n"
replace  FormerMunicipality="Nykøbing-Rørvig" if FormerMunicipality =="NykÃƒÂ¸bing-RÃƒÂ¸rvig"
replace  FormerMunicipality="NykøbingFalsters" if FormerMunicipality =="NykÃƒÂ¸bingFalsters"
replace  FormerMunicipality="Næstved" if FormerMunicipality =="NÃƒÂ¦stved"
replace  FormerMunicipality="Nørager" if FormerMunicipality =="NÃƒÂ¸rager"
replace  FormerMunicipality="Nørhald" if FormerMunicipality =="NÃƒÂ¸rhald"
replace  FormerMunicipality="NørreAlslev" if FormerMunicipality =="NÃƒÂ¸rreAlslev"
replace  FormerMunicipality="NørreDjurs" if FormerMunicipality =="NÃƒÂ¸rreDjurs"
replace  FormerMunicipality="NørreRangstrup" if FormerMunicipality =="NÃƒÂ¸rreRangstrup"
replace  FormerMunicipality="NørreSnede" if FormerMunicipality =="NÃƒÂ¸rreSnede"
replace  FormerMunicipality="Nørreåby" if FormerMunicipality =="NÃƒÂ¸rreÃƒâ€¦by"
replace  FormerMunicipality="Præstø" if FormerMunicipality =="PrÃƒÂ¦stÃƒÂ¸"
replace  FormerMunicipality="Ramsø" if FormerMunicipality =="RamsÃƒÂ¸"
replace  FormerMunicipality="Ringkøbing" if FormerMunicipality =="RingkÃƒÂ¸bing"
replace  FormerMunicipality="Rougsø" if FormerMunicipality =="RougsÃƒÂ¸"
replace  FormerMunicipality="Rudkøbing" if FormerMunicipality =="RudkÃƒÂ¸bing"
replace  FormerMunicipality="Rødby" if FormerMunicipality =="RÃƒÂ¸dby"
replace  FormerMunicipality="Rødding" if FormerMunicipality =="RÃƒÂ¸dding"
replace  FormerMunicipality="Rødekro" if FormerMunicipality =="RÃƒÂ¸dekro"
replace  FormerMunicipality="Rønde" if FormerMunicipality =="RÃƒÂ¸nde"
replace  FormerMunicipality="Rønnede" if FormerMunicipality =="RÃƒÂ¸nnede"
replace  FormerMunicipality="Sakskøbing" if FormerMunicipality =="SakskÃƒÂ¸bing"
replace  FormerMunicipality="Samsø" if FormerMunicipality =="SamsÃƒÂ¸"
replace  FormerMunicipality="Skælskør" if FormerMunicipality =="SkÃƒÂ¦lskÃƒÂ¸r"
replace  FormerMunicipality="Skærbæk" if FormerMunicipality =="SkÃƒÂ¦rbÃƒÂ¦k"
replace  FormerMunicipality="Skævinge" if FormerMunicipality =="SkÃƒÂ¦vinge"
replace  FormerMunicipality="Skørping" if FormerMunicipality =="SkÃƒÂ¸rping"
replace  FormerMunicipality="Solrød" if FormerMunicipality =="SolrÃƒÂ¸d"
replace  FormerMunicipality="Sorø" if FormerMunicipality =="SorÃƒÂ¸"
replace  FormerMunicipality="Spøttrup" if FormerMunicipality =="SpÃƒÂ¸ttrup"
replace  FormerMunicipality="Stenløse" if FormerMunicipality =="StenlÃƒÂ¸se"
replace  FormerMunicipality="Stubbekøbing" if FormerMunicipality =="StubbekÃƒÂ¸bing"
replace  FormerMunicipality="Støvring" if FormerMunicipality =="StÃƒÂ¸vring"
replace  FormerMunicipality="Sundsøre" if FormerMunicipality =="SundsÃƒÂ¸re"
replace  FormerMunicipality="Suså" if FormerMunicipality =="SusÃƒÂ¥"
replace  FormerMunicipality="Sæby" if FormerMunicipality =="SÃƒÂ¦by"
replace  FormerMunicipality="Sønderhald" if FormerMunicipality =="SÃƒÂ¸nderhald"
replace  FormerMunicipality="Søndersø" if FormerMunicipality =="SÃƒÂ¸ndersÃƒÂ¸"
replace  FormerMunicipality="Thyborøn-Harboøre" if FormerMunicipality =="ThyborÃƒÂ¸n-HarboÃƒÂ¸re"
replace  FormerMunicipality="Tranekær" if FormerMunicipality =="TranekÃƒÂ¦r"
replace  FormerMunicipality="Trehøje" if FormerMunicipality =="TrehÃƒÂ¸je"
replace  FormerMunicipality="Tølløse" if FormerMunicipality =="TÃƒÂ¸llÃƒÂ¸se"
replace  FormerMunicipality="Tønder" if FormerMunicipality =="TÃƒÂ¸nder"
replace  FormerMunicipality="Tørring-Uldum" if FormerMunicipality =="TÃƒÂ¸rring-Uldum"
replace  FormerMunicipality="Vallø" if FormerMunicipality =="VallÃƒÂ¸"
replace  FormerMunicipality="Videbæk" if FormerMunicipality =="VidebÃƒÂ¦k"
replace  FormerMunicipality="Ølgod" if FormerMunicipality =="ÃƒËœlgod"
replace  FormerMunicipality="Ølstykke" if FormerMunicipality =="ÃƒËœlstykke"
replace  FormerMunicipality="Ørbæk" if FormerMunicipality =="ÃƒËœrbÃƒÂ¦k"
replace  FormerMunicipality="Ærøskøbing(-2005/2006)" if FormerMunicipality =="Ãƒâ€ rÃƒÂ¸skÃƒÂ¸bing"
replace  FormerMunicipality="Åbenrå" if FormerMunicipality =="Ãƒâ€¦benrÃƒÂ¥"
replace  FormerMunicipality="Åbybro" if FormerMunicipality =="Ãƒâ€¦bybro"
replace  FormerMunicipality="Ålborg" if FormerMunicipality =="Ãƒâ€¦lborg"
replace  FormerMunicipality="Ålestrup" if FormerMunicipality =="Ãƒâ€¦lestrup"
replace  FormerMunicipality="Århus" if FormerMunicipality =="Ãƒâ€¦rhus"
replace  FormerMunicipality="Års" if FormerMunicipality =="Ãƒâ€¦rs"
replace  FormerMunicipality="Årslev" if FormerMunicipality =="Ãƒâ€¦rslev"
replace  FormerMunicipality="Årup" if FormerMunicipality =="Ãƒâ€¦rup"
replace  FormerMunicipality="Åskov" if FormerMunicipality =="Ãƒâ€¦skov"

replace  FormerMunicipality="Torslunde-Ishøj" if FormerMunicipality =="Torslunde-IshÃƒÂ¸j"
replace  FormerMunicipality="Ledøje-Smørum" if FormerMunicipality =="LedÃƒÂ¸je-SmÃƒÂ¸rum"
replace  FormerMunicipality="HøjeTaastrup" if FormerMunicipality =="HÃƒÂ¸jeTaastrup"
}
*-------------------------------------------------------------------------------
mmerge year using "./TEMP/Temp16", type(n:1)
mmerge FormerMunicipality using "./TEMP/Temp17", type(n:1)
save "./TEMP/TurbineMaster", replace
drop if _merge==2 // the municipalities without wind turbines (_merge==2) are dropped 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*						Revenue Computation 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
gen ElecRev_West=0
gen ElecRev_East=0
*-------------------
sort Turbine_ID year 
*---------------------------------
* Support before electricity market liberalisation: 85 % of the local retail price plus a price premium of 3.6 until the end of 2000 
*---------------------------------
// WEST //
replace ElecRev_West=(Price_West*0.85+3.6)*ElectricityProduced if inrange((Commission),1991,1999) & inrange((year),1991,2000) & Gridtype==2
// EAST // 
replace ElecRev_East=(Price_East*0.85+3.6)*ElectricityProduced if inrange((Commission),1991,1999) & inrange((year),1991,2000) & Gridtype==1
*---------------------------------
* Support after electricuty market liberalisation:
*---------------------------------
* Production from wind turbines connected to the grid from 2000 to 2002 is sold in the market 
* [...] and producers receive a fixed feed in tarif of 5.8cEuro/kWh for 22.000 FLH on land or sea
* After the first period, the producer must sell the power in the market and receives a price premium of maximum 1.3cEuro/kWh until the turbine is 20 years old. 
* Plus a price premium of 0.3cEuro/kWh to cover for balancing costs  
*-------------------------------------------------------------------------------
// WEST //
replace ElecRev_West=(6.1)*ElectricityProduced if  inrange((Commission),2000,2002)  & Gridtype==2
// EAST // 
replace ElecRev_East=(6.1)*ElectricityProduced if  inrange((Commission),2000,2002)  & Gridtype==1 
*-------------------------------------------------------------------------------
gen Elec_Rev=0 
replace Elec_Rev=ElecRev_West if ElecRev_East==0
replace Elec_Rev=ElecRev_East if ElecRev_West==0 
*-------------------------------------------------------------------------------
* We define the revenues as new revenues in the year of commission 
gen New_Rev=0 
replace New_Rev= Elec_Rev if Commission==year 
label var New_Rev "New revenues from commissioned wind turbines, in eurocents"
* conversion from Eurocents to Euro 
replace New_Rev=New_Rev/(100)
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
gen Turbine_Built=0 
replace Turbine_Built=1 if Commission==year 
replace Turbine_Built=0 if Commission==. 

gen DecomTurbines=0 
replace DecomTurbines=1 if Decommission==year
replace DecomTurbines=0 if Decommission==. 

gen TurbineCapkW = CapacitykW if Commission==year 
*------------------------------------------
keep FormerMunicipality TurbineCapkW Turbine_Built  DecomTurbines year New_Rev 
*------------------------------------------
collapse(sum) New_Rev TurbineCapkW Turbine_Built DecomTurbines , by (FormerMunicipality year)
label var New_Rev "New Revenues from commissioned wind turbines, in Euro"
label var TurbineCapkW "Capacity of newly commissioned wind turbines, in kW"  
label var Turbine_Built "No of newly commissioned wind turbines in that year" 

*------------------------------------------
egen TEMP_ID=group(FormerMunicipality)
xtset TEMP_ID year
bysort FormerMunicipality (year) : gen cum_turbine_inst = sum(Turbine_Built)
label var cum_turbine_inst "cumulative number of installed turbines"
bysort FormerMunicipality (year) : gen cum_turbine_decom = sum(DecomTurbines)
label var cum_turbine_decom "cumulative number of decommissioned turbines"
gen Turbine_installed= (cum_turbine_inst-cum_turbine_decom) 
label var Turbine_installed "Total number of turbines in operation" 
*--------------------------------------------
sort TEMP_ID year
gen L1_Turbine_installed=L.Turbine_installed
gen L2_Turbine_installed=L2.Turbine_installed
gen L3_Turbine_installed=L3.Turbine_installed
gen L4_Turbine_installed=L4.Turbine_installed
gen L5_Turbine_installed=L5.Turbine_installed
keep if inrange((year),1990,2006)
drop TEMP_ID cum_turbine_inst cum_turbine_decom DecomTurbines 
*--------------------------------------------
save "./TEMP/Temp18", replace 
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
*		Merging of municipalities in Copenhagen County (see explanation at the beginning of the do file);
*       Merging of municipalities Marstal & Aeroskobing (see explanation at the beginning of the do file);
*       Merging of municipalities in Bornholm County (see explanation at the beginning of the do file)
*------------------------------------------------------------------------------*
*------------------------------------------------------------------------------*
* These three data sources have the disaggregated municipalities in Bornholm, but not Bornholm County. 
* We aggregate the five municipalities to Bornholm County, add it to the data and then remove the disaggregated municipalities.   
*------------------------------------------------------------------------------*
local DataSet "Temp9 Temp11 Temp18"
foreach VVV in `DataSet' {
*-------------------------------------
use "./TEMP/`VVV'", clear 
gen TEMP_I=_n
gen TEMP_II=_n
order year TEMP_I, first 
order TEMP_II FormerMunicipality, last
*----------------------------------
save "./TEMP/`VVV'", replace 
*-------------------------------------
* Compute Bornholm County (sum of the five disaggregated municipalities)
use "./TEMP/`VVV'", clear 
drop if FormerMunicipality!="Allinge-Gudhjem" & FormerMunicipality!="Hasle" & FormerMunicipality!="Nexø" & FormerMunicipality!="Rønne" & FormerMunicipality!="Aakrikreby"
collapse(sum) TEMP_I-TEMP_II, by(year) 
gen FormerMunicipality="Bornholm" 
save "./TEMP/Bornholm_`VVV'", replace 
*------------------------------------
use "./TEMP/`VVV'", clear
*-------------------------
*remove the disaggregated municipalities in Bornholm
drop if FormerMunicipality=="Bornholm" 
drop if FormerMunicipality=="Allinge-Gudhjem"
drop if FormerMunicipality=="Hasle"
drop if FormerMunicipality=="Nexø"
drop if FormerMunicipality=="Rønne"
drop if FormerMunicipality=="Aakrikreby"
*-------------------------
* add Bornhom Country to the data 
append using "./TEMP/Bornholm_`VVV'"
*---------------------------
egen MUN_ID=group(FormerMunicipality)
sum MUN_ID
drop TEMP_I TEMP_II MUN_ID
save "./TEMP/`VVV'", replace 
}
*-------------------------------------------------------------------------------
* For each of the following temporary data sets, we merge the data for the municipalities that are in the county of Copenhagen (and later on, drop them from the analysis)
* Additionally, we merge the data corresponding to Ærøskøbing, Marstal and Ærø (see explanation at the beginning of the file).
local DataSet "Temp1 Temp2 Temp3 Temp4 Temp5 Temp6 Temp9 Temp11 Temp18"
foreach VVV in `DataSet' {
*-------------------------------------
use "./TEMP/`VVV'", clear 
gen TEMP_I=_n
gen TEMP_II=_n
order year TEMP_I, first 
order TEMP_II FormerMunicipality, last
*-------------------------------------
save "./TEMP/`VVV'", replace 
*-------------------------------------
*-------------------------------------
drop if FormerMunicipality!="Copenhagen" & FormerMunicipality!="Frederiksberg" & FormerMunicipality!="Albertslund" & FormerMunicipality!="Ballerup" & FormerMunicipality!="Brøndby" & FormerMunicipality!="Dragør" & FormerMunicipality!="Gentofte" & FormerMunicipality!="Gladsaxe"  & FormerMunicipality!="Glostrup" & FormerMunicipality!="Herlev" & FormerMunicipality!="Hvidovre" & FormerMunicipality!="HøjeTaastrup" & FormerMunicipality!="Torslunde-Ishøj" & FormerMunicipality!="Ledøje-Smørum" & FormerMunicipality!="Lyngby-Taarbæk" & FormerMunicipality!="Rødovre" & FormerMunicipality!="Søllerød" & FormerMunicipality!="Tårnby" & FormerMunicipality!="Vallensbæk" & FormerMunicipality!="Værløse"
collapse(sum) TEMP_I-TEMP_II, by(year) 
gen FormerMunicipality="Københavns"
save "./TEMP/Copenhagen_`VVV'", replace 
*---------------------------------
*---------------------------------
use "./TEMP/`VVV'", clear  
drop if FormerMunicipality !="Ærøskøbing(-2005/2006)" & FormerMunicipality!="Marstal" & FormerMunicipality!="Ærø(2005/2006-)" 
collapse(sum) TEMP_I-TEMP_II, by(year) 
gen FormerMunicipality="Ærøskøbing" 
save "./TEMP/Aeroskobing_`VVV'", replace 
*--------------------------------------------------
*--------------------------------------------------
* Append the merged data to the rest of the dataset
*--------------------------------------------------
use "./TEMP/`VVV'", clear
*-----------remove the municipalities included in Copenhagen county---------
drop if FormerMunicipality=="Copenhagen"
drop if FormerMunicipality=="Frederiksberg" 
drop if FormerMunicipality=="Albertslund" 
drop if FormerMunicipality=="Ballerup"
drop if FormerMunicipality=="Brøndby"
drop if FormerMunicipality=="Dragør"
drop if FormerMunicipality=="Gentofte"
drop if FormerMunicipality=="Gladsaxe"
drop if FormerMunicipality=="Glostrup"
drop if FormerMunicipality=="Herlev"
drop if FormerMunicipality=="Hvidovre"
drop if FormerMunicipality=="HøjeTaastrup"
drop if FormerMunicipality=="Torslunde-Ishøj"
drop if FormerMunicipality=="Ledøje-Smørum"
drop if FormerMunicipality=="Lyngby-Taarbæk"
drop if FormerMunicipality=="Rødovre"
drop if FormerMunicipality=="Søllerød"
drop if FormerMunicipality=="Tårnby"
drop if FormerMunicipality=="Vallensbæk"
drop if FormerMunicipality=="Værløse"
*remove the former disaggregated municipalities in Ærøskøbing/Marstal 
drop if FormerMunicipality=="Ærøskøbing(-2005/2006)"
drop if FormerMunicipality=="Marstal" 
drop if FormerMunicipality=="Ærø(2005/2006-)" 
*remove the disaggregated municipalities in Bornholm
drop if FormerMunicipality=="Allinge-Gudhjem"
drop if FormerMunicipality=="Hasle"
drop if FormerMunicipality=="Nexø"
drop if FormerMunicipality=="Rønne"
drop if FormerMunicipality=="Aakrikreby"
*----------------------------------
append using "./TEMP/Copenhagen_`VVV'"
append using "./TEMP/Aeroskobing_`VVV'"
*----------------------------------
egen MUN_ID=group(FormerMunicipality)
sum MUN_ID
drop TEMP_I TEMP_II
save "./TEMP/`VVV'", replace 
}
*-------------------------------------------------------------------------------
* The names of the counties include special letters (like ø, å, æ) which are not always well handled by GIS & Excel. 
* Depending on the data source (Statistics Denmark, QGIS/DigDag) the spelling differs and the names hence have to be adjusted manually. 
*-------------------------------------------------------------------------------
use "./TEMP/CountyData",clear
*-------------------------------------------------------------------------------
*remove of the regions which are included in Copenhagen County  
drop if FormerMunicipality=="Frederiksberg" 
drop if FormerMunicipality=="Albertslund" 
drop if FormerMunicipality=="Ballerup"
drop if FormerMunicipality=="Brøndby"
drop if FormerMunicipality=="Dragør"
drop if FormerMunicipality=="Gentofte"
drop if FormerMunicipality=="Gladsaxe"
drop if FormerMunicipality=="Glostrup"
drop if FormerMunicipality=="Herlev"
drop if FormerMunicipality=="Hvidovre"
drop if FormerMunicipality=="HøjeTaastrup"
drop if FormerMunicipality=="Torslunde-Ishøj"
drop if FormerMunicipality=="Ledøje-Smørum"
drop if FormerMunicipality=="Lyngby-Taarbæk"
drop if FormerMunicipality=="Rødovre"
drop if FormerMunicipality=="Søllerød"
drop if FormerMunicipality=="Tårnby"
drop if FormerMunicipality=="Vallensbæk"
drop if FormerMunicipality=="Værløse"
*remove of the regions which are Ærø 
drop if FormerMunicipality=="Ærøskøbing(-2005/2006)"
drop if FormerMunicipality=="Ærø(2005/2006-)" 
*remove Bornholm and its subcategories 
drop if FormerMunicipality=="Bornholm" 
drop if FormerMunicipality=="Allinge-Gudhjem"
drop if FormerMunicipality=="Hasle"
drop if FormerMunicipality=="Nexø"
drop if FormerMunicipality=="Rønne"
drop if FormerMunicipality=="Aakrikreby"
*-------------------------------------------------------------------------------
* Editing of the names of municipalities
replace FormerMunicipality ="Københavns" if FormerMunicipality=="Copenhagen"
*-----------------------
replace FormerMunicipality ="Ærøskøbing" if FormerMunicipality=="Marstal"
*-----------------------
qui DataCleaning // execute predefined data cleaning program 
save "./TEMP/Temp10", replace
*-------------------------------------------------------------------------------
* adjustment to Temp11 (average wind density in 50m): we assume that the densitiy is constant over time and thus the same for each years. 
use "./TEMP/Temp11", clear
drop year 
save "./TEMP/Temp11", replace
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* 								MERGE ALL SEPARATE DATA SETS 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* Overview of temporary used datasets :
* Temp1 - Temp 1_1 - 1_3 = Budget data (source: Statistics Denmark)
* Temp2 = Income data (source: Statistics Denmark) 
* Temp3 = Employment data, aggregated by workplace (source: Statistics Denmark) 
* Temp4 = Employment data, aggregated by residence (source: Statistics Denmark) 
* Temp5 = Unemployment data (source: Statistics Denmark)  
* Temp6 = Population data (source: Statistics Denmark) 
* Temp7 = Agricultural surface data from the census 1999 (source: Statistics Denmark) 
* Temp8 = Agricultural surface data on county level (source: Statistics Denmark) 
* Temp9 = Agricultural surface data on municipal level(combination of Temp8 + Temp9) 
* Temp10 = County data with minor edits (source: Statistics Denmark)  
* Temp11 = Average wind density (source: Global Wind Atlas & QGIS/DigDag) 
* Temp12 = Electricity Price 1985-1999 (source: Danish Energy Agency) 
* Temp13 = Hourly electricity price 2000-2010 (source: Danish Energy Agency) 
* Temp14 = Hourly wind production and electricity price 2000-2010 (source: Danish Energy Agency) 
* Temp15 = Yearly sum wind production 2000-2010 (source: Danish Energy Agency) 
* Temp16 = Electricity price 1985-2010 (source: Danish Energy Agency) 
* Temp17 = Municipalitie's corresponding electricity grid (source : QGIS/DigDag) 
* Temp18 = New Revenues and lagged number of turbine installations (source: DigDag and Danish Energy Agency)
* ElecSupport: Yearly electricity support in cEuro/kWh 1990-2006 (source: EnergiStyrelsen)
* TurbineMaster: Overview of the turbine data used to calculate the new revenues (source: EnergiStyrelsen, QGIS/DigDag and The Danish Energy Agency)
* CountyData: Overview of the municipalities and the corresponding county (source: Statistics Denmark) 
*-------------------------------------------------------------------------------
use "./TEMP/Temp1", clear
local DataSet "Temp2 Temp3 Temp4 Temp5 Temp6 Temp9 "
*---------------------------
*---------------------------
foreach VVV in `DataSet' {
mmerge FormerMunicipality year using "./TEMP/`VVV'", type(1:1)
sort _merge FormerMunicipality year
drop _merge
} 
*-------------------------- 
mmerge FormerMunicipality using "./TEMP/Temp10", type(n:1)
drop _merge
*-------------------------
joinby FormerMunicipality using "./TEMP/Temp11", unmatched(both)
keep if _merge==3 // Christiansø is not used in the final panel 
*---------------------------
mmerge FormerMunicipality year using "./TEMP/Temp18", type(1:1)
* some municipalities have no wind turbine installations in the time period (_merge==1) 
*---------------------------
drop _merge MUN_ID
egen MUN_ID=group(FormerMunicipality)
xtset MUN_ID year
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* 						GENERATION OF CONTROL VARIABLES 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
gen UnemplyRate=Unemplymnt/(Unemplymnt+Emp_Tot)
gen L2_AgrSurface=L2.AgrSurface
gen L4_AgrSurface=L4.AgrSurface

gen ElecSupPol=0 
replace ElecSupPol= 1 if inrange((year),1991,1999) 
replace ElecSupPol= 2 if inrange((year),2000,2002) 
replace ElecSupPol= 3 if inrange((year),2003,2004) 
replace ElecSupPol= 4 if inrange((year),2005,2006) 

joinby year using "./TEMP/ElecSupport"
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*						Budget Category Edit
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* Budget Revenue Category 
* We define the budgetary revnenues in negative values 
local Bud "Bdgt_Admin_Re Bdgt_Edu_Re Bdgt_Health_Re Bdgt_HousingAmenities_Re Bdgt_Total_Re Bdgt_Public_Ut_Re Bdgt_Traffic_Re"
foreach VVV in `Bud' {
replace `VVV'=`VVV'*(-1)
}
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*						DANISH KRONE TO EURO CONVERSION 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* The conversion rate is set to 1 € = 7,46038 DK
* The current unit of the following (listed in "local vars") is 1000 DK
local vars "Bdgt_Admin_T Bdgt_Edu_T Bdgt_Health_T Bdgt_HousingAmenities_T Bdgt_Total_T Bdgt_Public_Ut_T Bdgt_Traffic_T Bdgt_Admin_Ex Bdgt_Edu_Ex Bdgt_Health_Ex Bdgt_HousingAmenities_Ex Bdgt_Total_Ex Bdgt_Public_Ut_Ex Bdgt_Traffic_Ex Bdgt_Admin_Re Bdgt_Edu_Re Bdgt_Health_Re Bdgt_HousingAmenities_Re Bdgt_Total_Re Bdgt_Public_Ut_Re Bdgt_Traffic_Re Inc_Pers_Tot Inc_Prmry_Tot Inc_CrrntTrnsfrs Inc_Entrepr_Tot Inc_Entrepr Inc_Wages Inc_Wages_Tot Inc_Pnsns_Tot Inc_CashBenefits Inc_Pnsns_CivilServant Inc_DailyBnfts_Tot Inc_EarlyRtrmntPay Inc_EduGrant Inc_Gratuities Inc_Dedctn Inc_OtherBnfts Inc_PnsnsOther Inc_Pnsns_ATP Inc_Remnrtn Inc_PnsnsSoc Inc_EarlyRtrmnt Inc_Pnsn_Supplmtn Inc_TmprlyLeave Inc_UnemplymtnBnfts" 
*-----------------------
foreach VVV in `vars' {
replace `VVV'=`VVV'/(7.46038)
}
* Conversion from 1.000 Euros to Euros 
foreach VVV in `vars' {
replace `VVV'=`VVV'*(1000)
}
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*				PER CAPITA CONVERSION OF THE VARIABLES OF INTEREST
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
keep if inrange((year),1993,2006) 
* We compute the per capita values by dividing all vars with the lagged number of total employment. The employment data is available for the years 1993-2006 
local perCapita "Bdgt_Admin_T Bdgt_Edu_T Bdgt_Health_T Bdgt_HousingAmenities_T Bdgt_Total_T Bdgt_Public_Ut_T Bdgt_Traffic_T Bdgt_Admin_Ex Bdgt_Edu_Ex Bdgt_Health_Ex Bdgt_HousingAmenities_Ex Bdgt_Total_Ex Bdgt_Public_Ut_Ex Bdgt_Traffic_Ex Bdgt_Admin_Re Bdgt_Edu_Re Bdgt_Health_Re Bdgt_HousingAmenities_Re Bdgt_Total_Re Bdgt_Public_Ut_Re Bdgt_Traffic_Re Inc_Pers_Tot Inc_Prmry_Tot Inc_CrrntTrnsfrs Inc_Entrepr_Tot Inc_Entrepr Inc_Wages Inc_Wages_Tot Inc_Pnsns_Tot Inc_CashBenefits Inc_Pnsns_CivilServant Inc_DailyBnfts_Tot Inc_EarlyRtrmntPay Inc_EduGrant Inc_Gratuities Inc_Dedctn Inc_OtherBnfts Inc_PnsnsOther Inc_Pnsns_ATP Inc_Remnrtn Inc_PnsnsSoc Inc_EarlyRtrmnt Inc_Pnsn_Supplmtn Inc_TmprlyLeave Inc_UnemplymtnBnfts Emp_WP_109 Emp_WP_500 Emp_WP_1009 Emp_WP_1509 Emp_WP_1709 Emp_WP_2009 Emp_WP_2309 Emp_WP_2600 Emp_WP_2709 Emp_WP_3600 Emp_WP_4009 Emp_WP_4500 Emp_WP_5000 Emp_WP_5100 Emp_WP_5200 Emp_WP_5500 Emp_WP_6009 Emp_WP_6400 Emp_WP_6509 Emp_WP_7009 Emp_WP_7209 Emp_WP_7500 Emp_WP_8000 Emp_WP_8519 Emp_WP_8539 Emp_WP_9009 Emp_WP_9800 Emp_WP_Tot Emp_109 Emp_500 Emp_1009 Emp_1509 Emp_1709 Emp_2009 Emp_2309 Emp_2600 Emp_2709 Emp_3600 Emp_4009 Emp_4500 Emp_5000 Emp_5100 Emp_5200 Emp_5500 Emp_6009 Emp_6400 Emp_6509 Emp_7009 Emp_7209 Emp_7500 Emp_8000 Emp_8519 Emp_8539 Emp_9009 Emp_9800 Emp_Tot Unemplymnt UnemplyRate Population AgrSurface AVG_WindDensity New_Rev" 
*----------------------------
foreach VVV in `perCapita' {
gen `VVV'_PC=`VVV'/L.Emp_Tot
}
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* 								Remaining edits
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* Absence of new revenues = zero new revenues
local vars "New_Rev  "
foreach VVV in `vars' {
replace `VVV'=0 if `VVV'==. & inrange((year),1993,2002)
replace `VVV'=. if inrange((year),2003,2006)
}
*----------------------
local vars "New_Rev_PC "
foreach VVV in `vars' {
replace `VVV'=0 if `VVV'==. & inrange((year),1993,2002)
replace `VVV'=. if inrange((year),2003,2006)
replace `VVV'=. if year==1993

}
* Absence of new turbines = zero new turbines 
*--------------------------
local vars "TurbineCapkW Turbine_Built Turbine_installed L1_Turbine_installed L2_Turbine_installed L3_Turbine_installed L4_Turbine_installed L5_Turbine_installed"
foreach VVV in `vars' {
replace `VVV'=0 if `VVV'==.
}
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
* Final Label 
* Municipal Budget Categories 
label var Bdgt_Admin_T "Budget, Total, Administration, in Euros" 
label var Bdgt_Edu_T "Budget, Total, Education and culture, in Euros"
label var Bdgt_Health_T "Budget, Total, Health care activities, in Euros" 
label var Bdgt_HousingAmenities_T "Budget, Total, Housing and community amenities, in Euros" 
label var Bdgt_Total_T "Budget, Total, Total, in Euros" 
label var Bdgt_Public_Ut_T "Budget, Total, Public utilities, etc., in Euros" 
label var Bdgt_Traffic_T "Budget, Total, Traffic and infrastructure, in Euros" 
*------------------------------
label var Bdgt_Admin_Ex "Budget, Expenditure, Administration, in Euros" 
label var Bdgt_Edu_Ex "Budget, Expenditure, Education and culture, in Euros"
label var Bdgt_Health_Ex "Budget, Expenditure, Health care activities, in Euros" 
label var Bdgt_HousingAmenities_Ex "Budget, Expenditure, Housing and community amenities, in Euros" 
label var Bdgt_Total_Ex "Budget, Expenditure, Total, in Euros" 
label var Bdgt_Public_Ut_Ex "Budget, Expenditure, Public utilities, etc., in Euros" 
label var Bdgt_Traffic_Ex "Budget, Expenditure, Traffic and infrastructure, in Euros" 
*------------------------------
label var Bdgt_Admin_Re "Budget, Revenue, Administration, in Euros" 
label var Bdgt_Edu_Re "Budget, Revenue, Education and culture, in Euros"
label var Bdgt_Health_Re "Budget, Revenue, Health care activities, in Euros" 
label var Bdgt_HousingAmenities_Re "Budget, Revenue, Housing and community amenities, in Euros" 
label var Bdgt_Total_Re "Budget, Revenue, Total, in Euros" 
label var Bdgt_Public_Ut_Re "Budget, Revenue, Public utilities, etc., in Euros" 
label var Bdgt_Traffic_Re "Budget, Revenue, Traffic and infrastructure, in Euros"  
*-------------------------------------------------------------------------------
* Income Categories 
label var Inc_CrrntTrnsfrs "Current transfers, etc., total, in Euros"
label var Inc_CashBenefits "Cash benefits, in Euros"
label var Inc_Pnsns_CivilServant "Civil servant pensions, in Euros, documented from 2002 onwards"
label var Inc_DailyBnfts_Tot "Daily benefits and etc., total, in Euros" 
label var Inc_Entrepr_Tot "Entrepreneurial income, total, in Euros" 
label var Inc_EarlyRtrmntPay "Early retirement pay, in Euros" 
label var Inc_EduGrant "Education grants, in Euros" 
label var Inc_EduGrant "Education grants, in Euros" 
label var Inc_Entrepr "Entrepreneurial income, in Euros" 
label var Inc_Gratuities "Gratuities, in Euros" 
label var Inc_Dedctn "Income/Deduction, assisting spouse, in Euros" 
label var Inc_OtherBnfts "Ofther benefits, in Euros" 
label var Inc_PnsnsOther "Other pensions, in Euros" 
label var Inc_Pnsns_Tot "Pensions, etc., total, in Euros" 
label var Inc_Pers_Tot"Personal income, total, in Euros" 
label var Inc_Prmry_Tot "Primary income, total, in Euros" 
label var Inc_Pnsns_ATP "Pensions from ATP, in Euros" 
label var Inc_Remnrtn "Remuneration, in Euros" 
label var Inc_PnsnsSoc "Social pensions, in Euros" 
label var Inc_EarlyRtrmnt "Special early retirement pay, in Euros" 
label var Inc_Pnsn_Supplmtn "Supplements to social pensions, in Euros" 
label var Inc_TmprlyLeave "Temporarely leave benefits, in Euros" 
label var Inc_UnemplymtnBnfts "Unemployment benefits and the like, in Euros" 
label var Inc_Wages "Wages, in Euros" 
label var Inc_Wages_Tot "Wages and salaries, total, in Euros" 
*-------------------------------------------------------------------------------
*------------------------- per capita ------------------------------------------
label var New_Rev_PC "New Revenues per capita, in Euros" 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
label var Bdgt_Admin_T_PC "Budget per Capita , Total, Administration, in Euros" 
label var Bdgt_Edu_T_PC "Budget per Capita , Total, Education and culture, in Euros"
label var Bdgt_Health_T_PC "Budget per Capita , Total, Health care activities, in Euros" 
label var Bdgt_HousingAmenities_T_PC "Budget per Capita , Total, Housing and community amenities, in Euros" 
label var Bdgt_Total_T_PC "Budget per Capita , Total, Total, in Euros" 
label var Bdgt_Public_Ut_T_PC "Budget per Capita , Total, Public utilities, etc., in Euros" 
label var Bdgt_Traffic_T_PC "Budget per Capita , Total, Traffic and infrastructure, in Euros" 
*------------------------------
label var Bdgt_Admin_Ex_PC "Budget per Capita , Expenditure, Administration, in Euros" 
label var Bdgt_Edu_Ex_PC "Budget per Capita , Expenditure, Education and culture, in Euros"
label var Bdgt_Health_Ex_PC "Budget per Capita , Expenditure, Health care activities, in Euros" 
label var Bdgt_HousingAmenities_Ex_PC "Budget per Capita , Expenditure, Housing and community amenities, in Euros" 
label var Bdgt_Total_Ex_PC "Budget per Capita , Expenditure, Total, in Euros" 
label var Bdgt_Public_Ut_Ex_PC "Budget per Capita , Expenditure, Public utilities, etc., in Euros" 
label var Bdgt_Traffic_Ex_PC "Budget per Capita , Expenditure, Traffic and infrastructure, in Euros" 
*------------------------------
label var Bdgt_Admin_Re_PC "Budget per Capita , Revenue, Administration, in Euros" 
label var Bdgt_Edu_Re_PC "Budget per Capita , Revenue, Education and culture, in Euros"
label var Bdgt_Health_Re_PC "Budget per Capita , Revenue, Health care activities, in Euros" 
label var Bdgt_HousingAmenities_Re_PC "Budget per Capita , Revenue, Housing and community amenities, in Euros" 
label var Bdgt_Total_Re_PC "Budget per Capita , Revenue, Total, in Euros" 
label var Bdgt_Public_Ut_Re_PC "Budget per Capita , Revenue, Public utilities, etc., in Euros" 
label var Bdgt_Traffic_Re_PC "Budget per Capita , Revenue, Traffic and infrastructure, in Euros" 
*-------------------------------------------------------------------------------
label var Inc_CrrntTrnsfrs_PC "Current transfers, etc. per capita, total, in Euros"
label var Inc_CashBenefits_PC "Cash benefits per capita, in Euros"
label var Inc_Pnsns_CivilServant_PC "Civil servant pensions per capita, in Euros, documented from 2002 onwards"
label var Inc_DailyBnfts_Tot_PC "Daily benefits and etc., total per capita, in Euros" 
label var Inc_Entrepr_Tot_PC "Entrepreneurial income, total per capita, in Euros" 
label var Inc_EarlyRtrmntPay_PC "Early retirement pay per capita, in Euros" 
label var Inc_EduGrant_PC "Education grants per capita, in Euros" 
label var Inc_EduGrant_PC "Education grants per capita, in Euros" 
label var Inc_Entrepr_PC "Entrepreneurial income per capita, in Euros" 
label var Inc_Gratuities_PC "Gratuities per capita, in Euros" 
label var Inc_Dedctn_PC "Income/Deduction, assisting spouse per capita, in Euros" 
label var Inc_OtherBnfts_PC "Ofther benefits per capita, in Euros" 
label var Inc_PnsnsOther_PC "Other pensions per capita, in Euros" 
label var Inc_Pnsns_Tot_PC "Pensions, etc., total per capita, in Euros" 
label var Inc_Pers_Tot_PC "Personal income, total per capita, in Euros" 
label var Inc_Prmry_Tot_PC "Primary income, total per capita, in Euros" 
label var Inc_Pnsns_ATP_PC "Pensions from ATP per capita, in Euros" 
label var Inc_Remnrtn_PC "Remuneration per capita, in Euros" 
label var Inc_PnsnsSoc_PC "Social pensions per capita, in Euros" 
label var Inc_EarlyRtrmnt_PC "Special early retirement pay per capita, in Euros" 
label var Inc_Pnsn_Supplmtn_PC "Supplements to social pensions per capita, in Euros" 
label var Inc_TmprlyLeave_PC "Temporarely leave benefits per capita, in Euros" 
label var Inc_UnemplymtnBnfts_PC "Unemployment benefits and the like per capita, in Euros" 
label var Inc_Wages_PC "Wages per capita, in Euros" 
label var Inc_Wages_Tot_PC "Wages and salaries, total per capita, in Euros" 
*------------------------------------------------------------------------------- 
order FormerMunicipality MUN_ID County year Bdgt_Admin_T Bdgt_Edu_T Bdgt_Health_T Bdgt_HousingAmenities_T Bdgt_Total_T Bdgt_Public_Ut_T Bdgt_Traffic_T Bdgt_Admin_Ex Bdgt_Edu_Ex Bdgt_Health_Ex Bdgt_HousingAmenities_Ex Bdgt_Total_Ex Bdgt_Public_Ut_Ex Bdgt_Traffic_Ex Bdgt_Admin_Re Bdgt_Edu_Re Bdgt_Health_Re Bdgt_HousingAmenities_Re Bdgt_Total_Re Bdgt_Public_Ut_Re Bdgt_Traffic_Re Inc_Pers_Tot Inc_Prmry_Tot Inc_CrrntTrnsfrs Inc_Entrepr_Tot Inc_Entrepr Inc_Wages Inc_Wages_Tot Inc_Pnsns_Tot
*-------------------------------------------------------------------------------
save "./FinalPanel", replace 
save "../Estimations/FinalPanel.dta",replace
*-------------------------------------------------------------------------------
*						ERASE TEMPORARY DATA SETS 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
foreach num of numlist  1/18 {
erase "./TEMP/Temp`num'.dta"
}
erase "./TEMP/Temp1_1.dta"
erase "./TEMP/Temp1_2.dta"
erase "./TEMP/Temp1_3.dta" 
*----------------------------
foreach num of numlist  1 2 3 4 5 6 9 11 18 {
erase "./TEMP/Copenhagen_Temp`num'.dta"
erase "./TEMP/Aeroskobing_Temp`num'.dta"
}
foreach num of numlist  9 11 18 {
erase "./TEMP/Bornholm_Temp`num'.dta"
} 
erase "./TEMP/ElecSupport.dta"
erase "./TEMP/TurbineMaster.dta"
erase "./TEMP/CountyData.dta"
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*-----------------------------
log close 
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
