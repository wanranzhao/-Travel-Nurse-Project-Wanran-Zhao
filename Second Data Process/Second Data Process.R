#loading packages
library(haven)
library(tidyverse)



#merging clean data
US_case_cleaned <- read_dta("~/Desktop/-Travel-Nurse-Project-Wanran-Zhao/US_case_cleaned.dta")
US_death_cleaned <- read_dta("~/Desktop/-Travel-Nurse-Project-Wanran-Zhao/US_death_cleaned.dta")

total<-merge(US_case_cleaned, US_death_cleaned,
             by = c("uid","fips","admin2","lat","combined_key","date","provincestate","month"))
total<-total %>% 
  select(-v12) %>%
  mutate(new_case = if_else(is.na(new_case), 0, new_case)) %>%
  mutate(new_death = if_else(is.na(new_death), 0, new_death))



#national data for reference
time_series_19_covid_combined <- read_csv("data/time-series-19-covid-combined.csv")
agg <- time_series_19_covid_combined %>%
  filter(`Country/Region`=="US") %>%
  mutate(Date=as.factor(Date)) %>%
  filter(Date %in% c("2020-01-31","2020-02-29","2020-03-31","2020-04-30","2020-05-31","2020-06-30","2020-07-28")) %>%
  mutate(month=case_when(Date=="2020-01-31"~1,
                         Date=="2020-02-29"~2,
                         Date=="2020-03-31"~3,
                         Date=="2020-04-30"~4,
                         Date=="2020-05-31"~5,
                         Date=="2020-06-30"~6,
                         Date=="2020-07-28"~7))



#cross-checking confirmed cases against aggregated national data

agg_to_check <- matrix(rep(1:7,4),ncol=4,byrow=TRUE)
colnames(agg_to_check) <- c("Aggregated Case","Reference Case","Aggregaed Death","Reference Death")
rownames(agg_to_check) <- c("2020-01-31","2020-02-29","2020-03-31","2020-04-30","2020-05-31","2020-06-30","2020-07-28")

for (i in 1:7){
df <- total %>% filter(month==i)
print(TRUE %in% duplicated(df$combined_key)) #check if we have duplicated counts of cases; if all return FALSE then we are good
agg_to_check[i,1]<-sum(df$case)
}
agg_to_check[,2]<-agg$Confirmed 

for (i in 1:7){
  df <- total %>% filter(month==i)
  print(TRUE %in% duplicated(df$combined_key)) #check if we have duplicated counts of cases; if all return FALSE then we are good
  agg_to_check[i,3]<-sum(df$death)
  }
agg_to_check[,4]<-agg$Deaths

agg_to_check #Data in July seems off
#It might be because that the raw data was retrieved in July while the reference data was retrieved in August
#We can update the raw data later to see if the divergence vanishes


#Further process county-level data
total_clean <- total %>% 
  filter(provincestate!="Puerto Rico") %>%
  drop_na(admin2)

#Save output
write.csv(total_clean, "case-&-death-by-month-cleaned")
write.csv(agg_to_check, "cross-check-against-aggregate-result")
