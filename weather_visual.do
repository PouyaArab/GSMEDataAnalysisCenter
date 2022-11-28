clear
cd "F:\Master\These\Data\Weather"
use totalweather.dta
cd "F:\Master\These\graphs_and_tables"


drop if shamsiyear==start_year


tempfile temp2
save `temp2'

	gen temp_beta=0
	collapse (max) temp_beta, by(ADM1_EN)
	cd "F:\Master\These\Data\GIS"
	merge 1:1 ADM1_EN using irandb
	spmap using irancoord , id(id) ///
	title("Distribution of weather monitoring stations") ///
	note("Source: Iran Meteorological Organization, 1338-1397", span) ///
	point(data(stations) xcoord(Longitude) ycoord(Latitude) size(vsmall)) ///
	name(st1, replace)
	cd "F:\Master\These\graphs_and_tables\Weather"
	graph export "Stations.png", replace as(png)
	cd "F:\Master\These\Data\GIS"
	spmap using irancoord , id(id) ///
	title("Distribution of weather monitoring stations") ///
	note("Source: Iran Meteorological Organization, 1338-1397", span) ///
	point(data(stations) xcoord(Longitude) ycoord(Latitude) ///
	legenda(on) by(decade) fc(RdBu)) ///
	name (st2, replace)
	cd "F:\Master\These\graphs_and_tables\Weather"
	graph export "Stations_by_startyear.png", replace as(png)
	cd "F:\Master\These\Data\GIS"
	spmap using irancoord , id(id) ///
	title("Distribution of weather monitoring stations") ///
	note("Source: Iran Meteorological Organization, 1338-1397", span) ///
	point(data(stations)  xcoord(Longitude) ycoord(Latitude) ///
	by(allnot365flag) fc(Oranges) legenda(on)) ///
	name (st3, replace)
	cd "F:\Master\These\graphs_and_tables\Weather"
	graph export "Stations_by_allnot365flag.png", replace as(png)
	

use `temp2', clear

tempfile temp2
save `temp2'
	keep if start_year<=1340
	drop if allnot365flag!=0
	codebook station
	gen temp_beta=0
	collapse (max) temp_beta, by(ADM1_EN)
	cd "F:\Master\These\Data\GIS"
	merge 1:1 ADM1_EN using irandb
	spmap using irancoord , id(id) ///
	title("Distribution of weather monitoring stations") ///
	note("Source: Iran Meteorological Organization, 1338-1397", span) ///
	point(data(station_16) xcoord(Longitude) ycoord(Latitude) size(small)) ///
	name(s16, replace)
	cd "F:\Master\These\graphs_and_tables\Weather"
	graph export "Stations_full_report.png", replace as(png)
use `temp2', clear

tempfile temp2
save `temp2'
	keep if miladi_start_year<=1988
	drop if allnot365flag!=0
	codebook station
	gen temp_beta=0
	collapse (max) temp_beta, by(ADM1_EN)
	cd "F:\Master\These\Data\GIS"
	merge 1:1 ADM1_EN using irandb
	spmap using irancoord , id(id) ///
	title("Distribution of weather monitoring stations") ///
	note("Source: Iran Meteorological Organization, 1367-1397", span) ///
	point(data(station_60) xcoord(Longitude) ycoord(Latitude) size(small)) ///
	name(s60, replace)
	cd "F:\Master\These\graphs_and_tables\Weather"
	graph export "Stations_full_report_60.png", replace as(png)
use `temp2', clear

*keep if ADM1_EN=="West Azerbaijan"
*keep if AL==8


egen tmean_annual=mean(tmean), by (shamsiyear) 
egen tmean_monthly= mean(tmean), by(shamsiyear shamsimonth)
egen tmean_weighted_annual=mean(tmean_monthly), by (shamsiyear)
egen tmean_month= mean(tmean), by(shamsimonth)
gen tmean_monthly_demeaned= tmean_monthly - tmean_month
egen cnt= count(tmean), by (shamsiyear shamsimonth)
egen cnt1= count(tmean), by (shamsiyear)





egen seasonal_precep= sum(rrr24), by(shamsiyear season station)
label variable seasonal_precep "total seasonal precipitation in each station (mm)"
egen season_mean_temp= mean(tmean), by(shamsiyear season station)
label variable season_mean_temp "mean seasonal temperature in each station (C)"
egen annual_prec= sum(rrr24), by(shamsiyear station)
label variable annual_prec "Annual precipitation in each station (mm)"
label variable tmean_annual "annual mean temperature in each station (C)"
label variable start_year "The year the station has been established"

