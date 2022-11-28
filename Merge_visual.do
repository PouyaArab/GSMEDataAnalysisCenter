clear
cd "F:\Master\These\graphs_and_tables"
use "F:\Master\These\Data\Merge\Merged.dta"
cd "F:\Master\These\graphs_and_tables\Merge"

graph bar (mean) tbin* ///
, title("Distribution of Daily Mean Temperatures (◦C) in a week")  /// 
note("Source: Iran Meteorological Organization, 1389-1397", span) ///
name(m1,replace)
graph export "Distribution of weekly Daily Mean Temperatures_new.png" , replace  as(png) name(m1)

tempfile temp3
save `temp3'
	keep tbin*
	forvalues i=0/9{
	    egen ttbin`i'=mean(tbin`i')
	}
	keep ttbin*
	gen row=_n
	keep if row==1
	reshape long ttbin, i(row) j(tbin)
	label define tbinl 0 "<-5" 1 "-5-0" 2 "0-5" 3 "5-10" ///
	4 "10-15" 5 "15-20" 6 "20-25" 7 "25-30" 8 "30-35" 9 ">35"
	label values tbin tbinl
	drop row
	graph bar (mean) ttbin, over(tbin) blabel(bar, format(%5.0g)) ytitle("") ///
	title("Distribution of Daily Mean Temperatures (◦C) in a week") name(bin1, replace)
	graph export "Distribution of weekly Daily Mean Temperatures_new.png" , replace  as(png) name(bin1)
	
use `temp3', clear
	
graph bar (mean) tempbin, over(bin) title("Distribution of Weekly Daily Mean Temperatures") ///
note("Source: Iran Meteorological Organization, 1389-1396")


tempfile temp3
save `temp3'
	collapse dailytemp, by(province totalweekno shamsiday deaths age gender)
	


	gen bin= 0 if dailytemp <-10
	replace bin= 1 if dailytemp >=-10 & dailytemp <0
	replace bin = 2 if dailytemp>=0 & dailytemp <10
	replace bin = 3 if dailytemp >=10 & dailytemp <20
	replace bin = 4 if dailytemp>=20 & dailytemp < 30
	replace bin = 5 if dailytemp >=30 & dailytemp <40
	replace bin = 6 if dailytemp >=40 

	label values bin binl
	by totalweekno province bin, sort : gen tempbin= _N
	by totalweekno province tempbin, sort: gen cnt= _N
	graph bar (mean) tempbin, over(bin) title("Distribution of Weekly Daily Mean Temperatures") ///
	note("Source: Iran Meteorological Organization, 1389-1396")
use `temp3', clear