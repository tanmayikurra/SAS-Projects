/*
Programmed by: Tanmayi Kurra (ST445-002)
Programmed on: 2024-09-11
Programmed to: Complete Homework 1

Modified by: N/A
Modified on: N/A
Modified to: N/A
*/
*This changes the directory to L: drive.;
x "cd L:\";

*This creates a library called InputDS which takes the datasets from the st445/Data path in the current directory.;
libname InputDS "st445\Data";

*Change directory to S: drive;
x "cd S:\";

*Creates a library for HW1 in the currently directory;
libname HW1 ".";

*Sets SAS options which includes page numbers and excludes the date on the output;
options number nodate;

*Closes all current ODS destinations;
ods _all_ close;

* Opens a PDF destination in the current S: drive directory for the output using the Festival style.;
ods pdf file = "HW1 Kurra Weather Analysis.pdf" style = Festival;

*Sorts the RTPtall dataset in the InputDS library by Year (in descending order), MonthN and DayN.;
*Outputs this sorted data to a new dataset called sortedRTPtall in the HW1 library.;
proc sort data=InputDS.RTPtall out=HW1.sortedRTPtall;
  by descending Year MonthN DayN;
run;

*Creates a proc contents tables, displaying variable information in the order they appear in the dataset and their sort information.;
*Excludes the attributes and enginehost table and removes the default proc contents title.;
ods noproctitle;
ods exclude attributes enginehost;
title "Descriptor Information After Sorting";
proc contents data=HW1.sortedRTPtall varnum;
run;
title;

*This creates a format that groups the numberic variables Tmin and Tmax in specified ranges.;
*These formats will be used in the subsequent step.;
*The format table produced in this step is excluded in the ods file.;
ods exclude all;
proc format fmtlib noprint;
  value tempMin (fuzz=0)  . = "Not Recorded"
                          low -< 32 = "<32"
                          32 -< 50 = "[32,50)"
                          50 -< 70 = "[50,70)"
                          70 - high = ">=70";
  value tempMaxim (fuzz=0)  low - 49 = "<50"
                            50 - 74 = "[50,75)"
                            75 - 89 = "[75,90)"
                            90 - high = ">=90";
run;
ods exclude none;

*Displays summary statistics for Tmax, Tmin, and Prcp during June, July, and August, grouped by 15-year intervals starting from 1900.;
*Includes statistics such as the number of observations, median, IQR, mean, and standard deviation, with the output formatted to two decimal places.;
ods noproctitle;
title "Raleigh, NC: Summary of Temperature and Precipitation";
title2 "in June, July, and August";
title3 height=8pt "by 15-Year Groups (Since 1887)";
footnote height=8pt j=left "Excluding Years Prior to 1900";
proc means data=HW1.sortedRTPtall nonobs n median qrange mean stddev maxdec=2;
  class GroupDesc;
  var Tmax Tmin Prcp;
  where Year GE 1900 & lowcase(MonthC) in ("june", "july", "august");
  label Tmax = "Daily Max Temp" Tmin = "Daily Min Temp" Prcp = "Daily Precip.";
run;
title;
footnote;

*Generates the weighted cross-tabulation of Tmin and Tmax and precipitation amounts by 15-year groupings, excluding weekend data.;
*This includes missing data.;
ods noproctitle;
title "Raleigh, NC: Amount of Precipitation by 15-Year Group (Since 1887)";
title2 "and by Temperature Group Cross-Classification";
footnote height=8pt j=left "Excluding Weekends";
proc freq data=HW1.sortedRTPtall;
  where lowcase(DayC) not in ("saturday", "sunday");
  tables GroupDesc Tmin*Tmax / missing;
  format Tmin tempMin. Tmax tempMaxim.;
  weight Prcp;
run;
title;
footnote;

*Performs GLM analysis to predict precipitation based on temperature and day of the week.;
title "Predicting Precipitation from Temperature (Min&Max) and Day of the Week";
title2 "Using Independent Models for each 15-Year Group (Since 1887)";
footnote height=8pt j=left "Only displaying the Type III ANOVA Table";
ods select 'Type III Model ANOVA';
proc glm data=HW1.sortedRTPtall;
  by descending GroupDesc;
  class DayC;
  model Prcp = Tmax Tmin DayC;
run;
title;
footnote;

*Prints the temperature and precipitation values for January and December 2021;
*This output is grouped into two tables by the Month.; 
title "Listing of Temperature and Precipitation Values";
footnote height=8pt j=left "Restricted to January and December of 2021";
proc print data=HW1.sortedRTPtall label noobs;
  by MonthN;
  id MonthC DayN;
  var DayC Tmin Tmax Prcp;
  where Year = 2021 AND (MonthN = 1 OR MonthN = 12);
  format Prcp 4.2;
  sum Prcp;
  sumby MonthN;
run;
title;
footnote;

*Closes the PDF output;
ods pdf close;

*Quits the current SAS session;
quit;