/*
graph twoway (scatter tmean_annual shamsiyear)(lfit tmean_annual shamsiyear) if start_year==1363 ///
, title("Annual mean temperature over years for Mahabad weather Station", size(4)) ///
ytitle("Mean Temperature (C)") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1364-1396", span) ///
name(mah,replace) 
graph export "Urmia\Annual mean temperature over years for Mahabad.png" , replace  as(png) name(mah)


graph twoway (scatter annual_prec shamsiyear)(lfit annual_prec shamsiyear) if start_year==1363 ///
, title("Annual precipitation over years for Mahabad weather Station", size(4)) ///
ytitle("Precipitation (mm)") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1364-1396", span) ///
name(mah_prec,replace) 
graph export "Urmia\Annual precipitation over years for Mahabad weather Station.png" , replace  as(png) name(mah_prec)

graph twoway (scatter tmean_annual shamsiyear)(lfit tmean_annual shamsiyear) if start_year==1364 ///
, title("Annual mean temperature over years for Tekab weather Station", size(4)) ///
ytitle("Mean Temperature (C)") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1365-1396", span) ///
name(mah,replace) 
graph export "Urmia\Annual mean temperature over years for Tekab.png" , replace  as(png) name(mah)


graph twoway (scatter annual_prec shamsiyear)(lfit annual_prec shamsiyear) if start_year==1364 ///
, title("Annual precipitation over years for Tekab weather Station", size(4)) ///
ytitle("Precipitation (mm)") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1365-1396", span) ///
name(tek_prec,replace) 
graph export "Urmia\Annual precipitation over years for Tekab weather Station.png" , replace  as(png) name(tek_prec)
*/





drop if allnot365!=0
drop if shamsiyear==1338
drop if shamsiyear==1397

graph twoway (scatter tmean_annual shamsiyear)(lfit tmean_annual shamsiyear) ///
, title("Annual mean temperature over years") ///
ytitle("Mean Temperature (C)") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1339-1396", span) ///
name(wg1,replace)
graph export "Weather\Annual mean temperature over years.png" , replace  as(png) name(wg1)



graph twoway (scatter tmean_weighted_annual shamsiyear)(lfit tmean_weighted_annual shamsiyear) ///
, title("Annual weighted mean temperature over years") ///
ytitle("Mean Temperature (C)") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1339-1396", span) ///
name(wg2,replace)
graph export "Weather\Annual weighted mean temperature over years.png" , replace  as(png) name(wg2)




graph twoway (scatter cnt1 shamsiyear) ///
, title("Number of observation over time") ///
ytitle("Number of observation") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1339-1396", span) ///
name(wg3,replace)
graph export "Weather\Number of Observation.png" , replace  as(png)


graph twoway (scatter tmean_monthly_demeaned shamsiyear)(lfit tmean_monthly_demeaned shamsiyear), ///
by(shamsimonth) ///
ytitle("demeaned temperature (◦C)") ///
name(wg4,replace)
graph export "Weather\Monthly mean temperature (demeaned) across months.png" , replace  as(png)


*precipitation:
egen rrr24_annual= mean(rrr24), by (shamsiyear) 
egen rrr24_monthly= mean(rrr24), by(shamsiyear_month)
egen rrr24_weighted_annual=mean(rrr24_monthly), by (shamsiyear)
egen rrr24_month= mean(rrr24), by(shamsimonth)
gen rrr24_monthly_demeaned= rrr24_monthly - rrr24_month

graph twoway (scatter rrr24_annual shamsiyear)(lfit rrr24_annual shamsiyear) ///
, title("Annual daily mean precipitation over years") ///
ytitle("precipitation (mm)") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1339-1396", span) ///
name(wg5,replace)
graph export "Weather\daily precipitation over years.png" , replace  as(png)


graph twoway (scatter rrr24_monthly_demeaned shamsiyear)(lfit rrr24_monthly_demeaned shamsiyear) ///
, ytitle("precipitation (mm)") ///
by(shamsimonth) ///
name(wg6,replace)
graph export "Weather\daily precipitation (demeaned) across months.png" , replace  as(png)




*humidity:
egen um_annual= mean(um), by (shamsiyear) 


graph twoway (scatter um_annual shamsiyear)(lfit um_annual shamsiyear) ///
, title("Annual daily mean humidity over years") ///
ytitle("Relative humidity(%)") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1339-1396", span) ///
name(wg7,replace)
graph export "Weather\mean daily humidity over years.png" , replace  as(png)


