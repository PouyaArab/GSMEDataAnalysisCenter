clear
cd "F:\Master\These\Data\Weather"
use rawtotalweather.dta

/*Bringinig Longtitude*/
merge m:1 stationid using longitude
order Longitude, before(Latitude)
drop _merge
codebook station

cd "F:\Master\These\Descriptive"

label variable نامايستگاه "station name"
rename نامايستگاه station
label variable ناماستان "province name"
rename ناماستان province_name

gen province="P0001" if province_name=="آذربايجان شرقي"
label variable province "province code"
replace province="P0002" if province_name=="آذربايجان غربي"
replace province="P0003" if province_name=="اردبيل"
replace province="P0004" if province_name=="اصفهان"
replace province="P0005" if province_name=="البرز"
replace province="P0006" if province_name=="ایلام"
replace province="P0007" if province_name=="بوشهر"
replace province="P0008" if province_name=="تهران"
replace province="P0009" if province_name=="چهارمحال و بختياري"
replace province="P0010" if province_name=="خراسان جنوبي"
replace province="P0011" if province_name=="خراسان رضوي"
replace province="P0012" if province_name=="خراسان شمالي"
replace province="P0013" if province_name=="خوزستان"
replace province="P0014" if province_name=="زنجان"
replace province="P0015" if province_name=="سمنان"
replace province="P0016" if province_name=="سيستان و بلوچستان"
replace province="P0017" if province_name=="فارس"
replace province="P0018" if province_name=="قزوين"
replace province="P0019" if province_name=="قم"
replace province="P0020" if province_name=="كردستان"
replace province="P0021" if province_name=="كرمان"
replace province="P0022" if province_name=="كرمانشاه"
replace province="P0023" if province_name=="كهگيلويه و بويراحمد"
replace province="P0024" if province_name=="گلستان"
replace province="P0025" if province_name=="گيلان"
replace province="P0026" if province_name=="لرستان"
replace province="P0027" if province_name=="مازندران"
replace province="P0028" if province_name=="مركزي"
replace province="P0029" if province_name=="هرمزگان"
replace province="P0030" if province_name=="همدان"
replace province="P0031" if province_name=="يزد"




gen ADM1_EN = "East Azerbaijan" if province_name=="آذربايجان شرقي"
label variable ADM1_EN "province name in English"
replace ADM1_EN="West Azerbaijan" if province_name=="آذربايجان غربي"
replace ADM1_EN="Ardabil" if province_name=="اردبيل"
replace ADM1_EN="Isfahan" if province_name=="اصفهان"
replace ADM1_EN="Alborz" if province_name=="البرز"
replace ADM1_EN="Ilam" if province_name=="ایلام"
replace ADM1_EN="Bushehr" if province_name=="بوشهر"
replace ADM1_EN="Tehran" if province_name=="تهران"
replace ADM1_EN="Chaharmahal and Bakhtiari" if province_name=="چهارمحال و بختياري"
replace ADM1_EN="South Khorasan" if province_name=="خراسان جنوبي"
replace ADM1_EN="Razavi Khorasan" if province_name=="خراسان رضوي"
replace ADM1_EN="North Khorasan" if province_name=="خراسان شمالي"
replace ADM1_EN="Khuzestan" if province_name=="خوزستان"
replace ADM1_EN="Zanjan" if province_name=="زنجان"
replace ADM1_EN="Semnan" if province_name=="سمنان"
replace ADM1_EN="Sistan and Baluchestan" if province_name=="سيستان و بلوچستان"
replace ADM1_EN="Fars" if province_name=="فارس"
replace ADM1_EN="Qazvin" if province_name=="قزوين"
replace ADM1_EN="Qom" if province_name=="قم"
replace ADM1_EN="Kurdistan" if province_name=="كردستان"
replace ADM1_EN="Kerman" if province_name=="كرمان"
replace ADM1_EN="Kermanshah" if province_name=="كرمانشاه"
replace ADM1_EN="Kohgiluyeh and Boyer-Ahmad" if province_name=="كهگيلويه و بويراحمد"
replace ADM1_EN="Golestan" if province_name=="گلستان"
replace ADM1_EN="Gilan" if province_name=="گيلان"
replace ADM1_EN="Lorestan" if province_name=="لرستان"
replace ADM1_EN="Mazandaran" if province_name=="مازندران"
replace ADM1_EN="Markazi" if province_name=="مركزي"
replace ADM1_EN="Hormozgan" if province_name=="هرمزگان"
replace ADM1_EN="Hamadan" if province_name=="همدان"
replace ADM1_EN="Yazd" if province_name=="يزد"



drop ea atst1 blog10tst c10d1tts1 f10htst11 tst ed eaed delta gamma Ra Rns Rnl Rn G

