
clear
cd "F:\Master\These\Data\Weather"


*Saving Longtitude from Weather stations GIS
import excel "F:\Master\These\new data\Stations\Weather_Stations_GIS.xlsx", sheet("Sheet1") cellrange(A1:H415) firstrow
drop نامايستگاه ناماستان baisn1 page Latitude elevation
save longtitude.dta, replace


use rawtotalweather.dta

/*Bringinig Longtitude*/
merge m:1 stationid using longtitude
order Longitude, before(Latitude)
drop _merge
merge m:1 stationid using stations_flag
drop _merge

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


drop ea atst1 blog10tst c10d1tts1 f10htst11 tst ed eaed delta gamma DayDuration Ra Rns Rnl Rn G

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



duplicates drop

*all except sshn
duplicates drop shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime tmin tmax rrr24 um ffm umax umin stationid Latitude elevation tmean province, force

*all except tmin, tmax, sshn
duplicates drop shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime rrr24 um ffm umax umin stationid Latitude elevation province, force

*all except sshn, umin, umax
duplicates drop shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime tmin tmax rrr24 ffm stationid Latitude elevation tmean province, force

*all except tmax, umax, umin, sshn
duplicates drop shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime tmin rrr24 ffm stationid Latitude elevation province, force

*all except tmin, umax, umin, sshn
duplicates drop shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime tmax rrr24 ffm stationid Latitude elevation province, force

*all except tmax, tmin, ffm
duplicates drop shamsiyear shamsimonth shamsiday year month day datemiladi ///
datetime rrr24 sshn um umax umin stationid Latitude elevation province, force

save temp.dta, replace
clear

use temp.dta


/*Station Flags*/

bysort stationid: egen start_year=min(shamsiyear)
bysort stationid: egen miladi_start_year=min(year)
egen nonmiss_cnt= count(datetime), by(stationid shamsiyear)
label variable nonmiss_cnt "Number of annual nonmissing observation in each station"
gen not365flag= 0
bysort shamsiyear stationid: replace not365flag=1 if nonmiss_cnt<365
label define not365flagl 0 "the whole year is covered by this station" ///
1 "The whole year is not covered by this station"
label values not365flag not365flagl


/*
gen bin= "<10" if Ftemp <10
replace bin= "10-20" if Ftemp >=10 & Ftemp <20
replace bin = "20-30" if Ftemp>=20 & Ftemp <30
replace bin = "30-40" if Ftemp >=30 & Ftemp <40
replace bin = "40-50" if Ftemp>=40 & Ftemp < 50
replace bin = "50-60" if Ftemp >=50 & Ftemp <60
replace bin = "60-70" if Ftemp >=60 & Ftemp <70
replace bin = "70-80" if Ftemp >= 70 & Ftemp <80
replace bin = "80-90" if Ftemp >= 80 & Ftemp <90
replace bin = "90>" if Ftemp >=90
encode bin, gen(bin_temp)
drop bin
rename bin_temp bin
*/
/*
label define binl 0 "<-10" 1 "-10-0" 2 "0-10" 3 "10-20" ///
4 "20-30" 5 "30-40" 6 "40>" 

gen bin= 0 if dailytemp <-10
replace bin= 1 if dailytemp >=-10 & dailytemp <0
replace bin = 2 if dailytemp>=0 & dailytemp <10
replace bin = 3 if dailytemp >=10 & dailytemp <20
replace bin = 4 if dailytemp>=20 & dailytemp < 30
replace bin = 5 if dailytemp >=30 & dailytemp <40
replace bin = 6 if dailytemp >=40 

label values bin binl 
*/
gen season= "spring"
replace season= "summer" if shamsimonth>=3 & shamsimonth <=6
replace season= "autumn" if shamsimonth >=7 & shamsimonth <=9
replace season= "winter" if shamsimonth >=10 & shamsimonth<=12
encode season, gen(season_temp)
drop season
rename season_temp season