*number of station in each year:
by shamsiyear stationid, sort: gen nvals = _n == 1
by shamsiyear: replace nvals = sum(nvals)
by shamsiyear: replace nvals = nvals[_N]
graph twoway line nvals shamsiyear, ytitle("Number of weather stations") ///
xtitle("Shamsi year") name(wg3_1, replace) ///
note("Source: Iran Meteorological Organization, 1339-1396", span) ///
xlabel(#8) ylabel(#8)
graph export "Weather\number of stations.png", replace as (png)
drop nvals


drop tmean_annual tmean_monthly tmean_weighted_annual tmean_month ///
tmean_monthly_demeaned cnt cnt1
drop rrr24_annual rrr24_month rrr24_monthly rrr24_monthly_demeaned ///
rrr24_weighted_annual
drop um_annual





tempfile temp2
save `temp2'
	keep if shamsiyear >=1370
	drop if start_year >1370
	drop if partialyearflag==1
	egen annual_tmean =  mean(tmean) ,by(shamsiyear province)
	gen temp_beta= 0
	*fillin province shamsiyear
	forvalues i = 1/31{
			reg annual_tmean shamsiyear if province==`i', robust
			replace temp_beta= _b[shamsiyear] if province==`i'		    
	}
	
	collapse (max) temp_beta, by(ADM1_EN)
	cd "F:\Master\These\Data\GIS"
	merge 1:1 ADM1_EN using irandb
	
	spmap temp_beta using irancoord , id(id) ///
	title("Mean annual Temperature changes (◦C) in Iran by provinces", size(4)) ///
	fcolor(Reds2) ///
	note("Source: Iran Meteorological Organization, 1370-1396", span) ///
	name(maps1_p,replace) clnumber(6) ///
	label(data(irandb) xcoord(x_c)  ycoord(y_c)  label(ADM1_EN) size(0.8))
	cd "F:\Master\These\graphs_and_tables"
	graph export "Weather\Mean annual Temperature change in Iran by provinces_removed partialyearflag.png", replace as (png)

use `temp2', clear

tempfile temp2
save `temp2'

	*by stationid (shamsiyear), sort: gen nvals = _n == 1
	*gen cum = sum(nvals)
	*drop if cum >50
	keep if shamsiyear >=1370
	drop if SDflag>=1 | meanflag >=1 
	drop if start_year >1370
	

	egen annual_tmean =  mean(tmean) ,by(shamsiyear province)
	gen temp_beta= 0
	foreach var of province {
		reg annual_tmean shamsiyear if province==var, robust
		replace temp_beta= _b[shamsiyear] if province==var
	
	}
	
	collapse (max) temp_beta, by(ADM1_EN)
	cd "F:\Master\These\Data\GIS"
	merge 1:1 ADM1_EN using irandb
	
	spmap temp_beta using irancoord , id(id) ///
	title("Mean annual Temperature changes (C) in Iran", size(4)) ///
	fcolor(Reds2) ///
	note("Source: Iran Meteorological Organization, 1370-1396", span) ///
	name(maps2,replace) clnumber(6) ///
	label(data(irandb) xcoord(x_c)  ycoord(y_c)  label(ADM1_EN) size(0.8))
	cd "F:\Master\These\graphs_and_tables"
	graph export "Weather\Mean annual Temperature change in Iran by provinces_2.png", replace as (png)

use `temp2', clear

tempfile temp2
save `temp2'

	*by stationid (shamsiyear), sort: gen nvals = _n == 1
	*gen cum = sum(nvals)
	*drop if cum >50
	keep if shamsiyear >=1370

	drop if start_year >1370
	
	keep if shamsimonth==4 | shamsimonth==5 | shamsimonth == 6
	egen summer_tmean =  mean(tmean) ,by(shamsiyear province)
	gen temp_beta= 0
	forvalues i = 1/31{
		reg summer_tmean shamsiyear if province==`i', robust
		replace temp_beta= _b[shamsiyear] if province==`i'
	
	}
	
	collapse (max) temp_beta, by(ADM1_EN)
	cd "F:\Master\These\Data\GIS"
	merge 1:1 ADM1_EN using irandb
	
	spmap temp_beta using irancoord , id(id) ///
	title("Mean annual Temperature changes (C) in summer in Iran by provinces", size(4)) ///
	fcolor(Reds2) ///
	note("Source: Iran Meteorological Organization, 1370-1396", span) ///
	name(maps3,replace) clnumber(6) ///
	label(data(irandb) xcoord(x_c)  ycoord(y_c)  label(ADM1_EN) size(0.8))
	cd "F:\Master\These\graphs_and_tables"
	graph export "Weather\Mean annual Temperature change in summers in Iran by provinces.png", replace as (png)

use `temp2', clear



tempfile temp2
save `temp2'

	*by stationid (shamsiyear), sort: gen nvals = _n == 1
	*gen cum = sum(nvals)
	*drop if cum >50
	keep if shamsiyear >=1370
	
	drop if start_year >1370
	
	keep if shamsimonth==10 | shamsimonth==11 | shamsimonth == 12
	egen summer_tmean =  mean(tmean) ,by(shamsiyear province)
	gen temp_beta= 0
	forvalues i = 1/31{
		reg summer_tmean shamsiyear if province==`i', robust
		replace temp_beta= _b[shamsiyear] if province==`i'
	
	}
	
	collapse (max) temp_beta, by(ADM1_EN)
	cd "F:\Master\These\Data\GIS"
	merge 1:1 ADM1_EN using irandb
	
	spmap temp_beta using irancoord , id(id) ///
	title("Mean annual Temperature changes (C) in winter in Iran by provinces", size(4)) ///
	fcolor(Reds2) ///
	note("Source: Iran Meteorological Organization, 1370-1396", span) ///
	name(maps4,replace) clnumber(6) ///
	label(data(irandb) xcoord(x_c)  ycoord(y_c)  label(ADM1_EN) size(0.8))
	cd "F:\Master\These\graphs_and_tables"
	graph export "Weather\Mean annual Temperature change in winter in Iran by provinces.png", replace as (png)

use `temp2', clear




/*restricting data to the first 50 station ids*/
by stationid (shamsiyear), sort: gen nvals = _n == 1
gen cum = sum(nvals)
drop if cum >50
drop nvals

egen tmean_annual=mean(tmean), by (shamsiyear)
label variable tmean_annual "annual mean temperature"

graph twoway (scatter tmean_annual shamsiyear)(lfit tmean_annual shamsiyear) ///
, title("Annual mean temperature over years (for the first 50 stations)", size(4)) ///
ytitle("Mean Temperature (C)") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1339-1396", span) ///
name(wg1_50,replace)
graph export "Weather\Annual mean temperature over years (for the first 50 stations).png" , replace  as(png) name(wg1_50)

egen rrr24_annual= mean(rrr24), by (shamsiyear)
label variable rrr24_annual "annual daily mean perecipitation"

graph twoway (scatter rrr24_annual shamsiyear)(lfit rrr24_annual shamsiyear) ///
, title("Annual daily mean precipitation over years (for the first 50 stations)", size(4)) ///
ytitle("precipitation (mm)") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1339-1396", span) ///
name(wg5,replace)
graph export "Weather\daily precipitation over years (for the first 50 stations).png" , replace  as(png)

egen um_annual= mean(um), by (shamsiyear) 
label variable um_annual "Annual daily mean relative humidity"

graph twoway (scatter um_annual shamsiyear)(lfit um_annual shamsiyear) ///
, title("Annual daily mean humidity over years (for the first 50 stations)", size(4)) ///
ytitle("Relative humidity(%)") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1339-1396", span) ///
name(wg7,replace)
graph export "Weather\mean daily humidity over years (for the first 50 stations).png" , replace  as(png)




*Density Comparison:
kdensity tmean if shamsiyear == 1355, ///
addplot(kdensity tmean if shamsiyear == 1395) ///
legend(ring(0) pos(2) label(1 "1355") label(2 "1395")) ///
title("Density comparison for the Dey 1'st'", size(4)) xtitle("mean temperature (C)") ///
name (kd1, replace) note("Source: Iran Meteorological Organization", span) 
graph export "Weather\Density comparison for the Dey 1'st.png" , replace  as(png)


tempfile temp2
save `temp2'

	keep if shamsimonth==10
	keep if shamsiday<11
	egen t1 = mean(tmean), by(stationid shamsiyear)
	kdensity t1 if shamsiyear == 1355, ///
	addplot(kdensity t1 if shamsiyear == 1395) ///
	legend(ring(0) pos(2) label(1 "1355") label(2 "1395")) ///
	title("Density comparison for the first 10 days of Dey", size(4)) xtitle("mean temperature (C)") ///
	name (kd2, replace) note("Source: Iran Meteorological Organization", span) 
	graph export "Weather\Density comparison for the first 10 days of Dey.png" , replace  as(png)
	drop t1
use `temp2', clear

tempfile temp2
save `temp2'
	keep if shamsimonth==10
	keep if shamsiday<21
	egen t1 = mean(tmean), by(stationid shamsiyear)
	kdensity t1 if shamsiyear == 1355, ///
	addplot(kdensity t1 if shamsiyear == 1395) ///
	legend(ring(0) pos(2) label(1 "1355") label(2 "1395")) ///
	title("Density comparison for the first 20 days of Dey", size(4)) xtitle("mean temperature (C)") ///
	name (kd3, replace) note("Source: Iran Meteorological Organization", span) 
	graph export "Weather\Density comparison for the first 20 days of Dey.png" , replace  as(png)
	drop t1
use `temp2', clear
egen t1 = mean(tmean), by(stationid shamsiyear shamsimonth)
kdensity t1 if shamsiyear == 1355 & shamsimonth==10, ///
addplot(kdensity t1 if shamsiyear==1395 & shamsimonth==10) ///
legend(ring(0) pos(2) label(1 "1355") label(2 "1390")) ///
title("Density comparison for the month Dey", size(4)) xtitle("mean temperature (C)") ///
name (kd4, replace) note("Source: Iran Meteorological Organization", span)
graph export "Weather\Density comparison for the month Dey.png" , replace  as(png)
drop t1

tempfile temp2
save `temp2'
	gen dum5 = 1 if shamsiyear <=1395 & shamsiyear >= 1390
	replace dum5 = 0 if shamsiyear <=1360 & shamsiyear >= 1355
	keep if dum5==0 | dum5==1
	egen t1= mean(tmean), by(dum5 stationid shamsimonth)
	kdensity t1 if dum5 == 0 & shamsimonth==10, ///
	addplot(kdensity t1 if dum5 == 1 & shamsimonth==10) ///
	legend(ring(0) pos(2) label(1 "1355-1360") label(2 "1390-1395")) ///
	title("Density comparison for the month Dey (5-year average)", size(4)) xtitle("mean temperature (C)") ///
	name (kd5, replace) note("Source: Iran Meteorological Organization", span) 
	graph export "Weather\Density comparison for the month Dey (5-year average).png" , replace  as(png)
	
	kdensity t1 if dum5 == 0 & shamsimonth==4, ///
	addplot(kdensity t1 if dum5 == 1 & shamsimonth==4) ///
	legend(ring(0) pos(2) label(1 "1355-1360") label(2 "1390-1395")) ///
	title("Density comparison for the month Tir (5-year average)", size(4)) xtitle("mean temperature (C)") ///
	name (kd5_1, replace) note("Source: Iran Meteorological Organization", span) 
	graph export "Weather\Density comparison for the month Tir (5-year average).png" , replace  as(png)	
	
	egen t2= mean(tmean), by(shamsiyear shamsimonth stationid)
	kdensity t2 if dum5 == 0 & shamsimonth==4, ///
	addplot(kdensity t2 if dum5 == 1 & shamsimonth==4) ///
	legend(ring(0) pos(2) label(1 "1355-1360") label(2 "1390-1395")) ///
	title("Density comparison for the month Tir for five years", size(4)) xtitle("mean temperature (C)") ///
	name (kd5_2, replace) note("Source: Iran Meteorological Organization", span) 
	graph export "Weather\Density comparison for the month Tir for five years.png" , replace  as(png)	
	
	
	kdensity t2 if dum5 == 0 & shamsimonth==10, ///
	addplot(kdensity t2 if dum5 == 1 & shamsimonth==10) ///
	legend(ring(0) pos(2) label(1 "1355-1360") label(2 "1390-1395")) ///
	title("Density comparison for the month Dey for five years", size(4)) xtitle("mean temperature (C)") ///
	name (kd5_3, replace) note("Source: Iran Meteorological Organization", span) 
	graph export "Weather\Density comparison for the month Dey for five years.png" , replace  as(png)		
	drop dum5 t1 t2
use `temp2', clear

tempfile temp2
save `temp2'
	gen dum5 = 1 if shamsiyear <=1395 & shamsiyear >= 1390
	replace dum5 = 0 if shamsiyear <=1360 & shamsiyear >= 1355
	keep if dum5==0 | dum5==1
	keep if shamsiday <11
	egen t1= mean(tmean), by(dum5 stationid shamsimonth)
	kdensity t1 if dum5 == 0 & shamsimonth==10, ///
	addplot(kdensity t1 if dum5 == 1 & shamsimonth==10) ///
	legend(ring(0) pos(2) label(1 "1355-1360") label(2 "1390-1395")) ///
	title("Density comparison for the first 10 days of the month Dey (5-year average)", size(3)) xtitle("mean temperature (C)") ///
	name (kd6, replace) note("Source: Iran Meteorological Organization", span) 
	graph export "Weather\Density comparison for the first 10 days of the month Dey (5-year average).png" , replace  as(png)
use `temp2', clear	

egen t1=mean(tmean), by(stationid shamsiyear shamsimonth)
kdensity t1 if shamsiyear==1355, ///
addplot(kdensity t1 if shamsiyear==1395) ///
legend(ring(0) pos(2) label(1 "1355") label(2 "1395")) ///
title("Density comparison for the whole year", size(4)) xtitle("mean temperature (C)") ///
name (kd7, replace) note("Source: Iran Meteorological Organization", span)
graph export "Weather\Density comparison for the whole year.png" , replace  as(png)
drop t1

tempfile temp2
save `temp2'
	keep if cum==1
	
	graph twoway (scatter tmean_annual shamsiyear)(lfit tmean_annual shamsiyear) ///
	, title("Annual mean temperature over years (for the first station)", size(4)) ///
	ytitle("Mean Temperature (C)") xtitle("year") /// 
	note("Source: Iran Meteorological Organization, 1339-1396", span) ///
	name(wg1_1,replace)
	graph export "Weather\Annual mean temperature over years (for the first station).png" , replace  as(png) name(wg1_1)
use `temp2', clear

tempfile temp2
save `temp2'
	keep if cum==1
	graph twoway (scatter rrr24_annual shamsiyear)(lfit rrr24_annual shamsiyear) ///
	, title("Annual daily mean precipitation over years (for the first station)", size(4)) ///
	ytitle("precipitation (mm)") xtitle("year") /// 
	note("Source: Iran Meteorological Organization, 1339-1396", span) ///
	name(wg5_1,replace)
	graph export "Weather\daily precipitation over years (for the first station).png" , replace  as(png)
use `temp2', clear

tempfile temp2
save `temp2'
	keep if cum==1	
	graph twoway (scatter um_annual shamsiyear)(lfit um_annual shamsiyear) ///
	, title("Annual daily mean humidity over years (for the first station)", size(4)) ///
	ytitle("Relative humidity(%)") xtitle("year") /// 
	note("Source: Iran Meteorological Organization, 1339-1396", span) ///
	name(wg7_1,replace)
	graph export "Weather\mean daily humidity over years (for the first station).png" , replace  as(png)
use `temp2', clear





cd "F:\Master\These\graphs_and_tables\Weather"
putexcel set "weathergraphs.xlsx", sheet("wg1 & wg2", replace) replace
putexcel B2=image("Annual mean temperature over years.png")
putexcel S2=image("Annual weighted mean temperature over years.png")
putexcel set "weathergraphs.xlsx", sheet("wg3", replace) modify
putexcel B2=image("Number of Observation.png")
putexcel set "weathergraphs.xlsx", sheet("wg3_1", replace) modify
putexcel B2=image("number of stations.png")
putexcel set "weathergraphs.xlsx", sheet("wg4", replace) modify
putexcel B2=image("Monthly mean temperature (demeaned) across months.png")
putexcel set "weathergraphs.xlsx", sheet("wg5", replace) modify
putexcel B2=image("daily precipitation over years.png")
putexcel set "weathergraphs.xlsx", sheet("wg6", replace) modify
putexcel B2=image("daily precipitation (demeaned) across months.png")
putexcel set "weathergraphs.xlsx", sheet("wg7", replace) modify
putexcel B2=image("mean daily humidity over years.png")






*for shamsiyear>=1389
drop if shamsiyear<1389
*graph box cnt, over(shamsiyear)
egen pr_year= group(shamsiyear province)
egen province_annual_mean_temp= mean(tmean), by(pr_year)
egen tmean_mo_year_stid_mean=mean(tmean), by(stationid shamsimonth shamsiyear)
egen tmean_mo_stid_stid_mean=mean(tmean), by(stationid shamsimonth)
gen tmean_d= tmean_mo_year_stid_mean - tmean_mo_stid_stid_mean

graph box tmean_d, over(shamsiyear)


graph box province_annual_mean_temp, over(shamsiyear) ///
title("Provincal annual mean temperature box plot over years", size(4)) ///
ytitle("Annual mean temperature (C)") /// 
note("Source: Iran Meteorological Organization, 1389-1396", span) ///
name(wg8,replace)
graph export "wg8.png" , replace  as(png)

putexcel set "weathergraphs.xlsx", sheet("wg8", replace) modify
putexcel B2=image("wg8.png")



asdoc tabulate shamsimonth shamsiyear, column row nocf title(years and months) replace append(Weather_Tables.doc)
asdoc tab stationid shamsiyear, append(weather_tables.doc)
asdoc tabstat tmean rrr24 um, statistics(count mean sd min max p25 p50 p75) columns(statistics) by(shamsiyear) append(Weather_Tables.doc)
tabstat tmean rrr24 um, statistics(co mean sd min max p25 med p75) ///
columns(statistics) by(shamsiyear) save
mat wt1 = r(StatTotal)'
putexcel set "weather_tables.xlsx", sheet("wt1", replace) replace
putexcel A1 = matrix(wt1), names

*putexcel A1=("Car type") B1=("Freq.") C1=("Percent") using results, replace
*putexcel A2=matrix(names) B2=matrix(freq) C2=matrix(freq/r(N)) using results, modify





/*From monthly weather data*/
clear
cd "F:\Master\These\Data\Weather"
use monthly_weather.dta
cd "F:\Master\These\graphs_and_tables\Weather\monthly_data"

drop if shamsiyear==1398 | shamsiyear == 1345


tempfile temp3
save `temp3'

	egen annual_tmean =  mean(tmean) ,by(shamsiyear province)
	gen temp_beta= 0
	forvalues i = 1/31{
			reg annual_tmean shamsiyear if province==`i', robust
			replace temp_beta= _b[shamsiyear] if province==`i'		    
	}
	
	collapse (max) temp_beta, by(ADM1_EN)
	cd "F:\Master\These\Data\GIS"
	merge 1:1 ADM1_EN using irandb
	
	spmap temp_beta using irancoord , id(id) ///
	title("Annual Temperature changes (◦C) in Iran by provinces", size(4)) ///
	fcolor(Reds2) ///
	note("Source: Iran Meteorological Organization, 1346-1397", span) ///
	name(mmaps1,replace) clnumber(6) ///
	label(data(irandb) xcoord(x_c)  ycoord(y_c)  label(ADM1_EN) size(0.8))
	cd "F:\Master\These\graphs_and_tables\Weather\monthly_data"
	graph export "Annual Temperature change in Iran by provinces.png", replace as (png)

use `temp3', clear

tempfile temp3
save `temp3'

	egen annual_tmean =  mean(tmean) ,by(shamsiyear province)
	gen temp_beta= 0
	forvalues i = 1/31{
			reg annual_tmean shamsiyear if province==`i', robust
			replace temp_beta= _b[shamsiyear] if province==`i'		    
	}
	
	collapse (max) temp_beta, by(ADM1_EN)
	cd "F:\Master\These\Data\GIS"
	merge 1:1 ADM1_EN using irandb
	
	spmap temp_beta using irancoord , id(id) ///
	fcolor(Reds2) ///
	note("Source: Iran Meteorological Organization, 1966-2017", span) ///
	name(mmmaps1,replace) clnumber(6)
	cd "F:\Master\These\graphs_and_tables\Weather\Miladi"
	graph export "Annual Temperature change in Iran by provinces.png", replace as (png)

use `temp3', clear

tempfile temp3
save `temp3'


	drop if shamsiyear<1377
	
	collapse (mean) tmean, by(ADM1_EN)
	cd "F:\Master\These\Data\GIS"
	merge 1:1 ADM1_EN using irandb
	
	spmap tmean using irancoord , id(id) ///
	fcolor(Reds2) ///
	note("Source: Iran Meteorological Organization, 1997-2017", span) ///
	name(mmmaps2,replace) clnumber(6)
	cd "F:\Master\These\graphs_and_tables\Weather\Miladi"
	graph export "Average annual temperature map from 1997 to 2017.png", replace as (png)

use `temp3', clear


tempfile temp3
save `temp3'


	drop if shamsiyear<1377
	
	collapse (mean) prec, by(ADM1_EN)
	cd "F:\Master\These\Data\GIS"
	merge 1:1 ADM1_EN using irandb
	
	spmap prec using irancoord , id(id) ///
	fcolor(Blues2) ///
	note("Source: Iran Meteorological Organization, 1997-2017", span) ///
	name(mprec1,replace) clnumber(6)
	cd "F:\Master\These\graphs_and_tables\Weather\Miladi"
	graph export "Average annual precipitation map from 1997 to 2017.png", replace as (png)

use `temp3', clear


tempfile temp3
save `temp3'

	keep if shamsimonth==1 | shamsimonth==2 | shamsimonth==3
	egen annual_tmean =  mean(tmean) ,by(shamsiyear province)
	gen temp_beta= 0
	forvalues i = 1/31{
			reg annual_tmean shamsiyear if province==`i', robust
			replace temp_beta= _b[shamsiyear] if province==`i'		    
	}
	
	collapse (max) temp_beta, by(ADM1_EN)
	cd "F:\Master\These\Data\GIS"
	merge 1:1 ADM1_EN using irandb
	
	spmap temp_beta using irancoord , id(id) ///
	title("Temperature changes in the spring", size(4)) ///
	fcolor(Reds2) ///
	note("Source: Iran Meteorological Organization, 1346-1397", span) ///
	name(mmaps_spring,replace) clnumber(6)
	cd "F:\Master\These\graphs_and_tables\Weather\monthly_data"
	graph export "Temperature change in the spring in Iran by provinces.png", replace as (png)

use `temp3', clear


tempfile temp3
save `temp3'

	keep if shamsimonth==4 | shamsimonth==5 | shamsimonth==6
	egen annual_tmean =  mean(tmean) ,by(shamsiyear province)
	gen temp_beta= 0
	forvalues i = 1/31{
			reg annual_tmean shamsiyear if province==`i', robust
			replace temp_beta= _b[shamsiyear] if province==`i'		    
	}
	
	collapse (max) temp_beta, by(ADM1_EN)
	cd "F:\Master\These\Data\GIS"
	merge 1:1 ADM1_EN using irandb
	
	spmap temp_beta using irancoord , id(id) ///
	title("Temperature changes in the summer", size(4)) ///
	fcolor(Reds2) ///
	note("Source: Iran Meteorological Organization, 1346-1397", span) ///
	name(mmaps_summer,replace) clnumber(6)
	cd "F:\Master\These\graphs_and_tables\Weather\monthly_data"
	graph export "Temperature change in the summer in Iran by provinces.png", replace as (png)

use `temp3', clear

tempfile temp3
save `temp3'

	keep if shamsimonth==7 | shamsimonth==8 | shamsimonth==9
	egen annual_tmean =  mean(tmean) ,by(shamsiyear province)
	gen temp_beta= 0
	forvalues i = 1/31{
			reg annual_tmean shamsiyear if province==`i', robust
			replace temp_beta= _b[shamsiyear] if province==`i'		    
	}
	
	collapse (max) temp_beta, by(ADM1_EN)
	cd "F:\Master\These\Data\GIS"
	merge 1:1 ADM1_EN using irandb
	
	spmap temp_beta using irancoord , id(id) ///
	title("Temperature changes in the autumn", size(4)) ///
	fcolor(Reds2) ///
	note("Source: Iran Meteorological Organization, 1346-1397", span) ///
	name(mmaps_autumn,replace) clnumber(6)
	cd "F:\Master\These\graphs_and_tables\Weather\monthly_data"
	graph export "Temperature change in the autumn in Iran by provinces.png", replace as (png)

use `temp3', clear

tempfile temp3
save `temp3'

	keep if shamsimonth==10 | shamsimonth==11 | shamsimonth==12
	egen annual_tmean =  mean(tmean) ,by(shamsiyear province)
	gen temp_beta= 0
	forvalues i = 1/31{
			reg annual_tmean shamsiyear if province==`i', robust
			replace temp_beta= _b[shamsiyear] if province==`i'		    
	}
	
	collapse (max) temp_beta, by(ADM1_EN)
	cd "F:\Master\These\Data\GIS"
	merge 1:1 ADM1_EN using irandb
	
	spmap temp_beta using irancoord , id(id) ///
	title("Temperature changes in the winter", size(4)) ///
	fcolor(Reds2) ///
	note("Source: Iran Meteorological Organization, 1346-1397", span) ///
	name(mmaps_winter,replace) clnumber(6)
	cd "F:\Master\These\graphs_and_tables\Weather\monthly_data"
	graph export "Temperature change in the winter in Iran by provinces.png", replace as (png)

use `temp3', clear


egen tmean_annual= mean(tmean), by (shamsiyear)
egen tmean_month= mean(tmean), by(shamsimonth)
egen tmean_monthly= mean(tmean), by(shamsiyear shamsimonth)
gen tmean_monthly_demeaned= tmean_monthly - tmean_month
egen prec_annual= sum(prec), by (shamsiyear)

graph twoway (scatter tmean_annual shamsiyear)(lfit tmean_annual shamsiyear) ///
, title("Annual mean temperature over years") ///
ytitle("Mean Temperature (C)") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1345-1397", span) ///
name(mwg1,replace)
graph export "Annual mean temperature over years.png" , replace  as(png) name(mwg1)




graph twoway (scatter tmean_monthly_demeaned shamsiyear)(lfit tmean_monthly_demeaned shamsiyear), ///
by(shamsimonth) ///
ytitle("demeaned temperature (C)") ///
name(mwg4,replace)
graph export "Monthly mean temperature (demeaned) across months.png" , replace  as(png)





graph twoway (scatter prec_annual shamsiyear)(lfit prec_annual shamsiyear) ///
, title("Annual precipitation over years") ///
ytitle("Precipitation (mm)") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1345-1397", span) ///
name(mwg_precep,replace)
graph export "Annual perecipitation over years.png" , replace  as(png)

/*

egen tmax32= count(tmax) if tmax>=32, by(shamsiyear)

graph twoway (scatter tmax32 shamsiyear)(lfit tmax32 shamsiyear) ///
, title("Number of days above 32C over years") ///
ytitle("Number of days above 32C") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1345-1397", span) ///
name(mwg_tmax32,replace)
graph export "Number of days above 32C over years.png" , replace  as(png)

*/



tempfile temp3
save `temp3'

	egen annual_prec =  sum(prec) ,by(shamsiyear province)
	gen prec_beta= 0

	forvalues i = 1/31{
			reg annual_prec shamsiyear if province==`i', robust
			replace prec_beta= _b[shamsiyear] if province==`i'	
	}
	replace prec_beta=. if province==19
	collapse (max) prec_beta, by(ADM1_EN)
	replace prec_beta= 0-prec_beta
	cd "F:\Master\These\Data\GIS"
	merge 1:1 ADM1_EN using irandb
	
	spmap prec_beta using irancoord , id(id) ///
	title("Annual precipitation changes (mm)", size(4)) ///
	fcolor(Reds2) ///
	note("Source: Iran Meteorological Organization, 1346-1397", span) ///
	name(mmaps_prec,replace) clnumber(6) legorder(lohi)
	cd "F:\Master\These\graphs_and_tables\Weather\monthly_data"
	graph export "Annual precipitation changes (mm) in Iran by provinces.png", replace as (png)

use `temp3', clear




