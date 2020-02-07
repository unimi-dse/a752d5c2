# PM10 Comparing
## Analysis of European capital cities

This project offers a tool that is useful in order to compare the pm10 concentration levels in the most important european cities for the period *27 October - 31 December 2019*.

Cvs file containing data has been collected by [OpenAQ](https://openaq.org/#/?_k=6jfjk3), a website that offers open air quality data.

## Install 

```R
# first install the R package "devtools" if not installed
devtools::install_github("unimi-dse/a752d5c2")  
```
## Usage

```R
require(pm10comparing)  
comparing_pm10()   
```
## App Structure

The app is structured on four tabs:


**First tab:** 
>***Plot:*** It provides a first sight on the data. Thanks to the time series plot, it's observable in only one graph the proceeding of the pm10 levels in the selected cities;

**Second tab:** 
>***Summary:*** this tab contains the main statistics information of the two cities selected (*mean, median, min, max...*);

**Third tab:** 
>***T-test:*** in this tab the user can analyse the output of the t-test applied on the values of pm10 concentration of the two cities selected. It contains informations like *t-statistics, p_value and means*;

**Fourth tab:** 
>***BoxPlot:*** in the last tab, the boxplots of the values of pm10 of the two cities selected are placed side by side in order to do a final comparison between the pm10 concentration.
 
