/* 
Do file of commands used for Stata lecture 
Linear regression and correlation

Date

TPM, modified from JR
*/ 


///-------------------------------------------------------------///
///---------------prepare for analysis--------------------------///
///-------------------------------------------------------------///
///start a log file
log using "10\week10.txt" , replace text


///bring in .dta stata data file. Today we're going to use one of Stata's files
sysuse auto
describe




///-------------------------------------------------------------///
///----------------Linear regression----------------------------///
///-------------------------------------------------------------///
*is headroom associated with gas mileage? 

///check for normality 
tabstat headroom mpg, stats(mean p50 sd)
summ headroom
summ mpg
hist headroom
hist mpg
hist price


///are the varibles linearlly related? 
scatter mpg headroom

///linear regression command
regress headroom mpg

///plot variables with an added line of fitted values
twoway (scatter headroom mpg) (lfit headroom mpg), title("MPG and headroom with fitted values") subtitle("-twoway (scatter headroom mpg) (lfit headroom mpg)-")

///assess normality of the residuals
predict head_r, residual
hist head_r


///-------------------------------------------------------------///
///----------------Correlation----------------------------------///
///-------------------------------------------------------------///

///pearson correlation
corr mpg headroom 
pwcorr mpg headroom, sig //this gives the p-value associated with correlation




///spearman correlation
spearman mpg headroom 

spearman price mpg //price is not normally distributed, so a good fit for spearman

*if you have more than two variales, use this option to get the p-value printed
spearman mpg headroom price,stats(rho  p)


///-------------------------------------------------------------///
///----------------tip of the day-------------------------------///
///-------------------------------------------------------------///
*table 1 manuscripts: ready for publication

///tabout
findit tabout
tabout foreign rep78 ///
	using table1.txt, /// 
	cells(mean price mean mpg mean headroom)   ///  
	replace sum

///table1
findit table1
table1, by(foreign) vars(price conts \ mpg contn %2.1f \ headroom conts)



