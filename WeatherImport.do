/*weather data import*/
clear
cd"F:\Master\These\Data\Weather"

*importing from excel
import excel "F:\Master\These\Data\Weather\raw-weather.xlsx", sheet("01") firstrow
save 1.dta, replace
clear


import excel "F:\Master\These\Data\Weather\raw-weather.xlsx", sheet("02") firstrow
save 2.dta, replace
clear

import excel "F:\Master\These\Data\Weather\raw-weather.xlsx", sheet("03") firstrow
save 3.dta, replace
clear

import excel "F:\Master\These\Data\Weather\raw-weather.xlsx", sheet("04") firstrow
save 4.dta, replace
clear


*appending:

append using 1.dta 2.dta 3.dta 4.dta
save totalweather.dta, replace
clear
cd "F:\Master\These\Data\Weather"
use 