encode province_name, gen(province_name_temp)
drop province_name
rename province_name_temp province_name

encode station, gen(station_temp)
drop station
rename station_temp station

encode AL, gen(AL_temp)
drop AL
rename AL_temp AL

encode province, gen(province_code)
drop province
rename province_code province

egen dailytemp= mean(tmean), by(shamsiyear shamsimonth shamsiday province)
label variable dailytemp "Daily mean tempereture"
egen dailyprecep= mean(rrr24), by(shamsiyear shamsimonth shamsiday province)
label variable dailyprecep "Daily mean precipitation"
egen dailyhumid= mean(um), by(shamsiyear shamsimonth shamsiday province)
label variable dailyhumid "Daily Relative Humidity"


gen Ftemp= dailytemp * 1.8 + 32
label variable Ftemp "daily tempereture in Fahrenheit"



duplicates report
duplicates drop

*Duplicates not similar in at least one weather variables
duplicates report shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime stationid
duplicates tag shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime stationid, generate(tag)
tab tag shamsiyear if shamsiyear >= 1395

graph hbar (rawsum) tag if shamsiyear >= 1395, over(province) blabel(bar) ///
ytitle("Number of duplicates not similar in at least one weather variables") ///
title("Number of duplicates across provinces") ///
note("Source: Iran Meteorological Organization, 1395-1397", span) name(duplicates1, replace) ///
yscale(range(0 12000))
graph export "Number of duplicates not similar in at least one weather variables across provinces.png" , replace  as(png) name(duplicates1)

graph hbar (rawsum) tag if shamsiyear >= 1395, over(province_name) blabel(bar) ///
ytitle("Number of duplicates not similar in at least one weather variables") ///
title("Number of duplicates across provinces") ///
note("Source: Iran Meteorological Organization, 1395-1397", span) name(duplicates2, replace) ///
yscale(range(0 12000))
graph export "Number of duplicates not similar in at least one weather variables across provinces_2.png" , replace  as(png) name(duplicates2)
 


*all except sshn
duplicates report shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime tmin tmax rrr24 um ffm umax umin stationid Latitude elevation tmean province
duplicates drop shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime tmin tmax rrr24 um ffm umax umin stationid Latitude elevation tmean province, force

*all except tmin, tmax, sshn
duplicates report shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime rrr24 um ffm umax umin stationid Latitude elevation province
duplicates drop shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime rrr24 um ffm umax umin stationid Latitude elevation province, force

*all except sshn, umin, umax
duplicates report shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime tmin tmax rrr24 ffm stationid Latitude elevation tmean province
duplicates drop shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime tmin tmax rrr24 ffm stationid Latitude elevation tmean province, force

*all except tmax, umax, umin, sshn
duplicates report shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime tmin rrr24 ffm stationid Latitude elevation province
duplicates drop shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime tmin rrr24 ffm stationid Latitude elevation province, force

*all except tmin, umax, umin, sshn
duplicates report shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime tmax rrr24 ffm stationid Latitude elevation province
duplicates drop shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime tmax rrr24 ffm stationid Latitude elevation province, force

*all except tmax, tmin, ffm
duplicates report shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime rrr24 sshn um umax umin stationid Latitude elevation province 
duplicates drop shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime rrr24 sshn um umax umin stationid Latitude elevation province, force

save Descriptive.dta, replace


clear
cd "F:\Master\These\Descriptive"
use Descriptive.dta



