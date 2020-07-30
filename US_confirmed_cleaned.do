import delimited "/Users/zwanran/Library/Application Support/Stata/git/covid-19/data/us_confirmed.csv", clear 

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

gen new_case = case[_n] - case[_n-1] if month != 1

label variable month "Month"
label variable new_case "New Case"
label variable admin2 "County/City"
