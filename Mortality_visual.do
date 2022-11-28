clear
use "F:\Master\These\Data\WeeklyDeaths\aggregateddeaths.dta"
cd "F:\Master\These\graphs_and_tables\Mortality"

drop if shamsiyear >1397
tempfile mtemp
save `mtemp'

	egen maletotal=sum(deaths) if gender==2, by(age)
	egen femtotal= sum(deaths) if gender==1, by(age)
	egen maletotal_temp=min(maletotal), by(age)
	egen femtotal_temp=max(femtotal), by(age)
	drop maletotal femtotal
	rename maletotal_temp maletotal
	rename femtotal_temp femtotal
	keep if week==146
	*replace maletotal= maletotal/1000000
	*replace femtotal= femtotal/1000000
	replace maletotal=-maletotal
	#delimit ;
	twoway
	bar maletotal age, horizontal xvarlab(Males)
	||
	bar femtotal age, horizontal xvarlab(Females)
	||
	, ylabel(0(1)20, angle(horizontal) valuelabel labsize(*.8))
	xtitle("Number of deaths") ytitle("Age")
	legend(label(1 Males) label(2 Females))
	note("Source: National Organization for Civil Registration (NOCR), 2009-2017", span);
	#delimit cr
	graph export "age pyramid.png" , replace  as(png) 
use `mtemp', clear	

graph bar (sum) deaths, over(season) over(ageclass) ytitle(N. of deaths)
graph export "N. of deaths.png" , replace  as(png)
