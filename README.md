# White Male Effect in Perceived COVID-19 Mortality Risks
### Last updated 09/13/2021 by Ekim Luo
Using longitudinal survey data, we examined whether White men perceived the risk of dying from COVID-19 to be lower than other demographic groups, including White women, non-White men and women. 

### Versions 
- Python 3.8.11
- R 3.6.1
- conda 4.10.3

## Description of data
- The [Understanding America Study (UAS)](https://uasdata.usc.edu/index.php) launched a special COVID-19 survey between March 10, 2020 and June 22, 2021. There were a total of 28 waves with a two-week interval between waves. Wave 1 was a pilot and used different sampling methods and contained different variables, so for the purpose of this study, we excluded this wave. This means we analyzed data between April 1, 2020 and June 22, 2021. 
- The [CDC COVID-19 Case Surveillance Public Use Data](https://data.cdc.gov/Case-Surveillance/COVID-19-Case-Surveillance-Public-Use-Data/vbim-akqf) contained records from states on COVID-19 fatality cases from January 1, 2020. They also included race and gender information, which allowed us to approximate real mortality risks for these demographic groups. We analyzed data between January 1, 2020 and July 16, 2021. 
- The [U.S. Census Bureau Microanalysis Tool](https://data.census.gov/mdat/#/) provided estimates of population breakdown by demographic groups, including White men, White women, non-White men and non-White women. This allowed us to approximate the predicted number of fatal cases from COVID-19 by group given the population breakdown in the United States by group. 