bysort stationid: egen start_year=min(shamsiyear)
egen nonmiss_cnt= count(datetime), by(stationid shamsiyear)
label variable nonmiss_cnt "Number of annual nonmissing observation in each station"
egen observation= count(datetime), by(stationid)
*egen nonmissing_counter_monthly= count(datetime), by(stationid shamsiyear shamsimonth)
asdoc sum tmax tmin umax umin rrr24 sshn ffm, d save(weather_cleaning_tables.doc) replace 
asdoc tab shamsiyear stationid if stationid==88180 | stationid==99550, append(weather_cleaning_tables.doc)
asdoc tab shamsiyear stationid if stationid==88175 | stationid==40851, append(weather_cleaning_tables.doc)
asdoc tab shamsiyear stationid if stationid==40739 | stationid==88120, append(weather_cleaning_tables.doc)
tempfile temp4
save `temp4'

	tab start_year
	codebook stationid
	drop if shamsiyear==start_year
	drop if shamsiyear==1397 | shamsiyear == 1338
	codebook stationid
	tab start_year

	egen nonmiss_cnt_mean = mean(nonmiss_cnt) if shamsiyear !=1397 & shamsiyear !=1338, by(stationid)
	egen nonmiss_cnt_sd = sd(nonmiss_cnt) if shamsiyear !=1397 & shamsiyear !=1338 , by(stationid)





	/*Station Flags*/

	gen SDflag=.
	replace SDflag=0 if nonmiss_cnt_sd<=5
	replace SDflag=1 if nonmiss_cnt_sd >5 & nonmiss_cnt_sd <50
	replace SDflag=2 if  nonmiss_cnt_sd >= 50 & nonmiss_cnt_sd <100
	replace SDflag=3 if  nonmiss_cnt_sd >= 100

	gen meanflag=.
	replace meanflag=0 if nonmiss_cnt_mean>=360
	replace meanflag=1 if nonmiss_cnt_mean <360 & nonmiss_cnt_mean >335
	replace meanflag=2 if nonmiss_cnt_mean <=335 & nonmiss_cnt_mean >200
	replace meanflag=3 if nonmiss_cnt_mean <=200

	gen t=0
	bysort stationid shamsiyear: replace t=1 ///
	if nonmiss_cnt<365 & shamsiyear >start_year & shamsiyear !=1397 & shamsiyear != 1338
	bysort stationid: egen t1= sum(t) 
	gen allnot365flag= 0  
	bysort stationid: replace allnot365flag= 1 if t1>0 
	drop t t1
	gen not365flag= 0
	bysort shamsiyear stationid: replace not365flag=1 if nonmiss_cnt<365
	

	decode station, gen(station_str)
	decode AL, gen(AL_str)
	decode province, gen(province_str)
	decode province_name, gen(province_name_str)
	
	collapse (first) start_year (first) meanflag (first) SDflag (first) ///
	allnot365flag (first) station_str (first) AL_str (first) province_str (first) province_name_str ///
	(first) ADM1_EN (first) observation, by(stationid)
	save stations_flags_1.dta, replace
	
use `temp4', clear
	
tempfile temp4
save `temp4'

	tab shamsiyear stationid if observation<=365
	keep if stationid==40884 | stationid==99420 | stationid==99686 | stationid==99601 | ///
	stationid==99612 | stationid==99448 | stationid==99442 | stationid==99380 | stationid==99315
	decode station, gen(station_str)
	decode AL, gen(AL_str)
	decode province, gen(province_str)
	decode province_name, gen(province_name_str)
	
	collapse (first) start_year (first) station_str (first) AL_str (first) province_str (first) province_name_str ///
	(first) ADM1_EN (first) observation, by(stationid)
	gen meanflag=3
	gen SDflag=4
	gen allnot365flag=1
	append using stations_flags_1.dta
	rename station_str station
	rename AL_str AL
	rename province_str province
	rename province_name_str province_name
	sort start_year
	label define allnot365flagl 0 "Full Report" 1 "Not full report"
	label values allnot365flag allnot365flagl
	label define meanflagl 0 "Average annual reports more than 360" ///
	1 "Average annual reports between 360 and 335" ///
	2 "Average annual reports between 335 and 200" ///
	3 "Average annual reports less than 200" 
	label values meanflag meanflagl
	label define SDflagl 0 "SD of reports less than 5" ///
	1 " SD of reports between 5 and 50" ///
	2 "SD of reports between 50 and 100" 3 "SD of reports more than 100" ///
	4 "stations reporting just for one or two years"
	label values SDflag SDflagl
	gen p95flag=0
	replace p95flag=1 if observation<=20300
	label define p95flagl 0 "covers 95 percents of the total period" ///
	1 "Does not cover 95 percents of the total period"
	label values p95flag p95flagl
	
	encode province_name, gen(province_name_temp)
	drop province_name
	rename province_name_temp province_name

	encode station, gen(station_temp)
	drop station
	rename station_temp station

	encode AL, gen(AL_temp)
	drop AL
	rename AL_temp AL

	encode province, gen(province_code)
	drop province
	rename province_code province
	order station, after(stationid)
	order observation, after(start_year)
	order province_name AL province, after(ADM1_EN)
	save stations_flag.dta, replace
	export excel stationid station start_year observation ADM1_EN province_name ///
	AL province meanflag SDflag allnot365flag p95flag using "Stations flags", firstrow(variables) replace
	asdoc tab meanflag ,append(weather_cleaning_tables.doc)
	asdoc tab SDflag ,append(weather_cleaning_tables.doc)	
	asdoc tab allnot365flag ,append(weather_cleaning_tables.doc)	
	asdoc tab p95flag ,append(weather_cleaning_tables.doc)	
	drop station start_year observation ADM1_EN province_name AL province
	save "F:\Master\These\Data\Weather\stations_flag.dta", replace

use `temp4', clear	
	
