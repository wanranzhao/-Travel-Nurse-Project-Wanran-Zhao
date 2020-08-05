import delimited "/Users/zwanran/Library/Application Support/Stata/git/covid-19/data/us_deaths.csv", clear 


drop iso2 iso3 code3 countryreg

destring date, replace ignore("-")
egen OK = anymatch(date), values(20200131 20200229 20200331 20200430 20200531 20200630 20200728)
keep if OK
drop OK

gen month = 1 if date == 20200131
replace month = 2 if date == 20200229
replace month = 3 if date == 20200331
replace month = 4 if date == 20200430
replace month = 5 if date == 20200531
replace month = 6 if date == 20200630
replace month = 7 if date == 20200728

gen death=case
gen new_death = death[_n] - death[_n-1] if month != 1
drop case

label variable month "Month"
label variable death "Death"
label variable new_death "New Death"
label variable admin2 "County/City"
