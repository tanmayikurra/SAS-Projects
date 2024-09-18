*************************
Author : Tanmayi Kurra
Date : 04/30/2024
Purpose : Final Proj 
*************************

*PROGRAMMING QUESTIONS PART;

* Question 1
I created a permanent library named TKURRA and put my homework here;
LIBNAME tkurra '/home/u63733680/tkurra';

*QUESTION 2;
*FILENAME statement that creates a reference to the tkurra.csv url.;
FILENAME fromWEB URL 'https://www4.stat.ncsu.edu/~online/ST307/Data/tkurra_house.csv';

*PROC IMPORT step that imports the tkurra_house.csv url file into a SAS dataset so that it's useable in SAS. I also saved it to the TKURRA library.;
PROC IMPORT DATAFILE=fromWEB
    DBMS=CSV
    OUT=TKURRA.HOUSE;
    GUESSINGROWS=MAX;
RUN;

*QUESTION 3;
* Used the if function to delete any values called "Partial" in SaleCondition or less than or equal to 1079.4 in GrLivArea. ;
* I also created a new variable NewSalePrice which is the salePrice/100000. Finally, I used the drop function to delete the TotalBsmtSF ExterQual variables.;
DATA work.MYHOUSE;
SET TKURRA.HOUSE;
IF ((SaleCondition = "Partial") OR (GrLivArea <= 1079.4)) THEN DELETE;
NewSalePrice = SalePrice / 100000;
DROP TotalBsmtSF ExterQual;
RUN;

*QUESTION 4;
*I used the sgplot function to create a scatterplot with FullBath in the x-axis and SalePrice in the y-axis, and are also grouped by BldgType variable using the group function.;
PROC SGPLOT DATA=WORK.MYHOUSE;
SCATTER X = FullBath Y = SalePrice / GROUP = BldgType; RUN;
**I see a pattern of the average sale prices being higher for 2.0 fullbaths than 1.0.
*QUESTION 5;
* I used the GLM stepusing SalePrice as the response variable and FullBath and BsmUnfSF as predictors.;
PROC GLM DATA = WORK.MYHOUSE PLOTS = all;
MODEL SalePrice = FullBath BsmtUnfSF/CLPARM; RUN;
QUIT;

*******************************************************************************************************************
*Open-Ended Tasks
*******************************************************************************************************************
* Question 1
a) This is the website from Kaggle of the dataset : https://www.kaggle.com/datasets/uciml/red-wine-quality-cortez-et-al-2009;
*Is there a linear relationship between density and sulphates in wine?;

* Question 2;
PROC IMPORT DATAFILE = '/home/u63733680/tkurra/winequality-red.csv'
	DBMS=CSV
	OUT=TKURRA.WINEDATA;
	GETNAMES=YES;
RUN;



*QUESTION 3;
PROC REG DATA = TKURRA.WINEDATA;
MODEL sulphates = chlorides;
RUN;

*This data showed me that there is a weak linear relationship between Sulphates and Chlorides in the sample wine data. 
* Looking at the fit plot for sulphates, we can determine that the correlation coefficient is arount 0.5, which indicates
* a weak linear relationship. We observed a mild connection between sulphates and chlorides in wine, 
*but it's not strong enough to reliably predict one from the other.
* Other factors likely play a role in determining sulphate levels in wine.