tempfile temp4
save `temp4'
	egen miladi_start_year= min(year), by(stationid)
	egen miladi_start_month = min(month) if year == miladi_start_year, by(stationid)
	drop if miladi_start_month == .
	bysort stationid (year month day):gen i =_n
	keep if i==1
	codebook station
	graph bar (count) datemiladi, over(miladi_start_month) blabel(bar) ///
	ytitle("") title("N. of establishment") name(mestab1, replace) ///
	note("Source: Iran Meteorological Organization, 1960-2018", span)
	graph export "N. of establishment Miladi.png" , replace  as(png) name(mestab1)
	
use `temp4', clear

tempfile temp4
save `temp4'
	
	egen start_month = min(shamsimonth) if shamsiyear == start_year, by(stationid)
	drop if start_month == .
	codebook station
	bysort stationid (shamsiyear shamsimonth shamsiday):gen i =_n
	keep if i==1
	codebook station
	graph bar (count) datemiladi, over(start_month) blabel(bar) ///
	ytitle("") title("N. of establishment") name(mestab2, replace) ///
	note("Source: Iran Meteorological Organization, 1338-1397", span)
	graph export "N. of establishment Shamsi.png" , replace  as(png) name(mestab2)
	
use `temp4', clear





clear
cd "F:\Master\These\Descriptive"
use Descriptive.dta
codebook station


bysort stationid: egen start_year=min(shamsiyear)
egen nonmiss_cnt= count(datetime), by(stationid shamsiyear)
label variable nonmiss_cnt "Number of annual nonmissing observation in each station"


tempfile temp4
save `temp4'
	collapse (mean) nonmiss_cnt ///  
	, by(stationid shamsiyear)
	gen full_report= 0
	replace full_report= 1 if nonmiss_cnt==365 | nonmiss_cnt==366
	gen not_full_report = 1
	replace not_full_report = 0 if nonmiss_cnt==365 | nonmiss_cnt==366
	drop if shamsiyear==1338 | shamsiyear==1397
	by shamsiyear, sort: egen number_of_FR= sum(full_report)
	by shamsiyear, sort: egen number_of_NFR= sum(not_full_report)
	gen perecent_of_FR= number_of_FR/(number_of_FR + number_of_NFR) * 100
	
	graph hbar (mean) perecent_of_FR if shamsiyear <=1365, ///
	over(shamsiyear) blabel(bar, format(%5.0g)) ///
	ytitle("Percentage of stations reporting the whole year") ///
	name(missing1, replace) note("Source: Iran Meteorological Organization, 1339-1365")
	graph export "Percentage of stations reporting the whole year.png" , replace  as(png) name(missing1)

	graph hbar (mean) perecent_of_FR if shamsiyear > 1365, ///
	over(shamsiyear) blabel(bar, format(%5.0g)) ///
	ytitle("Percentage of stations reporting the whole year") ///
	name(missing2, replace) note("Source: Iran Meteorological Organization, 1366-1396")
	graph export "Percentage of stations reporting the whole year_2.png" , replace  as(png) name(missing2)
		
		
use `temp4', clear

tempfile temp4
save `temp4'
	collapse (mean) nonmiss_cnt ///  
	, by(stationid shamsiyear)
	gen report360 = 0
	replace report360= 1 if nonmiss_cnt>=360
	gen not_report360 = 1
	replace not_report360 = 0 if nonmiss_cnt>=360
	drop if shamsiyear==1338 | shamsiyear==1397
	by shamsiyear, sort: egen number_of_FR= sum(report360)
	by shamsiyear, sort: egen number_of_NFR= sum(not_report360)
	gen perecent_of_FR= number_of_FR/(number_of_FR + number_of_NFR) * 100
	
	graph hbar (mean) perecent_of_FR if shamsiyear <=1365, ///
	over(shamsiyear) blabel(bar, format(%5.0g)) ///
	ytitle("Percentage of stations reporting more than 360 days") ///
	name(missing3, replace) note("Source: Iran Meteorological Organization, 1339-1365")
	graph export "Percentage of stations reporting the whole year_3.png" , replace  as(png) name(missing3)

	graph hbar (mean) perecent_of_FR if shamsiyear > 1365, ///
	over(shamsiyear) blabel(bar, format(%5.0g)) ///
	ytitle("Percentage of stations reporting more than 360 days") ///
	name(missing4, replace) note("Source: Iran Meteorological Organization, 1366-1396")
	graph export "Percentage of stations reporting the whole year_4.png" , replace  as(png) name(missing4)
		
		
use `temp4', clear



asdoc tab stationid if shamsiyear==1396, append(weather_cleaning_tables.doc)
asdoc tab stationid if shamsiyear==1350, append(weather_cleaning_tables.doc)

tab shamsimonth shamsiyear if  (shamsiyear==1338 | shamsiyear==1397)
asdoc tabulate shamsimonth shamsiyear if  (shamsiyear==1338 | shamsiyear==1397) ///
, title(years and months) append(weather_cleaning_tables.doc)



