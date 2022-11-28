clear
cd "F:\Master\These\Data\WeeklyDeaths"

append using 1389.dta 1390.dta 1391.dta 1392.dta 1393.dta 1394.dta 1395.dta 1396.dta 1397.dta 1398.dta 1399.dta 1400.dta
save aggregateddeaths.dta, replace

gen weekno= substr(week,5,2)
label variable weekno "week number"
destring weekno, replace



generate season = "cold" if weekno >= 26
replace season = "hot" if weekno <26
label variable season "season"

*age classification:

label define ageclassl 0 "infant" 1 "child" 2 "teen" 3 "adult" ///
4 "middle age" 5 "senior" 
gen ageclass=0 if age=="0"
replace ageclass=1 if age=="1-4" | age=="5-9" | age=="10-14"
replace ageclass=2 if age=="15-19"
replace ageclass=3 if age=="20-24" | age=="25-29" | age=="30-34" | age=="35-39"
replace ageclass=4 if age=="40-44" | age=="45-49" | age=="50-54" | age=="55-59"
replace ageclass=5 if age=="60-64" | age=="65-69" | age=="70-74" | age=="75-79" | age=="80-84"| age=="85-89" | age=="90-94" | age=="+95"
label variable ageclass "age classification"
label values ageclass ageclassl
destring year, replace



egen PAD=total(deaths), by(year province)
label variable PAD "Province Annual Deaths"

egen TAD=total (deaths), by (year)
label variable TAD "Total Annual Deaths"


egen PSD=total(deaths), by(season year province)
label variable PSD "Province Seasonal Deaths"



egen TSD=total (deaths), by (season year)
label variable TSD "Total Seasonal Deaths"


*encoding:

gen age_ =.
replace age_=0 if age=="0"
replace age_=1 if age=="1-4"
replace age_ =2 if age=="5-9"
replace age_ =3 if age=="10-14"
replace age_=4 if age=="15-19"
replace age_ =5 if age=="20-24"
replace age_ =6 if age=="25-29"
replace age_=7 if age=="30-34"
replace age_=8 if age=="35-39"
replace age_=9 if age=="40-44"
replace age_=10 if age=="45-49"
replace age_=11 if age=="50-54"
replace age_=12 if age=="55-59"
replace age_=13 if age=="60-64"
replace age_=14 if age=="65-69"
replace age_=15 if age=="70-74"
replace age_=16 if age=="75-79"
replace age_=17 if age=="80-84"
replace age_=18 if age=="85-89"
replace age_=19 if age=="90-94"
replace age_=20 if age=="+95"
drop age
rename age_ age

label define agel 0 "0" 1 "1-4" 2 "5-9" 3 "10-14" ///
4 "15-19" 5 "20-24" 6 "25-29" 7 "30-34" 8 "35-39" ///
9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" 13 "60-64" ///
14 "65-69" 15 "70-74" 16 "75-79" 17 "80-84" 18 "85-89" ///
19 "90-94" 20 "+95"
label values age agel 



encode gender, gen(gender_)
drop gender
rename gender_ gender

encode province, gen(province_code)
drop province
rename province_code province


encode season, gen(season_)
drop season
rename season_ season

encode week, gen(week_)
drop week
rename week_ week

rename year shamsiyear


save aggregateddeaths.dta, replace