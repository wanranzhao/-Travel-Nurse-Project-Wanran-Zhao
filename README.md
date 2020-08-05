# Travel-Nurse-Project-Wanran-Zhao
 
## Raw Data
The raw data, 'us_confirmed_raw.csv' and 'us_deaths_raw.csv' are acquired from https://github.com/datasets/covid-19.

##  Processed Data and do.file
The US_case.dta and US_death.dta contain confirmed cases and deaths (new and total) by county/city and month, separately. Corresponding do.files record specific manipulation steps.
Cases are counted at the end of each month except at 2020-07-28 for July, where the information of available time series ends.


Update 08-05

Find the output and r code in the folder `Second Data Process`.

## Cross-checking
Our data of accumulative deaths and confirmed cases in July seems a little off. (See `cross-check-against-aggregate-result.csv`)
It might be because that the raw data was retrieved in July while the reference data of national stats was retrieved in August. We can update the raw data later to see if the divergence vanishes.

## Further Cleaned Data
I dropped Puerto Rico and merged deaths & confirmed cases in to one file: `case-&-death-by-month-cleaned.csv`.
