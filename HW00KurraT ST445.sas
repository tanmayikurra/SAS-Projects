*
Programmed by: Tanmayi Kurra (ST445-002)
Programmed on: 2024-09-04
Programmed to: Create a Partial Weather Listing report for Homework 0

Modified by: Tanmayi Kurra
Modified on: 2024-09-04
Modified to: Complete Homework 0
;

*This gives a library with the st445/data path;
libname InputDS 'L:\st445\Data';

*Gives a pdf file with the Festival style;
ods pdf file='HW0 Kurra Partial Weather Listing.pdf' style=Festival;

*Prints information in the log about the output objects created in the ods file;
ods trace on;

*This excludes the EngineHost table in the ods file;
ods exclude EngineHost;

*Makes a proc contents table for the RaleighTempPrecip dataset;
proc contents data=InputDS.RaleighTempPrecip order=varnum;
title1 'Descriptor Information Before Sorting';
title2 'with Variable Information in Column Order';
run;

*Makes a proc contents table for the RTPsorted dataset without listing variable-level metadata;
proc contents data=InputDS.RTPsorted varnum;
title1 'Descriptor Information After Sorting';
title2 'with Variable Information in Column Order';
run;

*Prints out records from the most recent five years of the RTPsorted data and the variables containing maximum temperature in January;
proc print data=InputDS.RTPsorted (obs=5);
var Year TempMax1-TempMax31;
title1 'January Daily Max Temperatures';
title2 'Most Recent 5 Years';
run;

*Prints records from the most recent five years of the RTPsorted data and the minimum and maximum temperatures in the first week of January;
proc print data=InputDS.RTPsorted (obs=5);
var Year TempMin1-TempMin7 TempMax1-TempMax7;
title1 'January 1st-7th Temperature Extremes';
title2 'Most Recent 5 Years';
run;


*Prints records from the most recent ten years of the RTPsorted data and the precipitation values of each day during the 10 years;
proc print data=InputDS.RTPsorted (obs=10);
var Year Prcp:;
title1 'Daily Rainfall';
title2 'Most Recent 10 Years';
run;

*Stops reporting objects created in the ods file in the log;
ods trace off;

*Closes the ods pdf file;
ods pdf close;
