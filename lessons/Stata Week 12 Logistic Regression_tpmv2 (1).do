

///-------------------------------------------------------------///
///---------------prepare for analysis--------------------------///
///-------------------------------------------------------------///
///start a log file
log using "12\week12.txt" , replace text


///bring in .dta stata data file. Today we're going to use a stata web file. Find available options here: https://www.stata-press.com/data/r16/r.html
webuse lbw.dta
describe

///always save a new version as you work, don't edit original data

save "C:\Users\ureka\OneDrive\Desktop\Stata Fall 2024\Week 12\lbw.dta", replace 

///label some variables
tab low
label def YNFMT 0 "no" 1 "yes"
label val low YNFMT
tab low

///create a binary variable from ptl (history of pre-term labor)
*why? Because the number of women who had 2 or 3 is really low
tab ptl
recode ptl (2/3=1), gen(ptlYN)
label var ptlYN "Any history of premature labor"
label val ptlYN YNFMT
tab ptlYN

///create a variable that numbers physician visits as 0, 1, or 2+
tab ftv
recode ftv (2/6=2 "2+"), gen(ftv_cat)
label var ftv_cat "Number of visits to physician during 1st trimester"
tab ftv_cat

recode ftv (1/6=1), gen(ftvYN)
label val ftvYN YNFMT
tab ftvYN

///-------------------------------------------------------------///
///----------------Pre-analysis checks--------------------------///
///-------------------------------------------------------------///
*outcome of interest = low (low birth weight binary)

///summary stats and comparisons
tab smoke low, row col chi
tab low ptlYN, col
tab low race, col chi

graph box lwt, over(low)
sdtest lwt, by(low) 
ttest lwt, by(low) 

///-------------------------------------------------------------///
///----------------Logistic regression--------------------------///
///-------------------------------------------------------------///
///simple logistic regression first  // 0 is the comparison of 1
// Odds ratio compares smokers to nonsmokers
logistic low smoke

///using factor notation and changing the comparator 
logistic low i.race
logistic low ib2.race  // position of reference: ib2 = second; ib3 = third

///multiple logisic regression
logistic low smoke ptlYN i.race lwt 


///-------------------------------------------------------------///
///----------------Confounding----------------------------------///
///-------------------------------------------------------------///
*is smoking status confounded by race?
*1) examine relationship between smoking status and race
tab smoke race, col chi

*2) examine relationship between low and race
tab low race, col chi

///see if the unadjusted regression estiamte varies from the adjusted
logistic low smoke
logistic low smoke i.race
	///display (2.02-3.05)/2.02 ~ 50%
	///--> general rule is to look for variation of >10% 



///-------------------------------------------------------------///
///----------------Interaction----------------------------------///
///-------------------------------------------------------------///
*is the relationship between exposure and outcome different based on another variable? 
*is the relationship between premature labor history and low birth weight vary based on uterine iritability? 

///examine the difference
tab  ptlYN low if ui==0, col
tab low ptlYN if ui==1, col
bysort ui: logistic low ptlYN

logistic low ptlYN 
margins, over(ptlYN ui) expression(exp(xb())) 

// OR for ptlYN at ui=0 is 1.625 / 0.296 = 5.48
// OR for ptlYN at ui=1 is 1.25 / 0.9 = 1.38



///including interaction in a regression
logistic low ptlYN
logistic low ui
logistic low ptlYN ui
logistic low ptlYN##ui

///-------------------------------------------------------------///
///----------------2x2 tables-----------------------------------///
///-------------------------------------------------------------///

///cohort studies use -cs-
cs low smoke 
csi 30 25 19 10


///case control or cross sectional use -cc-
cc low smoke 
cci 30 25 19 10



