clear
cd "F:\Master\These\Data\GIS"
shp2dta using irn_admbnda_adm1_unhcr_20190514, database(irandb) ///
coordinates(irancoord) genid(id) genc(c) replace