label define binl 0 "<-5" 1 "-5-0" 2 "0-5" 3 "5-10" 4 "10-15" 5 "15-20" ///
6 "20-25" 7 "25-30" 8 "30-35" 9 "35>"
gen bin=0 if dailytemp<-5
replace bin =1 if dailytemp >=-5 & dailytemp<0
replace bin =2 if dailytemp >=0 & dailytemp<5
replace bin =3 if dailytemp >=5 & dailytemp<10
replace bin =4 if dailytemp>=10 & dailytemp<15
replace bin =5 if dailytemp>=15 & dailytemp<20
replace bin=6 if dailytemp>=20 & dailytemp<25
replace bin=7 if dailytemp>=25 & dailytemp<30
replace bin=8 if dailytemp>=30 & dailytemp<35
replace bin=9 if dailytemp>=35
label values bin binl 



/*
gen bin= "<-10" if dailytemp <-10
replace bin= "-10-0" if dailytemp >=-10 & dailytemp <0
replace bin = "0-10" if dailytemp>=0 & dailytemp <10
replace bin = "10-20" if dailytemp >=10 & dailytemp <20
replace bin = "20-30" if dailytemp>=20 & dailytemp < 30
replace bin = "30-40" if dailytemp >=30 & dailytemp <40
replace bin = ">40" if dailytemp >=40 

encode bin, gen(bin_temp)
drop bin
rename bin_temp bin
*/



tempfile ctemp
save `ctemp'

	keep station stationid Longitude Latitude allnot365flag ///
	not365flag start_year miladi_start_year p95flag
	collapse Longitude (first) Latitude (first) allnot365flag (first) not365flag  ///
	(first) start_year (first) miladi_start_year (first) p95flag ///
	,by(stationid)
	
	gen decade=1 if start_year<=1340
	replace decade=2 if start_year>1340 & start_year<=1350
	replace decade=3 if start_year > 1350 & start_year <=1360
	replace decade=4 if start_year >1360 & start_year <=1370
	replace decade=5 if start_year>1370 & start_year<=1380
	replace decade=6 if start_year>1380
	label define decadel 1 "<=1340" 2 "1340-1350" 3 "1350-1360" 4 "1360-1370" ///
	5 "1370-1380" 6 ">1380"
	label values decade decadel
	label values allnot365flag allnot365flagl
	label values p95flag p95flagl
	cd "F:\Master\These\Data\GIS"
	save "stations.dta", replace 
	
	keep if miladi_start_year<=1988
	keep if allnot365flag==0
	codebook station
	save "station_60.dta", replace
	keep if start_year<=1340
	save "station_16.dta", replace

use `ctemp', clear


cd "F:\Master\These\Data\Weather"
save totalweather.dta, replace


/*Monthly weather data*/
clear
cd "F:\Master\These\Data\Weather"
import excel "F:\Master\These\Data\Weather\Monthly_weather.xlsx", sheet("Sheet1") firstrow

rename استان province_name
label variable province_name "province name in Farsi"
rename syear shamsiyear
rename smonth shamsimonth
rename prec_GIDS prec
label variable prec "Monthly precipitation"

collapse (mean) tmin (mean) tmax (mean) tmean (mean) prec, by(province_name shamsiyear shamsimonth)

gen province="P0001" if province_name=="آذربايجان شرقي"
label variable province "province code"
replace province="P0002" if province_name=="آذربايجان غربي"
replace province="P0003" if province_name=="اردبيل"
replace province="P0004" if province_name=="اصفهان"
replace province="P0005" if province_name=="البرز"
replace province="P0006" if province_name=="ايلام"
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
replace ADM1_EN="Ilam" if province_name=="ايلام"
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

encode province, gen(province_code)
drop province
rename province_code province

encode province_name, gen(province_name_temp)
drop province_name
rename province_name_temp province_name


save monthly_weather.dta, replace
