clear
cd "F:\Master\These\Data\Merge"
*Weather
*generating weekno
use "F:\Master\These\Data\Weather\totalweather.dta"
keep if allnot365flag==0
keep if start_year<=1388
keep if shamsiyear>=1389 | (shamsiyear==1388 & shamsimonth==12 & shamsiday==29)
by shamsiyear shamsimonth shamsiday , sort: gen nvals = _n == 1
gen DFB = sum(nvals) -1
gen totalweekno= int(DFB/7) + 1
drop if totalweekno >= 433
drop nvals DFB



/*
by totalweekno stationid bin, sort : gen tempbin= _N
forvalues i= 0/6 {
	gen bin`i'=0
	replace bin`i' = tempbin if bin == `i'
}
*/
by totalweekno stationid bin, sort : gen tempbin= _N
forvalues i= 0/9 {
	gen bin`i'=0
	replace bin`i' = tempbin if bin == `i'
}


egen temp_precep = sum(rrr24), by(stationid province totalweekno)
egen rainfall= mean(temp_precep), by(province totalweekno)



gen pbin=0 if rainfall ==0
replace pbin = 1 if rainfall>0 & rainfall<=1
replace pbin = 2 if rainfall>1 & rainfall <= 30
replace pbin = 3 if rainfall > 100



collapse (mean) meantemp=dailytemp (mean) weekly_precep=temp_precep ///
(max) tbin0=bin0 (max) tbin1=bin1 (max) tbin2=bin2 (max)tbin3=bin3 ///
(max) tbin4=bin4 (max) tbin5=bin5 (max) tbin6=bin6 (max) tbin7=bin7 ///
(max) tbin8=bin8 (max) tbin9=bin9 (max) precepitation=pbin ///
(first) year , by (province totalweekno)
label variable tbin0 "<-5"
label variable tbin1 "-5-0"
label variable tbin2 "0-5"
label variable tbin3 "5-10"
label variable tbin4 "10-15"
label variable tbin5 "15-20"
label variable tbin6 "20-25"
label variable tbin7 "25-30"
label variable tbin8 "30-35"
label variable tbin9 "35>"
label variable precepitation "Precepitation (mm)"
label define precepitationl 0 "no weekly rainfall" 1 "weekly rainfall under 1mm" ///
2 "weekly rainfall in 1-30 mm" 3 "weekly rainfall above 100 mm"
label values precepitation precepitationl


*label variable tempbin "average number of days per week in each temperature category"
*egen week_province = group(totalweekno province)
sort totalweekno province
save mweather.dta, replace



*Mortality
clear
use "F:\Master\These\Data\WeeklyDeaths\aggregateddeaths.dta"
drop if shamsiyear >1397
by week (shamsiyear) , sort: gen nvals = _n == 1
gen totalweekno = sum(nvals)
drop if totalweekno >= 433
drop nvals TSD PSD TAD PAD season
gen logmortality= log(deaths)
*egen week_province = group(totalweekno province)
sort totalweekno province shamsiyear
save mmortality.dta, replace

clear
use mweather.dta
merge 1:m totalweekno province using mmortality
drop if province==19
save Merged.dta, replace


/*Monthly Merge*/
clear
cd "F:\Master\These\Data\Merge"
use "F:\Master\These\Data\Weather\totalweather.dta"
keep if allnot365flag==0
keep if start_year<=1388
keep if shamsiyear>=1389 | (shamsiyear==1388 & shamsimonth==12 & shamsiday==29)
by shamsiyear shamsimonth shamsiday , sort: gen nvals = _n == 1
gen DFB = sum(nvals) -1
gen totalweekno= int(DFB/7)
drop if totalweekno >= 432
gen reg_month= int(totalweekno/4) + 1
drop nvals DFB

by reg_month stationid bin, sort : gen mtempbin= _N

forvalues i= 0/9 {
	gen bin`i'=0
	replace bin`i' = mtempbin if bin == `i'
}
egen m_temp_precep = sum(rrr24), by(stationid province reg_month)
egen mrainfall= mean(m_temp_precep), by(province reg_month)


gen pbin=0 if mrainfall ==0
replace pbin = 1 if mrainfall>0 & mrainfall<=10
replace pbin = 2 if mrainfall>10 & mrainfall <= 100
replace pbin = 3 if mrainfall >100 & mrainfall <=300
replace pbin = 4 if mrainfall >300

collapse (mean) meantemp=dailytemp (mean) monthly_precep=m_temp_precep ///
(max) tbin0=bin0 (max) tbin1=bin1 (max) tbin2=bin2 (max)tbin3=bin3 ///
(max) tbin4=bin4 (max) tbin5=bin5 (max) tbin6=bin6 (max) tbin7=bin7 ///
(max) tbin8=bin8 (max) tbin9=bin9 (max) precepitation=pbin  ///
(first) year , by (province reg_month)

label variable tbin0 "<-5"
label variable tbin1 "-5-0"
label variable tbin2 "0-5"
label variable tbin3 "5-10"
label variable tbin4 "10-15"
label variable tbin5 "15-20"
label variable tbin6 "20-25"
label variable tbin7 "25-30"
label variable tbin8 "30-35"
label variable tbin9 "35>"
label variable precepitation "Precepitation (mm)"
label define precepitationl 0 "no monthly rainfall" 1 "monthly rainfall under 10mm" ///
2 "monthly rainfall in 10-100 mm" 3 "monthly rainfall in 100-300 mm" 4 "monthly rainfall above 300 mm"
label values precepitation precepitationl
save month_mweather.dta, replace


*Mortality
clear
use "F:\Master\These\Data\WeeklyDeaths\aggregateddeaths.dta"
drop if shamsiyear >1397
by week (shamsiyear) , sort: gen nvals = _n == 1
gen totalweekno = sum(nvals)-1
drop if totalweekno >= 432
gen reg_month= int(totalweekno/4) + 1
drop nvals TSD PSD TAD PAD season
egen monthly_deaths=sum(deaths) , by(reg_month age gender province)

*egen week_province = group(totalweekno province)
sort totalweekno province shamsiyear
save month_mmortality.dta, replace

clear
use month_mweather.dta
merge 1:m reg_month province using month_mmortality
drop if province==19
save month_Merged.dta, replace
