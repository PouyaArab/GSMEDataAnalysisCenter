clear
cd "F:\Master\These\Data\Weather"
use totalweather.dta
cd "F:\Master\These\graphs_and_tables\Weather\Miladi"


drop if year==miladi_start_year


drop if allnot365flag!=0



keep if miladi_start_year<=1961
drop if year==1960 | year==2018
sort stationid year mont day
egen tmean_annual_miladi= mean(tmean), by(year)

gen t=0
replace t=1 if tmean>=32
egen tmean32_station= sum(t), by(year stationid)
egen tmean32 = mean(tmean32_station), by(year)
drop t
*egen tmax32_station= count (datemiladi) if tmax>=32, by(year stationid)
*replace tmax32_station=0 if tmax32_station==.
*egen tmax32 = mean(tmax32_station), by(year)
egen miladi_tmean_monthly= mean(tmean), by(year month)
egen miladi_tmean_month= mean(tmean), by(month)
gen miladi_tmean_monthly_demeaned= miladi_tmean_monthly - miladi_tmean_month

egen miladi_annual_prec_station=sum(rrr24), by(stationid year)
egen miladi_annual_prec= mean(miladi_annual_prec_station), by (year)
*egen rain_cnt= count(rrr24) if rrr24>0, by(year stationid)
gen t=0
replace t=1 if rrr24>1
egen nprec_station= sum(t), by(year stationid)
egen nprec = mean(nprec_station), by(year)
drop t

gen t=0
replace t=1 if rrr24==0
egen ndry_station= sum(t), by(year stationid)
egen ndry= mean(ndry_station), by(year)
drop t




graph twoway (scatter tmean_annual_miladi year)(lfit tmean_annual_miladi year) ///
, ytitle("Mean Temperature (◦C)") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1961-2018", span) ///
name(miladi_tmean1,replace) legend(off)
graph export "Annual mean temperature over years.png" , replace  as(png) name(miladi_tmean1)

graph twoway (scatter tmean32 year)(lfit tmean32 year) ///
, ytitle("N. of Days Above 32◦C") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1961-2018", span) ///
name(miladi_tmax32,replace) legend(off)
graph export "N. of Days Above 32◦C.png" , replace  as(png) name(miladi_tmax32)


graph twoway (scatter miladi_tmean_monthly_demeaned year) ///
(lfit miladi_tmean_monthly_demeaned year), ///
by(month) ///
ytitle("demeaned temperature (◦C)") ///
name(milad_month,replace) legend(off)
graph export "Monthly mean temperature (demeaned) across months.png" , replace  as(png)



graph twoway (scatter miladi_annual_prec year)(lfit miladi_annual_prec year) ///
, ytitle("Annual precipitation (mm)") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1961-2018", span) ///
name(miladi_precep,replace) legend(off)
graph export "Annual precipitation (mm).png" , replace  as(png) name(miladi_precep)


graph twoway (scatter nprec year)(lfit nprec year) ///
, ytitle("N. of days with precipitation") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1961-2018", span) ///
name(nrainy,replace) legend(off)
graph export "N. of days with precipitation.png" , replace  as(png) name(nrainy)



graph twoway (scatter ndry year)(lfit ndry year) ///
, ytitle("N. of days without precipitation") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1961-2018", span) ///
name(ndry,replace) legend(off)
graph export "N. of days without precipitation.png" , replace  as(png) name(ndry)


*humidity:
egen um_annual= mean(um), by (year) 


graph twoway (scatter um_annual year)(lfit um_annual year) ///
,  ytitle("Relative humidity(%)") xtitle("year") /// 
note("Source: Iran Meteorological Organization, 1961-2018", span) ///
name(milad_humid,replace) legend(off)
graph export "Humidity over years.png" , replace  as(png)



codebook station
codebook province


tempfile mtemp
save `mtemp'
	keep if miladi_start_year<=1987
	drop if year<1988| year==2018
	sort stationid year mont day
	egen tmean_annual_miladi= mean(tmean), by(year)

	gen t=0
	replace t=1 if tmean>=32
	egen tmean32_station= sum(t), by(year stationid)
	egen tmean32 = mean(tmean32_station), by(year)
	drop t
	*egen tmax32_station= count (datemiladi) if tmax>=32, by(year stationid)
	*replace tmax32_station=0 if tmax32_station==.
	*egen tmax32 = mean(tmax32_station), by(year)
	egen miladi_tmean_monthly= mean(tmean), by(year month)
	egen miladi_tmean_month= mean(tmean), by(month)
	gen miladi_tmean_monthly_demeaned= miladi_tmean_monthly - miladi_tmean_month

	egen miladi_annual_prec_station=sum(rrr24), by(stationid year)
	egen miladi_annual_prec= mean(miladi_annual_prec_station), by (year)
	*egen rain_cnt= count(rrr24) if rrr24>0, by(year stationid)
	gen t=0
	replace t=1 if rrr24>1
	egen nprec_station= sum(t), by(year stationid)
	egen nprec = mean(nprec_station), by(year)
	drop t

	gen t=0
	replace t=1 if rrr24==0
	egen ndry_station= sum(t), by(year stationid)
	egen ndry= mean(ndry_station), by(year)
	drop t




	graph twoway (scatter tmean_annual_miladi year)(lfit tmean_annual_miladi year) ///
	, ytitle("Mean Temperature (◦C)") xtitle("year") /// 
	note("Source: Iran Meteorological Organization, 1988-2018", span) ///
	name(miladi_tmean1_30,replace) legend(off)
	graph export "Annual mean temperature over years_30.png" , replace  as(png) name(miladi_tmean1_30)

	graph twoway (scatter tmean32 year)(lfit tmean32 year) ///
	, ytitle("N. of Days Above 32◦C") xtitle("year") /// 
	note("Source: Iran Meteorological Organization, 1988-2018", span) ///
	name(miladi_tmax32_30,replace) legend(off)
	graph export "N. of Days Above 32◦C_30.png" , replace  as(png) name(miladi_tmax32_30)
	

	graph twoway (scatter miladi_tmean_monthly_demeaned year) ///
	(lfit miladi_tmean_monthly_demeaned year), ///
	by(month) ///
	ytitle("demeaned temperature (◦C)") ///
	name(milad_month_30,replace) legend(off)
	graph export "Monthly mean temperature (demeaned) across months_30.png" , replace  as(png)
	


	graph twoway (scatter miladi_annual_prec year)(lfit miladi_annual_prec year) ///
	, ytitle("Annual precipitation (mm)") xtitle("year") /// 
	note("Source: Iran Meteorological Organization, 1988-2018", span) ///
	name(miladi_precep_30,replace) legend(off)
	graph export "Annual precipitation (mm)_30.png" , replace  as(png) name(miladi_precep_30)
	

	graph twoway (scatter nprec year)(lfit nprec year) ///
	, ytitle("N. of days with precipitation") xtitle("year") /// 
	note("Source: Iran Meteorological Organization, 1988-2018", span) ///
	name(nrainy_30,replace) legend(off)
	graph export "N. of days with precipitation_30.png" , replace  as(png) name(nrainy_30)



	graph twoway (scatter ndry year)(lfit ndry year) ///
	, ytitle("N. of days without precipitation") xtitle("year") /// 
	note("Source: Iran Meteorological Organization, 1988-2018", span) ///
	name(ndry_30,replace) legend(off)
	graph export "N. of days without precipitation_30.png" , replace  as(png) name(ndry_30)
	

	*humidity:
	egen um_annual= mean(um), by (year) 


	graph twoway (scatter um_annual year)(lfit um_annual year) ///
	,  ytitle("Relative humidity(%)") xtitle("year") /// 
	note("Source: Iran Meteorological Organization, 1988-2018", span) ///
	name(milad_humid_30,replace) legend(off)
	graph export "Humidity over years_30.png" , replace  as(png)



	codebook station
	codebook province
	
use `mtemp', clear